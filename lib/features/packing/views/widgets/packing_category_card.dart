import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/core/widgets/app_check_box.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';
import 'package:tripora/features/packing/views/widgets/add_item_row.dart';
import 'package:tripora/features/packing/views/widgets/packing_item_row.dart';

class PackingCategoryCard extends StatelessWidget {
  final String category;
  final PackingPageViewModel vm;
  final ThemeData theme;

  const PackingCategoryCard({
    super.key,
    required this.category,
    required this.vm,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final items = vm.getItemsByCategory(category);
    final packed = items.where((e) => e.isPacked).length;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: AppWidgetStyles.cardDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          title: Row(
            children: [
              // Category name
              Expanded(
                child: Text(
                  category,
                  style: theme.textTheme.headlineSmall?.weight(
                    ManropeFontWeight.medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              // Right-side actions (count + delete)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton.textOnly(
                    text: "$packed / ${items.length}",
                    onPressed: () {},
                    radius: 6,
                    backgroundVariant: BackgroundVariant.primaryTrans,
                    minHeight: 30,
                    minWidth: 48,
                    textStyleOverride: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    message: "Remove category",
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.delete_simple,
                        size: 18,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      onPressed: () => _confirmDelete(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          children: [
            ...items.map(
              (item) => PackingItemRow(item: item, vm: vm, theme: theme),
            ),
            AddItemRow(vm: vm, category: category, theme: theme),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Category"),
        content: Text(
          "Are you sure you want to remove '$category'? All its items will be deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirm == true) vm.removeCategory(category);
  }
}
