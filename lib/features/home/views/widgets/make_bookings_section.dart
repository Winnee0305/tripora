import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MakeBookingsSection extends StatelessWidget {
  const MakeBookingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Book Now", style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BookingItem(icon: LucideIcons.plane, label: "Flights"),
              _BookingItem(icon: CupertinoIcons.bed_double, label: "Stays"),
              _BookingItem(
                icon: Icons.directions_car_outlined,
                label: "Car Rental",
              ),
              _BookingItem(icon: LucideIcons.ticket, label: "Tickets"),
            ],
          ),
        ],
      ),
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
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 2),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ],
    );
  }
}
