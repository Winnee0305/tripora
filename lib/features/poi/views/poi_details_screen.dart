import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import '../viewmodels/poi_operating_hours_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:tripora/core/reusable_widgets/app_expandable_text.dart';

class PoiDetailsScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiDetailsScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final hoursVM = PoiOperatingHoursViewModel(vm.poi!.operatingHours);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ----- Description
          AppExpandableText(
            vm.poi!.description,
            trimLines: 4,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: ManropeFontWeight.light,
              height: 1.7, // line spacing
            ),
          ),

          const SizedBox(height: 16),

          // ----- Location
          Text(
            "Location",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
          const SizedBox(height: 4),

          // ------ Address
          Text(
            vm.poi!.address,
            textAlign: TextAlign.justify,
            maxLines: 4,
            overflow:
                TextOverflow.ellipsis, // optional: show ... if text too long
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: ManropeFontWeight.light,
              height: 1.7, // line spacing
            ),
          ),
          const SizedBox(height: 6),

          // ----- Map Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/exp_location.png",
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // ----- Operation Hours
          Text(
            "Operation Hours",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: AppWidgetStyles.cardDecoration(
              context,
            ).copyWith(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Text(
                        hoursVM.statusText, // "Open"/"Closed"
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: hoursVM.statusColor(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        CupertinoIcons.circle_fill,
                        size: 5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        hoursVM.openOrCloseHours, // e.g., "9:00 AM - 5:00 PM"
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: ManropeFontWeight.light,
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton.iconTextSmall(
                  text: "Details",
                  textStyleOverride: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: ManropeFontWeight.light,
                      ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => _buildOperatingHoursAlertDialog(context),
                    );
                  },
                  radius: 12,
                  icon: CupertinoIcons.chevron_right,
                  iconSize: 12,
                  minHeight: 42,
                  minWidth: 86,
                  iconPosition: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHoursAlertDialog(BuildContext context) {
    final todayName = DateFormat('EEEE').format(DateTime.now()).toLowerCase();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Operating Hours",
        style: TextStyle(fontWeight: ManropeFontWeight.semiBold, fontSize: 18),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: vm.poi!.operatingHours.map((h) {
              final isClosed = h.open.toLowerCase() == "closed";
              final isToday = h.day.toLowerCase() == todayName;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: isToday
                      ? Colors.green.withValues(alpha: 0.08) // subtle highlight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      h.day,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isToday
                            ? ManropeFontWeight.semiBold
                            : ManropeFontWeight.regular,
                        color: isToday ? Colors.green[700] : Colors.black87,
                      ),
                    ),
                    Text(
                      isClosed ? "Closed" : "${h.open} – ${h.close}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isClosed
                            ? Colors.redAccent
                            : (isToday ? Colors.green[700] : Colors.black87),
                        fontWeight: isToday
                            ? ManropeFontWeight.semiBold
                            : ManropeFontWeight.regular,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
