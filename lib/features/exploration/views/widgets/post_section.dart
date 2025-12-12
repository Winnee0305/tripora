import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/post_repository.dart';
import 'package:tripora/core/repositories/trip_repository.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/day_selection_viewmodel.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/core/services/firebase_storage_service.dart';
import 'package:tripora/features/exploration/models/travel_post.dart';
import 'package:tripora/features/exploration/viewmodels/post_section_viewmodel.dart';
import 'package:tripora/features/exploration/views/widgets/travel_post_card.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/post_itinerary_view_model.dart';
import 'package:tripora/features/notes_itinerary/views/notes_itinerary_page.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key});

  void _navigateToPostItinerary(BuildContext context, PostData postData) async {
    // Load post itinerary data first
    final postItineraryVm = PostItineraryViewModel(
      FirestoreService(),
      postData.postId,
    );
    await postItineraryVm.loadPostData();

    if (!context.mounted) return;

    // Create ViewModels for view mode
    final firestoreService = FirestoreService();
    final tripVm = TripViewModel(
      TripRepository(
        firestoreService,
        postData.userId,
        FirebaseStorageService(),
      ),
    )..setSelectedTrip(postItineraryVm.trip!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            // Provide PostItineraryViewModel (it has the same interface as ItineraryViewModel)
            ChangeNotifierProvider<PostItineraryViewModel>.value(
              value: postItineraryVm,
            ),
            // Provide TripViewModel with trip data from post
            ChangeNotifierProvider<TripViewModel>.value(value: tripVm),
            // DaySelectionViewModel for day navigation
            ChangeNotifierProvider(
              create: (_) => DaySelectionViewModel(
                startDate: postData.startDate,
                endDate: postData.endDate,
              )..selectDay(0),
            ),
            // Pass UserViewModel from parent
            ChangeNotifierProvider.value(value: context.read<UserViewModel>()),
          ],
          child: const NotesItineraryPage(currentTab: 1, isViewMode: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create a temporary PostRepository just for fetching public posts
    // This doesn't need authentication since posts are public
    final postRepo = PostRepository(
      FirestoreService(),
      '', // Empty uid for public access
    );

    return ChangeNotifierProvider(
      create: (_) => PostSectionViewmodel(postRepo, FirestoreService()),
      child: Scaffold(
        body: Consumer<PostSectionViewmodel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${vm.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => vm.refreshPosts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (vm.posts.isEmpty) {
              return const Center(
                child: Text(
                  'No posts yet. Be the first to share your itinerary!',
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => vm.refreshPosts(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: MasonryGridView.count(
                  crossAxisCount: 2, // number of columns
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  itemCount: vm.posts.length,
                  itemBuilder: (context, index) {
                    final postData = vm.posts[index];

                    // Handle trip image URL
                    final imageUrl =
                        (postData.tripImageUrl == null ||
                            postData.tripImageUrl!.isEmpty)
                        ? 'assets/images/exp_msia.png'
                        : postData.tripImageUrl!;

                    // Fetch user profile image dynamically
                    return FutureBuilder<String?>(
                      future: vm.getUserProfileImage(postData.userId),
                      builder: (context, snapshot) {
                        // Use fetched profile image or fallback to default
                        final authorImageUrl =
                            (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.trim().isNotEmpty)
                            ? snapshot.data!
                            : 'assets/images/exp_profile_picture.png';

                        final post = Post(
                          title: postData.tripName,
                          location: postData.destination,
                          imageUrl: imageUrl,
                          authorImageUrl: authorImageUrl,
                          likes: 0, // TODO: Implement likes feature
                        );
                        return GestureDetector(
                          onTap: () {
                            _navigateToPostItinerary(context, postData);
                          },
                          child: TravelPostCard(post: post),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
