import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_card.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItineraryPageViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff6f4f3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Map
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset("assets/map_mock.png"),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Travelling to Melacca",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  boxShadow: [
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
                    Text("CHECK IN", style: TextStyle(color: Colors.purple)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Reorderable itinerary list with timeline
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.itinerary.length,
                onReorder: vm.reorderItems,
                itemBuilder: (context, index) {
                  final item = vm.itinerary[index];
                  final isLast = index == vm.itinerary.length - 1;

                  return Container(
                    key: ValueKey(item.id),
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Timeline Column ---
                        Column(
                          children: [
                            // Time label
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                item.time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Circle indicator + vertical line
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                // Line extending downward
                                if (!isLast)
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: 2,
                                    height: 110, // adjust for spacing
                                    color: Colors.grey.shade300,
                                  ),
                                // Circle indicator
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),

                        // --- Card Section ---
                        Expanded(child: ItineraryCard(item: item)),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
