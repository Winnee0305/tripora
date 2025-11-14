import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/day_selection_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/features/expense/viewmodels/expense_viewmodel.dart';
import 'package:tripora/features/expense/views/expense_page.dart';
import 'package:tripora/features/packing/views/packing_page.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';
import 'package:tripora/features/notes_itinerary/views/notes_itinerary_page.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itineraryVm = context.watch<ItineraryPageViewModel>();
    final tripVm = context.watch<TripViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            // ----- NOTES
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiProvider(
                      providers: [
                        // Reuse the existing TripViewModel and ItineraryPageViewModel
                        ChangeNotifierProvider.value(value: tripVm),
                        ChangeNotifierProvider.value(value: itineraryVm),
                        // DaySelectionViewModel specific to this page
                        ChangeNotifierProvider(
                          create: (_) => DaySelectionViewModel(
                            startDate: tripVm.trip!.startDate!,
                            endDate: tripVm.trip!.endDate!,
                          )..selectDay(0),
                        ),
                      ],
                      child: NotesItineraryPage(currentTab: 0),
                    ),
                  ),
                );
              }, // Dummy tap
              child: Container(
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design2),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.doc_on_clipboard,
                      color: theme.colorScheme.onPrimary,
                      size: 58,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Notes",
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.regular,
                          ),
                        ),
                        Text(
                          "5",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.semiBold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => ExpenseViewModel(
                        tripStartDate: DateTime(2025, 8, 13),
                        tripEndDate: DateTime(2025, 8, 14),
                      ),
                      child: ExpensePage(),
                    ),
                  ),
                );
              }, // Dummy tap
              child: Container(
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design3),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: theme.colorScheme.onPrimary,
                        size: 58,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Expense",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: ManropeFontWeight.regular,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "RM",
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.semiBold,
                          ),
                        ),
                        Text(
                          "300.00",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.semiBold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ----- ITINERARY
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiProvider(
                      providers: [
                        // Reuse the existing TripViewModel and ItineraryPageViewModel
                        ChangeNotifierProvider.value(value: tripVm),
                        ChangeNotifierProvider.value(value: itineraryVm),
                        // DaySelectionViewModel specific to this page
                        ChangeNotifierProvider(
                          create: (_) => DaySelectionViewModel(
                            startDate: tripVm.trip!.startDate!,
                            endDate: tripVm.trip!.endDate!,
                          )..selectDay(1),
                        ),
                      ],
                      child: NotesItineraryPage(currentTab: 1),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design1),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/icons/distance_white.png",
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Itinerary",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: ManropeFontWeight.regular,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "9 Activities",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: ManropeFontWeight.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ----- PACKING LIST
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => PackingPageViewModel(),
                      child: const PackingPage(),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design4),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Smart Packing List",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: ManropeFontWeight.regular,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.luggage_outlined,
                          color: theme.colorScheme.onPrimary,
                          size: 52,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "7",
                              style: theme.textTheme.headlineLarge!.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: ManropeFontWeight.semiBold,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "/ 30",
                              style: theme.textTheme.headlineSmall!.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: ManropeFontWeight.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
