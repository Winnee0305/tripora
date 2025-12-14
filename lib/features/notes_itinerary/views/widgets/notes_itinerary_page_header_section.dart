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
    this.authorName,
    this.authorImageUrl,
    this.collectsCount = 0,
  });

  final UserViewModel userVm;
  final bool isViewMode;
  final String? postId;
  final String? authorName;
  final String? authorImageUrl;
  final int collectsCount;

  @override
  State<NotesItineraryPageHeaderSection> createState() =>
      _NotesItineraryPageHeaderSectionState();
}

class _NotesItineraryPageHeaderSectionState
    extends State<NotesItineraryPageHeaderSection> {
  late final CollectedPostRepository _collectedPostRepo;
  bool _isCollected = false;
  bool _isCheckingCollection = true;
  late int _currentCollectsCount;

  @override
  void initState() {
    super.initState();
    _collectedPostRepo = CollectedPostRepository(FirestoreService());
    _currentCollectsCount = widget.collectsCount;
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
          // Update count optimistically
          _currentCollectsCount = newState
              ? _currentCollectsCount + 1
              : _currentCollectsCount - 1;
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
    final theme = Theme.of(context);
    // Only watch ItineraryViewModel in edit mode
    final itineraryVm = widget.isViewMode
        ? null
        : context.watch<ItineraryViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: widget.isViewMode
            ? _buildViewModeHeader(context, theme)
            : _buildEditModeHeader(context, itineraryVm),
      ),
    );
  }

  Widget _buildViewModeHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        AppButton.iconOnly(
          icon: CupertinoIcons.back,
          onPressed: () => Navigator.pop(context, true),
          backgroundVariant: BackgroundVariant.secondaryFilled,
        ),

        // Author info (middle)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: _getImageProvider(
                    widget.authorImageUrl ??
                        'assets/images/exp_profile_picture.png',
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.authorName ?? 'Unknown Author',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Collects count button
        AppButton.iconTextSmall(
          icon: _isCollected ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          text: '$_currentCollectsCount',
          minWidth: 80,
          minHeight: 40,
          onPressed: _isCheckingCollection ? null : _toggleFavorite,
          backgroundVariant: BackgroundVariant.secondaryFilled,
        ),
      ],
    );
  }

  Widget _buildEditModeHeader(
    BuildContext context,
    ItineraryViewModel? itineraryVm,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton.iconOnly(
          icon: CupertinoIcons.back,
          onPressed: () => _handleBackPress(context, itineraryVm),
          backgroundVariant: BackgroundVariant.secondaryFilled,
        ),
        Row(
          children: [
            // Cloud sync button
            if (itineraryVm != null && itineraryVm.isSync)
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

            // Share button
            AppButton.iconOnly(
              icon: CupertinoIcons.share,
              minWidth: 80,
              minHeight: 40,
              onPressed: () async {
                debugPrint('📤 Share button pressed');

                // Check if already published
                final existingPost = await itineraryVm?.getPublishedPost();

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
                  debugPrint('✅ Published successfully with postId: $postId');
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
          onPressed: () => _handleHomePress(context, itineraryVm),
          backgroundVariant: BackgroundVariant.secondaryFilled,
        ),
      ],
    );
  }

  /// Helper method to get the appropriate ImageProvider for author avatar
  ImageProvider _getImageProvider(String imageUrl) {
    // Check if it's an asset path
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }

    // Otherwise treat as network URL
    return NetworkImage(imageUrl);
  }

  /// Handle back button press with sync check
  Future<void> _handleBackPress(
    BuildContext context,
    ItineraryViewModel? itineraryVm,
  ) async {
    if (itineraryVm == null || itineraryVm.isSync) {
      // If synced or no viewmodel, just pop
      Navigator.pop(context);
      return;
    }

    // Show alert dialog
    final shouldSync = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'Your itinerary has unsaved changes. Do you want to save them before leaving?',
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Discard'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSync == true && context.mounted) {
      // Trigger sync
      await itineraryVm.syncItineraries();
    }

    // Pop the page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  /// Handle home button press with sync check
  Future<void> _handleHomePress(
    BuildContext context,
    ItineraryViewModel? itineraryVm,
  ) async {
    if (itineraryVm == null || itineraryVm.isSync) {
      // If synced or no viewmodel, just navigate home
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    // Show alert dialog
    final shouldSync = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'Your itinerary has unsaved changes. Do you want to save them before leaving?',
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Discard'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSync == true && context.mounted) {
      // Trigger sync
      await itineraryVm.syncItineraries();
    }

    // Navigate to home
    if (context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
