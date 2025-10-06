import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/widgets/app_check_box.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';

class PackingItemRow extends StatelessWidget {
  final dynamic item;
  final PackingPageViewModel vm;
  final ThemeData theme;

  const PackingItemRow({
    super.key,
    required this.item,
    required this.vm,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          AppCheckBox(
            value: item.isPacked,
            onChanged: (_) => vm.togglePacked(item),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: theme.textTheme.titleLarge?.copyWith(
                decoration: item.isPacked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              softWrap: true,
            ),
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.clear_circled_solid,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 20,
            ),
            onPressed: () => vm.removeItem(item),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
