import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_button.dart';
import '../../models/note_base.dart';

class CategoryButtonGrid extends StatelessWidget {
  final Map<NoteType, int> counts;
  final Function(NoteType) onPressed;

  const CategoryButtonGrid({
    super.key,
    required this.counts,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttons = [
      (NoteType.attraction, Icons.place, 'Attractions'),
      (NoteType.restaurant, Icons.restaurant, 'Restaurants'),
      (NoteType.transportation, Icons.directions_bus, 'Transportations'),
      (NoteType.note, Icons.note, 'Notes'),
      (NoteType.lodging, Icons.hotel, 'Lodging'),
      (NoteType.attachment, Icons.attachment, 'Attachments'),
    ];

    return GridView.builder(
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(vertical: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final (type, icon, label) = buttons[index];
        final count = counts[type] ?? 0;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ----- The grid card button -----
            AppButton.primary(
              onPressed: () => onPressed(type),
              text: label,
              icon: icon,
              mainAxisAlignment: MainAxisAlignment.start,
              textStyleOverride: theme.textTheme.bodyMedium,
              radius: 10,
              backgroundVariant: BackgroundVariant.primaryTrans,
            ),
            // ----- The count badge -----
            if (count != 0)
              Positioned(
                right: 10,
                top: 10,
                child: AppButton.textOnly(
                  text: count.toString(),
                  onPressed: () {},
                  minHeight: 20,
                  minWidth: 20,
                  radius: 10,
                  textStyleOverride: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: ManropeFontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
