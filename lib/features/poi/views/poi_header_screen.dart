// views/place_detail_page.dart
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/utils/format_utils.dart';
import '../viewmodels/poi_page_viewmodel.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class PoiHeaderScreen extends StatefulWidget {
  final PoiPageViewmodel vm;
  const PoiHeaderScreen({super.key, required this.vm});

  @override
  State<PoiHeaderScreen> createState() => _PoiHeaderScreenState();
}

class _PoiHeaderScreenState extends State<PoiHeaderScreen> {
  late int _currentCollectsCount;
  late bool _isCollected;
  bool _isToggling = false;

  @override
  void initState() {
    super.initState();
    _currentCollectsCount = widget.vm.collectsCount;
    _isCollected = widget.vm.isCollected;
  }

  @override
  void didUpdateWidget(PoiHeaderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentCollectsCount = widget.vm.collectsCount;
    _isCollected = widget.vm.isCollected;
  }

  Future<void> _toggleFavorite() async {
    if (widget.vm.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save POIs')),
      );
      return;
    }

    if (_isToggling) return;

    setState(() {
      _isToggling = true;
      _isCollected = !_isCollected;
      _currentCollectsCount += _isCollected ? 1 : -1;
    });

    try {
      await widget.vm.toggleCollection(widget.vm.userId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isCollected
                  ? 'POI saved to your collection'
                  : 'POI removed from collection',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCollected = !_isCollected;
          _currentCollectsCount += _isCollected ? 1 : -1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isToggling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10), // outer spacing
          child: ClipRRect(
            borderRadius: BorderRadius.circular(58), // adjust radius
            child: widget.vm.poi!.imageUrl.isEmpty
                ? Image.asset(
                    'assets/logo/tripora.JPG',
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    widget.vm.poi!.imageUrl,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/logo/tripora.JPG',
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
        ),

        // ---- Top Buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.iconOnly(
                  icon: CupertinoIcons.back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundVariant: BackgroundVariant.secondaryFilled,
                ),
                AppButton.iconTextSmall(
                  minWidth: 64,
                  icon: _isCollected
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  onPressed: _isToggling ? null : _toggleFavorite,
                  backgroundVariant: BackgroundVariant.secondaryFilled,
                  text: '$_currentCollectsCount',
                ),
              ],
            ),
          ),
        ),

        // ----- Title Section
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 38),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: AppWidgetStyles.cardDecoration(
              context,
            ).copyWith(borderRadius: BorderRadius.circular(20)),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 220,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.vm.poi!.tags
                                    .map(
                                      (tag) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6.0,
                                        ), // spacing between buttons
                                        child: AppButton.textOnly(
                                          text: tag,
                                          backgroundVariant:
                                              BackgroundVariant.primaryTrans,
                                          onPressed: () {},
                                          minHeight: 14,
                                          minWidth: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          textStyleVariant:
                                              TextStyleVariant.small,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          const Spacer(),
                          AppButton.iconTextSmall(
                            icon: CupertinoIcons.star_fill,
                            onPressed: () {},
                            text: " ${widget.vm.poi!.rating}",
                            textStyleOverride: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                            boxShadow: [],
                            radius: 10,
                            iconSize: 12,
                            minWidth: 60,
                            minHeight: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // ---- Location Name
                      Text(
                        widget.vm.poi!.name,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: ManropeFontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 0,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // align to start
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.location_solid,
                                size: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${extractMalaysiaState(widget.vm.poi!.address)}, ${widget.vm.poi!.country}",

                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: ManropeFontWeight.light,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Location
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
