import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_loading_network_image.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'package:tripora/features/trip/views/create_edit_trip_page.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TripViewModel>();

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(58),
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: AppLoadingNetworkImage(
                imageUrl: vm.trip!.tripImageUrl ?? 'assets/logo/tripora.JPG',
                radius: 14, // optional, controls the loading indicator size
              ),
            ),
          ),
        ),

        // --- Back Button ---
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: AppButton.iconOnly(
              icon: CupertinoIcons.back,
              onPressed: () => Navigator.pop(context),
              backgroundVariant: BackgroundVariant.secondaryFilled,
            ),
          ),
        ),

        // --- Bottom Info Card ---
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 113,
            margin: const EdgeInsets.symmetric(horizontal: 38),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: AppWidgetStyles.cardDecoration(
              context,
            ).copyWith(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Location + Title ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      // "${vm.trip!.destination}, ${vm.trip!.country}",
                      "${vm.trip?.destination}, Malaysia",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: ManropeFontWeight.light,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  vm.trip?.tripName ?? '',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // --- Date Range + Settings Button ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DateRange(
                      start: vm.trip?.startDate ?? DateTime.now(),
                      end: vm.trip?.endDate ?? DateTime.now(),
                    ),
                    AppButton.iconOnly(
                      icon: CupertinoIcons.settings,
                      onPressed: () {
                        // Example: open in edit mode from TripInfoPage or trip list
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: vm,
                              child: CreateEditTripPage(tripToEdit: vm.trip),
                            ),
                          ),
                        );
                      },
                      iconSize: 22,
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DateRange extends StatelessWidget {
  final DateTime start;
  final DateTime end;

  const _DateRange({required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Baseline(
          baseline: 14,
          baselineType: TextBaseline.alphabetic,
          child: Icon(
            CupertinoIcons.calendar,
            size: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 4),
        Baseline(
          baseline: 14,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            formatDateRange(start, end),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: ManropeFontWeight.light,
            ),
          ),
        ),
      ],
    );
  }
}
