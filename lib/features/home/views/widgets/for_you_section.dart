import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/home/viewmodels/for_you_viewmodel.dart';
import 'destination_card.dart';
import 'package:tripora/features/poi/views/poi_page.dart';

class ForYouSection extends StatelessWidget {
  const ForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForYouViewModel>(
      builder: (context, vm, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "For You",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 10),

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
                                  MaterialPageRoute(builder: (_) => PoiPage()),
                                );
                              },
                              child: DestinationCard(destination: destination),
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
