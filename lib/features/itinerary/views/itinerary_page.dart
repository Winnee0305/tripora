import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/day_selection_bar.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_card.dart';
import 'package:tripora/core/widgets/app_sticky_header_delegate.dart';
import 'package:tripora/features/itinerary/views/widgets/Itinerary_header_delegate.dart';
import 'package:tripora/features/itinerary/viewmodels/day_selection_viewmodel.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItineraryPageViewModel>();

    return ChangeNotifierProvider(
      create: (_) => DaySelectionViewModel(
        startDate: DateTime(2025, 10, 6),
        endDate: DateTime(2025, 10, 12),
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // ---------- Sticky Header ----------
            SliverPersistentHeader(
              pinned: true,
              delegate: ItineraryHeaderDelegate(),
            ),

            //       Scaffold(
            // backgroundColor: const Color(0xfff6f4f3),
            // body: SafeArea(
            //   child: CustomScrollView(
            //     slivers: [
            //       // ✅ Custom Shrinking Map Header
            //       SliverPersistentHeader(
            //         pinned: true,
            //         delegate: _MapHeaderDelegate(minExtent: 100, maxExtent: 220),
            //       ),

            // 🔹 Page Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      "Travelling to Melacca",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Weather card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                            SizedBox(width: 8),
                            Text("Sunny, 29°C"),
                          ],
                        ),
                        Text(
                          "Updated 5 min ago",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Hotel check-in
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.hotel, color: Colors.purple),
                        SizedBox(width: 10),
                        Expanded(child: Text("AMES Hotel")),
                        Text(
                          "CHECK IN",
                          style: TextStyle(color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Itinerary List
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.itinerary.length,
                    onReorder: vm.reorderItems,
                    itemBuilder: (context, index) {
                      final item = vm.itinerary[index];
                      return Container(
                        key: ValueKey(item.id),
                        child: ItineraryCard(item: item),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Custom Delegate for Shrinking Map
class _MapHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  _MapHeaderDelegate({required this.minExtent, required this.maxExtent});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // The more you scroll, the smaller the image height gets
    final currentHeight = (maxExtent - shrinkOffset).clamp(
      minExtent,
      maxExtent,
    );

    return Container(
      color: const Color(0xfff6f4f3),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          height: currentHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset("assets/images/exp_map.png", fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MapHeaderDelegate oldDelegate) {
    return oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent;
  }
}
