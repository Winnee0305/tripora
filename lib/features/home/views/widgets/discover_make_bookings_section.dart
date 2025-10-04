import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:flutter/cupertino.dart';

class DiscoverMakeBookingsSection extends StatelessWidget {
  const DiscoverMakeBookingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Make Bookings", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BookingItem(icon: CupertinoIcons.airplane, label: "Flights"),
            _BookingItem(icon: CupertinoIcons.bed_double_fill, label: "Stays"),
            _BookingItem(
              icon: CupertinoIcons.car_detailed,
              label: "Car Rental",
            ),
            _BookingItem(icon: CupertinoIcons.ticket_fill, label: "Tickets"),
          ],
        ),
      ],
    );
  }
}

class _BookingItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BookingItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 74,
          height: 74,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(4),
          decoration: AppWidgetStyles.cardDecoration(
            context,
          ).copyWith(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: ManropeFontWeight.light,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
