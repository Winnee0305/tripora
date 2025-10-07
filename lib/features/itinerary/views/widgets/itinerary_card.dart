import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';
import 'package:flutter/cupertino.dart';

class ItineraryCard extends StatelessWidget {
  final Itinerary item;

  const ItineraryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppWidgetStyles.cardDecoration(context),
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
          item.destination,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.tags.join(", ")),
        trailing: const Icon(CupertinoIcons.line_horizontal_3),
      ),
      // child: Row(
      //   children: [
      //     Text("hello"),
      //     Container(
      //       margin: const EdgeInsets.only(left: 12),
      //       padding: const EdgeInsets.all(8),
      //       decoration: AppWidgetStyles.cardDecoration(context),
      //       child: Image.asset(
      //         item.image,
      //         width: 60,
      //         height: 60,
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
