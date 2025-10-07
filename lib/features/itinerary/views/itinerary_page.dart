import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/day_selection_bar.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_item.dart';
import 'package:tripora/core/widgets/app_sticky_header_delegate.dart';
import 'package:tripora/features/itinerary/views/widgets/Itinerary_header_delegate.dart';
import 'package:tripora/features/itinerary/viewmodels/day_selection_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/weather_card.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_card_viewmodel.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_reoderable_list.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
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

            //  ----- Page Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ----- Weather card -----
                    ChangeNotifierProvider(
                      create: (_) => WeatherCardViewModel(),
                      child: const WeatherCard(),
                    ),
                    const SizedBox(height: 16),

                    // ----- Lodging -----
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: AppWidgetStyles.cardDecoration(context),
                      child: Row(
                        children: [
                          AppButton.iconOnly(
                            icon: Icons.hotel,
                            onPressed: () {},
                            iconSize: 18,
                            minHeight: 30,
                            minWidth: 30,
                            backgroundColorOverride: AppColors.accent1
                                .withValues(alpha: 0.1),
                            textColorOverride: AppColors.accent1,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "AMES Hotel",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.weight(ManropeFontWeight.semiBold),
                            ),
                          ),
                          const Text(
                            "CHECK IN",
                            style: TextStyle(color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ----- Reorderable Itinerary List -----
                    const ItineraryReorderableList(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
