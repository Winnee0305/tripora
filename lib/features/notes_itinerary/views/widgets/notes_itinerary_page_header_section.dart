import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/repositories/collected_post_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class NotesItineraryPageHeaderSection extends StatefulWidget {
  const NotesItineraryPageHeaderSection({
    super.key,
    required this.userVm,
    this.isViewMode = false,
    this.postId,
  });

  final UserViewModel userVm;
  final bool isViewMode;
  final String? postId;

  @override
  State<NotesItineraryPageHeaderSection> createState() =>
      _NotesItineraryPageHeaderSectionState();
}

class _NotesItineraryPageHeaderSectionState
    extends State<NotesItineraryPageHeaderSection> {
  late final CollectedPostRepository _collectedPostRepo;
  bool _isCollected = false;
  bool _isCheckingCollection = true;

  @override
  void initState() {
    super.initState();
    _collectedPostRepo = CollectedPostRepository(FirestoreService());
    if (widget.isViewMode && widget.postId != null) {
      _checkIfCollected();
    }
  }

  Future<void> _checkIfCollected() async {
    if (widget.postId == null) return;

    try {
      final uid = widget.userVm.user?.uid;
      if (uid == null) return;

      final isCollected = await _collectedPostRepo.isCollected(
        uid,
        widget.postId!,
      );
      if (mounted) {
        setState(() {
          _isCollected = isCollected;
          _isCheckingCollection = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error checking collection status: $e');
      if (mounted) {
        setState(() {
          _isCheckingCollection = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (widget.postId == null) return;

    final uid = widget.userVm.user?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save favorites')),
      );
      return;
    }

    try {
      final newState = await _collectedPostRepo.toggleCollection(
        uid,
        widget.postId!,
      );
      if (mounted) {
        setState(() {
          _isCollected = newState;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newState ? 'Added to favorites!' : 'Removed from favorites',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorites: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only watch ItineraryViewModel in edit mode
    final itineraryVm = widget.isViewMode
        ? null
        : context.watch<ItineraryViewModel>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton.iconOnly(
              icon: CupertinoIcons.back,
              onPressed: () => Navigator.pop(context),
              backgroundVariant: BackgroundVariant.secondaryFilled,
            ),
            Row(
              children: [
                // View mode: Show favorite button
                if (widget.isViewMode)
                  _isCheckingCollection
                      ? AppButton.iconOnly(
                          icon: CupertinoIcons.heart,
                          minWidth: 80,
                          minHeight: 40,
                          onPressed: null,
                          backgroundVariant: BackgroundVariant.secondaryFilled,
                        )
                      : AppButton.iconOnly(
                          icon: _isCollected
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          minWidth: 80,
                          minHeight: 40,
                          onPressed: _toggleFavorite,
                          backgroundVariant: BackgroundVariant.secondaryFilled,
                        )
                // Edit mode: Show cloud sync button
                else if (itineraryVm != null && itineraryVm.isSync)
                  AppButton.iconOnly(
                    minWidth: 80,
                    minHeight: 40,
                    iconWidget: Image.asset(
                      'assets/icons/cloud_check.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {},
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  )
                else if (itineraryVm != null && itineraryVm.isUploading)
                  AppButton.iconOnly(
                    minWidth: 80,
                    minHeight: 40,
                    iconWidget: Image.asset(
                      'assets/icons/cloud_sync.gif',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {},
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  )
                else
                  AppButton.iconOnly(
                    minWidth: 80,
                    minHeight: 40,
                    iconWidget: Image.asset(
                      'assets/icons/cloud_upload.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      itineraryVm?.syncItineraries();
                    },
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  ),
                const SizedBox(width: 10),

                // View mode: Show duplicate button
                if (widget.isViewMode)
                  AppButton.iconOnly(
                    icon: CupertinoIcons.doc_on_doc,
                    minWidth: 80,
                    minHeight: 40,
                    onPressed: () {
                      // TODO: Implement duplicate itinerary
                      debugPrint('📋 Duplicate itinerary pressed');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Itinerary duplicated!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  )
                // Edit mode: Show share button
                else
                  AppButton.iconOnly(
                    icon: CupertinoIcons.share,
                    minWidth: 80,
                    minHeight: 40,
                    onPressed: () async {
                      debugPrint('📤 Share button pressed');

                      // Check if already published
                      final existingPost = await itineraryVm
                          ?.getPublishedPost();

                      if (existingPost != null && context.mounted) {
                        // Show alert dialog for confirmation
                        final shouldUpdate = await showCupertinoDialog<bool>(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text('Update Published Itinerary?'),
                            content: const Text(
                              'This itinerary has already been published. Do you want to update it with your latest changes?',
                            ),
                            actions: [
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        );

                        if (shouldUpdate != true) {
                          debugPrint('❌ User cancelled update');
                          return;
                        }
                      }

                      try {
                        // Get user data for post
                        final user = widget.userVm.user;
                        if (user == null) {
                          throw Exception('User data not available');
                        }

                        final userName = '${user.firstname} ${user.lastname}';
                        // Sanitize profile image URL - treat whitespace-only as null
                        final userImageUrl =
                            (user.profileImageUrl != null &&
                                user.profileImageUrl!.trim().isNotEmpty)
                            ? user.profileImageUrl
                            : null;

                        debugPrint(
                          '👤 Publishing with userName: $userName, userImageUrl: $userImageUrl',
                        );

                        final postId = await itineraryVm?.publishItinerary(
                          userName: userName,
                          userImageUrl: userImageUrl,
                        );
                        debugPrint(
                          '✅ Published successfully with postId: $postId',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                existingPost != null
                                    ? 'Itinerary updated successfully!'
                                    : 'Itinerary published successfully!',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint('❌ Error publishing itinerary: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to publish: $e'),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  ),
              ],
            ),

            AppButton.iconOnly(
              icon: CupertinoIcons.home,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              backgroundVariant: BackgroundVariant.secondaryFilled,
            ),
          ],
        ),
      ),
    );
  }
}
