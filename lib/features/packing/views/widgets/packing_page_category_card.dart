import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_check_box.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/packing/models/packing_item.dart';

class PackingPageCategoryCard extends StatelessWidget {
  final String category;
  final List<PackingItem> items;
  final int packedCount;
  final VoidCallback onItemAdded;
  final Function(PackingItem) onTogglePacked;
  final Function(PackingItem) onRemoveItem;
  final TextEditingController controller;

  const PackingPageCategoryCard({
    super.key,
    required this.category,
    required this.items,
    required this.packedCount,
    required this.onItemAdded,
    required this.onTogglePacked,
    required this.onRemoveItem,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // ----- Category Card Container -----
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: AppWidgetStyles.cardDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          // ----- Expandable Category Tile -----
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  // ----- Category Title -----
                  category,
                  style: theme.textTheme.headlineSmall?.weight(
                    ManropeFontWeight.medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppButton.textOnly(
                // ----- Packed Count Badge -----
                text: "$packedCount / ${items.length}",
                onPressed: () {},
                radius: 6,
                backgroundVariant: BackgroundVariant.primaryTrans,
                minHeight: 30,
                minWidth: 48,
                textStyleOverride: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          children: [
            // ----- List of Items -----
            for (final item in items)
              ListTile(
                leading: AppCheckBox(
                  value: item.isPacked,
                  onChanged: (_) => onTogglePacked(item),
                ),
                title: Text(
                  item.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    decoration: item.isPacked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    CupertinoIcons.clear_circled_solid,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  onPressed: () => onRemoveItem(item),
                ),
              ),
            Padding(
              // ----- Add New Item Field -----
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                bottom: 10,
                top: 2,
              ),
              child: Row(
                children: [
                  AppButton.iconOnly(
                    icon: CupertinoIcons.add,
                    iconSize: 16,
                    minHeight: 24,
                    minWidth: 24,
                    radius: 6,
                    backgroundVariant: BackgroundVariant.primaryTrans,
                    onPressed: onItemAdded,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Add new item...",
                        hintStyle: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => onItemAdded(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
