import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/poi/views/poi_page.dart';
import 'package:tripora/features/profile/viewmodels/collects_poi_viewmodel.dart';

class ProfilePlacesCollectsContent extends StatefulWidget {
  final VoidCallback? onNavigateBack;

  const ProfilePlacesCollectsContent({super.key, this.onNavigateBack});

  @override
  State<ProfilePlacesCollectsContent> createState() =>
      _ProfilePlacesCollectsContentState();
}

class _ProfilePlacesCollectsContentState
    extends State<ProfilePlacesCollectsContent> {
  late CollectsPoiViewModel _vm;

  void _onPoiCollectChanged() {
    // Trigger parent callback to refresh profile stats
    widget.onNavigateBack?.call();
  }

  Future<void> _refreshPoisData() async {
    await _vm.refreshCollectedPois();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectsPoiViewModel>(
      builder: (context, vm, _) {
        _vm = vm;

        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.collectedPois.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshPoisData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'No places saved yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore and save your favorite places',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshPoisData,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            itemCount: vm.collectedPois.length,
            itemBuilder: (context, index) {
              final poi = vm.collectedPois[index];

              return GestureDetector(
                onTap: () async {
                  // Navigate to POI details page and wait for result
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PoiPage(placeId: poi.id, userId: vm.userId),
                    ),
                  );

                  // Refresh the list when returning from POI page
                  if (mounted) {
                    await _refreshPoisData();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: AppWidgetStyles.cardDecoration(context),
                  child: ListTile(
                    leading: poi.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              poi.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Theme.of(context).colorScheme.surface,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                    title: Text(
                      poi.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            poi.country,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () async {
                        // Remove from collection
                        await vm.removeFromCollection(poi.id);
                        _onPoiCollectChanged();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${poi.name} removed from collection',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
