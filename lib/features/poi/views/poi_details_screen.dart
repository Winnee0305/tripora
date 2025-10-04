import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poi_operating_hours_viewmodel.dart';

class PoiDetailsScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiDetailsScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final hoursVM = PoiOperatingHoursViewModel(vm.place.operatingHours);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Description
          Text(
            vm.place.description,
            textAlign: TextAlign.justify,
            maxLines: 4,
            overflow:
                TextOverflow.ellipsis, // optional: show ... if text too long
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: ManropeFontWeight.light,
              height: 1.7, // line spacing
            ),
          ),

          const SizedBox(height: 16),

          // Location
          Text(
            "Location",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
          const SizedBox(height: 4),

          // Address
          Text(
            vm.place.address,
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

          // Map Image
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

          // Operation Hours
          Text(
            "Operation Hours",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: AppWidgetStyles.cardDecoration(
              context,
            ).copyWith(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Operating Hours"),
                          content: Text(
                            hoursVM.fullSchedule, // direct call
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          hoursVM.statusText, // "Open"/"Closed"
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: hoursVM.statusColor(context),
                                fontWeight: ManropeFontWeight.medium,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  text: "Details",
                  onPressed: () {},
                  radius: 22,
                  icon: CupertinoIcons.back,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
