import 'package:flutter/material.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';

class ItineraryCard extends StatelessWidget {
  final Itinerary item;

  const ItineraryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            item.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.subtitle),
        trailing: const Icon(Icons.drag_handle),
      ),
    );
  }
}
