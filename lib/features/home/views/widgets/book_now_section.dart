import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/services/booking_url_service.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tripora/features/home/viewmodels/book_now_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookNowSection extends StatelessWidget {
  const BookNowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookNowViewModel(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Book Now", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
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
    final vm = Provider.of<BookNowViewModel>(context, listen: false);

    return InkWell(
      onTap: () => vm.onBookingItemTapped(label),
      borderRadius: BorderRadius.circular(10),
      child: Column(
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
      ),
    );
  }
}
