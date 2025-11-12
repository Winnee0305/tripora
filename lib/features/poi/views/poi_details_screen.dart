import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/powered_by_ai_tag.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import '../viewmodels/poi_operating_hours_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:tripora/core/reusable_widgets/app_expandable_text.dart';

class PoiDetailsScreen extends StatefulWidget {
  final PoiPageViewmodel vm;
  const PoiDetailsScreen({super.key, required this.vm});

  @override
  State<PoiDetailsScreen> createState() => _PoiDetailsScreenState();
}

class _PoiDetailsScreenState extends State<PoiDetailsScreen> {
  String animatedDots = '';
  Timer? _timer;
  late final PoiOperatingHoursViewModel? operatingVM;

  @override
  void initState() {
    super.initState();

    // Initialize operatingVM if poi exists
    if (widget.vm.poi != null) {
      operatingVM = PoiOperatingHoursViewModel(widget.vm.poi!.operatingHours);
    } else {
      operatingVM = null;
    }

    // Start dot animation only if description is empty
    if (widget.vm.poi?.description.isEmpty ?? true) {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          animatedDots = animatedDots.length < 3 ? '$animatedDots.' : '';
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final poi = widget.vm.poi;
    if (poi == null) {
      return const Center(child: Text('No data available'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // ===== Description =====
          Row(
            children: [
              Text(
                "Description",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: ManropeFontWeight.semiBold,
                ),
              ),
              const SizedBox(width: 8),
              const PoweredByAiTag(),
            ],
          ),
          const SizedBox(height: 12),
          AppExpandableText(
            poi.description.isEmpty
                ? "Generating description$animatedDots"
                : poi.description,
            trimLines: 4,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: ManropeFontWeight.light,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),

          // ===== Location =====
          if (poi.address.isNotEmpty) ...[
            Text(
              "Location",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: ManropeFontWeight.semiBold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              poi.address,
              textAlign: TextAlign.justify,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: ManropeFontWeight.light,
              ),
            ),
            const SizedBox(height: 32),
          ],

          // ===== Phone Number =====
          if (poi.phoneNumber.isNotEmpty) ...[
            Text(
              "Phone Number",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: ManropeFontWeight.semiBold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              poi.phoneNumber,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: ManropeFontWeight.light,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 32),
          ],

          // ===== Operating Hours =====
          if ((poi.operatingHours.isNotEmpty) && (operatingVM != null)) ...[
            Text(
              "Operating Hours",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: ManropeFontWeight.semiBold,
              ),
            ),
            const SizedBox(height: 18),
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
                          operatingVM!.statusText,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: operatingVM!.statusColor(context),
                              ),
                        ),
                        const SizedBox(width: 10),
                        if (!(operatingVM!.is24Open)) ...[
                          Icon(
                            CupertinoIcons.circle_fill,
                            size: 5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            operatingVM!.openOrCloseHours,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: ManropeFontWeight.light),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AppButton.iconTextSmall(
                    text: "Details",
                    onPressed: () {
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => _buildOperatingHoursAlertDialog(
                          context,
                          operatingVM!.statusColor(context),
                          operatingVM!.is24Open,
                        ),
                      );
                    },
                    radius: 12,
                    icon: CupertinoIcons.chevron_right,
                    iconSize: 12,
                    minHeight: 42,
                    minWidth: 86,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOperatingHoursAlertDialog(
    BuildContext context,
    Color highlightColor,
    bool isOpen24Hours,
  ) {
    final todayName = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final hours = widget.vm.poi?.operatingHours ?? [];

    final children = hours.isEmpty
        ? [const Text("No operating hours available.")]
        : hours.map((h) {
            final isToday = h.day.toLowerCase() == todayName;

            final displayText = isOpen24Hours ? "" : "${h.open} - ${h.close}";

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: isToday
                    ? highlightColor.withAlpha(20)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isOpen24Hours ? "Open 24 hours" : h.day,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isToday
                          ? ManropeFontWeight.semiBold
                          : ManropeFontWeight.regular,
                      color: isToday ? highlightColor : Colors.black87,
                    ),
                  ),
                  Text(
                    displayText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isToday ? highlightColor : Colors.black87,
                      fontWeight: isToday
                          ? ManropeFontWeight.semiBold
                          : ManropeFontWeight.regular,
                    ),
                  ),
                ],
              ),
            );
          }).toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Operating Hours for ${widget.vm.poi?.name ?? ''}",
        style: const TextStyle(
          fontWeight: ManropeFontWeight.semiBold,
          fontSize: 18,
        ),
        maxLines: 2,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
