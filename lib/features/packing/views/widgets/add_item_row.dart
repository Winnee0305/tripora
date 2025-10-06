import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';

class AddItemRow extends StatelessWidget {
  final PackingPageViewModel vm;
  final String category;
  final ThemeData theme;

  const AddItemRow({
    super.key,
    required this.vm,
    required this.category,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final controller = vm.newItemControllers[category];
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 14),
      child: Row(
        children: [
          AppButton.iconOnly(
            icon: CupertinoIcons.add,
            iconSize: 16,
            minHeight: 24,
            minWidth: 24,
            radius: 6,
            backgroundVariant: BackgroundVariant.primaryTrans,
            tooltipMessage: "Add item",
            onPressed: () {
              final text = controller?.text.trim() ?? '';
              if (text.isNotEmpty) {
                vm.addItem(text, category);
                controller?.clear();
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Add new item...",
                hintStyle: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  vm.addItem(value.trim(), category);
                  controller?.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
