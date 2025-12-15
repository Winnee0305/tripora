import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/home/viewmodels/for_you_viewmodel.dart';
import 'destination_card.dart';
import 'package:tripora/features/poi/views/poi_page.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class ForYouSection extends StatelessWidget {
  const ForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForYouViewModel>(
      builder: (context, vm, child) {
        final userVm = context.read<UserViewModel>();

        // Set user ID in ViewModel if available
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (userVm.user?.uid != null) {
            vm.setUserId(userVm.user!.uid);
          }
        });

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "For You",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (vm.isPersonalized)
                    Tooltip(
                      message: 'Personalized recommendations',
                      child: Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Loading state
            if (vm.isLoading)
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            // Error state
            else if (vm.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        vm.error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => vm.refreshRecommendations(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            // Content state
            else
              SizedBox(
                height: 240,
                width: double.infinity,
                child: PageView.builder(
                  controller: vm.pageController,
                  itemCount: vm.destinations.length,
                  onPageChanged: vm.onPageChanged,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: vm.pageController,
                      builder: (context, child) {
                        double scale = 1.0;
                        double opacity = 1.0;

                        if (!vm.pageController.position.haveDimensions) {
                          // Initial render
                          scale = index == 0 ? 1.0 : 0.9;
                          opacity = index == 0 ? 1.0 : 0.7;
                        } else {
                          double page =
                              vm.pageController.page ??
                              vm.pageController.initialPage.toDouble();
                          double distance = (page - index).abs();

                          // Scale decreases as card is farther from center
                          scale = (1 - (distance * 0.1)).clamp(0.9, 1.0);

                          // Opacity decreases slightly with distance
                          opacity = (1 - (distance * 0.6)).clamp(0.1, 1.0);
                        }
                        final destination = vm.destinations[index];

                        return Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: SizedBox.expand(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PoiPage(
                                        placeId: destination.id,
                                        userId: userVm.user?.uid,
                                      ),
                                    ),
                                  );
                                },
                                child: DestinationCard(
                                  destination: destination,
                                  isCollected: vm.isPoiCollected(
                                    destination.id,
                                  ),
                                  onHeartPressed: () =>
                                      vm.togglePoiCollection(destination),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 10),

            // Indicators
            if (vm.destinations.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  vm.destinations.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: vm.currentPage == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: vm.currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
