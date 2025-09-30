import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/home/viewmodels/destinations_viewmodel.dart';
import 'widgets/destination_card.dart';

class HomeInspirationsTab extends StatelessWidget {
  const HomeInspirationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DestinationViewModel>(
      builder: (context, vm, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 412,
              width: 500,
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

                      return Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: SizedBox.expand(
                            child: DestinationCard(
                              destination: vm.destinations[index],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 26),

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
                        ? Colors.orange
                        : Colors.grey.shade400,
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
