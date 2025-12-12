import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/repositories/collected_post_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/exploration/models/travel_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class TravelPostCard extends StatefulWidget {
  final Post post;
  final String postId;
  final int collectsCount;

  const TravelPostCard({
    super.key,
    required this.post,
    required this.postId,
    required this.collectsCount,
  });

  @override
  State<TravelPostCard> createState() => _TravelPostCardState();
}

class _TravelPostCardState extends State<TravelPostCard> {
  late CollectedPostRepository _collectedPostRepo;
  bool _isCollected = false;
  bool _isCheckingCollection = true;
  bool _isToggling = false;
  late int _currentCollectsCount;

  @override
  void initState() {
    super.initState();
    _collectedPostRepo = CollectedPostRepository(FirestoreService());
    _currentCollectsCount = widget.collectsCount;
    _checkIfCollected();
  }

  Future<void> _checkIfCollected() async {
    try {
      final userVm = context.read<UserViewModel>();
      final uid = userVm.user?.uid;
      if (uid == null) {
        if (mounted) {
          setState(() {
            _isCheckingCollection = false;
          });
        }
        return;
      }

      final isCollected = await _collectedPostRepo.isCollected(
        uid,
        widget.postId,
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

  Future<void> _toggleCollect() async {
    if (_isToggling) return;

    final userVm = context.read<UserViewModel>();
    final uid = userVm.user?.uid;
    if (uid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to save favorites')),
        );
      }
      return;
    }

    setState(() {
      _isToggling = true;
    });

    try {
      final newState = await _collectedPostRepo.toggleCollection(
        uid,
        widget.postId,
      );
      if (mounted) {
        setState(() {
          _isCollected = newState;
          _currentCollectsCount += newState ? 1 : -1;
          _isToggling = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error toggling collection: $e');
      if (mounted) {
        setState(() {
          _isToggling = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: AppWidgetStyles.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with profile avatar
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: _buildImage(widget.post.imageUrl),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: _getImageProvider(
                    widget.post.authorImageUrl,
                  ),
                ),
              ),
            ],
          ),

          // Title, location, likes
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.post.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.post.location,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: ManropeFontWeight.light,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 50,
                    child: _isCheckingCollection
                        ? AppButton.iconTextSmall(
                            onPressed: null,
                            text: "$_currentCollectsCount",
                            iconSize: 14,
                            minHeight: 30,
                            minWidth: 40,
                            icon: CupertinoIcons.heart,
                            boxShadow: [],
                            textStyleOverride: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: ManropeFontWeight.bold,
                                ),
                            backgroundVariant: BackgroundVariant.primaryTrans,
                          )
                        : AppButton.iconTextSmall(
                            onPressed: _isToggling ? null : _toggleCollect,
                            text: "$_currentCollectsCount",
                            iconSize: 14,
                            minHeight: 30,
                            minWidth: 40,
                            icon: _isCollected
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            boxShadow: [],
                            textStyleOverride: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: ManropeFontWeight.bold,
                                ),
                            backgroundVariant: BackgroundVariant.primaryTrans,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build image based on URL type
  Widget _buildImage(String imageUrl) {
    // Check if it's a network URL (http/https)
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default asset if network image fails
          return Image.asset(
            'assets/images/exp_msia.png',
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 160,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      // It's a local asset
      return Image.asset(
        imageUrl,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  ImageProvider _getImageProvider(String imageUrl) {
    // Check if it's a network URL (http/https)
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    } else {
      // It's a local asset
      return AssetImage(imageUrl);
    }
  }
}
