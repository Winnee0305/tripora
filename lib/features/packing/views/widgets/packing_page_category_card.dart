import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/models/packing_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_check_box.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class PackingPageCategoryCard extends StatelessWidget {
  final String category;
  final List<PackingData> items;
  final int packedCount;
  final VoidCallback onItemAdded;
  final Function(PackingData) onTogglePacked;
  final Function(PackingData) onRemoveItem;
  final VoidCallback onDeleteCategory;
  final TextEditingController controller;

  // New callbacks for renaming
  final Function(String) onRenameCategory;
  final Function(PackingData, String) onRenameItem;

  const PackingPageCategoryCard({
    super.key,
    required this.category,
    required this.items,
    required this.packedCount,
    required this.onItemAdded,
    required this.onTogglePacked,
    required this.onRemoveItem,
    required this.onDeleteCategory,
    required this.controller,
    required this.onRenameCategory,
    required this.onRenameItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future<void> _showRenameCategoryDialog() async {
      final newName = await showDialog<String>(
        context: context,
        builder: (ctx) {
          final controller = TextEditingController(text: category);
          return AlertDialog(
            title: const Text("Rename Category"),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Enter new category name",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                child: const Text("Save"),
              ),
            ],
          );
        },
      );

      if (newName != null && newName.isNotEmpty) {
        onRenameCategory(newName);
      }
    }

    Future<void> _showRenameItemDialog(PackingData item) async {
      final newName = await showDialog<String>(
        context: context,
        builder: (ctx) {
          final controller = TextEditingController(text: item.name);
          return AlertDialog(
            title: const Text("Rename Item"),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Enter new item name",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                child: const Text("Save"),
              ),
            ],
          );
        },
      );

      if (newName != null && newName.isNotEmpty) {
        onRenameItem(item, newName);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: AppWidgetStyles.cardDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),

          // ======================================
          // CATEGORY HEADER ROW
          // ======================================
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category title with double-tap rename
              Expanded(
                child: GestureDetector(
                  onDoubleTap: _showRenameCategoryDialog,
                  child: Text(
                    category,
                    style: theme.textTheme.headlineSmall?.weight(
                      ManropeFontWeight.medium,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Delete icon
              IconButton(
                icon: Icon(
                  CupertinoIcons.delete,
                  size: 20,
                  color: theme.colorScheme.error.withValues(alpha: 0.8),
                ),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (ctx) => CupertinoAlertDialog(
                      title: const Text("Delete Category?"),
                      content: Text(
                        "All items inside this category will be removed. This action cannot be undone.",
                      ),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          child: const Text("Delete"),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            onDeleteCategory();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Packed count badge
              AppButton.textOnly(
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
            horizontal: 8,
            vertical: 0,
          ),
          children: [
            // ======================================
            // ITEMS LIST
            // ======================================
            for (final item in items)
              ListTile(
                leading: AppCheckBox(
                  value: item.isPacked,
                  onChanged: (_) => onTogglePacked(item),
                ),
                title: GestureDetector(
                  onDoubleTap: () => _showRenameItemDialog(item),
                  child: Text(
                    item.name!,
                    style: theme.textTheme.titleLarge?.copyWith(
                      decoration: item.isPacked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
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

            // ======================================
            // ADD NEW ITEM FIELD
            // ======================================
            Padding(
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
