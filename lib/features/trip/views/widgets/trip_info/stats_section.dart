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
import 'package:tripora/features/packing/viewmodels/packing_viewmodel.dart';
import 'package:tripora/features/notes_itinerary/views/notes_itinerary_page.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class StatsSection extends StatefulWidget {
  const StatsSection({super.key});

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> {
  @override
  void initState() {
    super.initState();
    // Schedule the load after first build to avoid "setState during build" errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itineraryVm = context.read<ItineraryViewModel>();
      final tripVm = context.read<TripViewModel>();
      final expenseVm = context.read<ExpenseViewModel>();
      final packingVm = context.read<PackingViewModel>();
      if (tripVm.trip != null) {
        print("initializing itinerary");
        itineraryVm.setTrip(tripVm.trip!);
        itineraryVm.initialise();
        expenseVm.setTrip(tripVm.trip!);
        print('Trip set in ExpenseViewModel: ${tripVm.trip!.tripName}');
        expenseVm.initialise();
        packingVm.setTrip(tripVm.trip!);
        packingVm.initialise();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itineraryVm = context.watch<ItineraryViewModel>();
    final tripVm = context.watch<TripViewModel>();
    final expenseVm = context.watch<ExpenseViewModel>();
    final packingVm = context.watch<PackingViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        children: [
          // ----- FIRST ROW: ITINERARY (Full Width)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              final userVm = context.read<UserViewModel>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(value: tripVm),
                      ChangeNotifierProvider.value(value: itineraryVm),
                      ChangeNotifierProvider.value(value: userVm),
                      ChangeNotifierProvider(
                        create: (_) => DaySelectionViewModel(
                          startDate: tripVm.trip!.startDate!,
                          endDate: tripVm.trip!.endDate!,
                        )..selectDay(0),
                      ),
                    ],
                    child: NotesItineraryPage(currentTab: 1),
                  ),
                ),
              );
            },
            child: Container(
              height: 150,
              decoration: AppWidgetStyles.cardDecoration(
                context,
              ).copyWith(color: AppColors.design1),
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/distance_white.png",
                    width: 64,
                    height: 64,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Itinerary",
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: ManropeFontWeight.regular,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${itineraryVm.itineraries.length} Activities",
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: ManropeFontWeight.semiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ----- SECOND ROW: EXPENSE & PACKING LIST
          Row(
            children: [
              // Expense Card
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(value: tripVm),
                            ChangeNotifierProvider.value(value: expenseVm),
                          ],
                          child: ExpensePage(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: AppWidgetStyles.cardDecoration(
                      context,
                    ).copyWith(color: AppColors.design3),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          CupertinoIcons.money_dollar_circle,
                          color: theme.colorScheme.onPrimary,
                          size: 58,
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
                              expenseVm.totalExpense.toStringAsFixed(2),
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
              ),
              const SizedBox(width: 16),

              // Packing List Card
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(value: tripVm),
                            ChangeNotifierProvider.value(value: packingVm),
                          ],
                          child: PackingPage(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.luggage_outlined,
                          color: theme.colorScheme.onPrimary,
                          size: 52,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Packing",
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.regular,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              packingVm.packedItemCount.toString(),
                              style: theme.textTheme.headlineLarge!.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: ManropeFontWeight.semiBold,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "/ ${packingVm.getTotalItems().toString()}",
                              style: theme.textTheme.headlineSmall!.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: ManropeFontWeight.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
