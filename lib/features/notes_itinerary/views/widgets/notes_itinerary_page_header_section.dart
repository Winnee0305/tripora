import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';

class NotesItineraryPageHeaderSection extends StatelessWidget {
  const NotesItineraryPageHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final itineraryVm = context.watch<ItineraryViewModel>();
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
                // Cloud sync button
                if (itineraryVm.isSync)
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
                else if (itineraryVm.isUploading)
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
                      itineraryVm.syncItineraries();
                    },
                    backgroundVariant: BackgroundVariant.secondaryFilled,
                  ),
                const SizedBox(width: 10),

                // Share button
                AppButton.iconOnly(
                  icon: CupertinoIcons.share,
                  minWidth: 80,
                  minHeight: 40,
                  onPressed: () async {
                    debugPrint('📤 Share button pressed');

                    // Check if already published
                    final existingPost = await itineraryVm.getPublishedPost();

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
                      final postId = await itineraryVm.publishItinerary();
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
