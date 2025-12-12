import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class NotesItineraryPageHeaderSection extends StatelessWidget {
  const NotesItineraryPageHeaderSection({
    super.key,
    required this.userVm,
    this.isViewMode = false,
  });

  final UserViewModel userVm;
  final bool isViewMode;

  @override
  Widget build(BuildContext context) {
    // Only watch ItineraryViewModel in edit mode
    final itineraryVm = isViewMode ? null : context.watch<ItineraryViewModel>();
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
                if (isViewMode)
                  AppButton.iconOnly(
                    icon: CupertinoIcons.heart,
                    minWidth: 80,
                    minHeight: 40,
                    onPressed: () {
                      // TODO: Implement add to favorites
                      debugPrint('💗 Add to favorites pressed');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to favorites!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
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
                if (isViewMode)
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
                        final user = userVm.user;
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
