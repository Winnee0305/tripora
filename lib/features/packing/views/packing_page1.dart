import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/core/widgets/app_check_box.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';
import 'package:tripora/core/widgets/app_sticky_header_delegate.dart';

class PackingPage extends StatelessWidget {
  const PackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PackingPageViewModel>();
    final theme = Theme.of(context);
    final packedCount = vm.packedItemCount;
    final totalCount = vm.items.length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ---------- Sticky Header ----------
            SliverPersistentHeader(
              pinned: true,
              delegate: AppStickyHeaderDelegate(
                minHeight: 120,
                maxHeight: 120,
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ----- Top Bar -----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppButton.iconOnly(
                            icon: CupertinoIcons.back,
                            onPressed: () => Navigator.pop(context),
                            backgroundVariant: BackgroundVariant.primaryTrans,
                          ),
                          Text(
                            'Melaka 2 days family trip',
                            style: theme.textTheme.headlineSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppButton.iconOnly(
                            icon: CupertinoIcons.home,
                            onPressed: () {},
                            backgroundVariant: BackgroundVariant.primaryTrans,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ---- Smart Packing List Header ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Smart Packing List',
                            style: theme.textTheme.headlineMedium?.weight(
                              ManropeFontWeight.bold,
                            ),
                          ),
                          AppButton.textOnly(
                            text: "$packedCount / $totalCount",
                            onPressed: () {},
                            backgroundVariant: BackgroundVariant.primaryFilled,
                            radius: 10,
                            minHeight: 38,
                            minWidth: 80,
                            textStyleOverride: theme.textTheme.titleLarge
                                ?.weight(ManropeFontWeight.regular),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------- Packing List ----------
            if (vm.categories.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Text(
                      'Tap the refresh icon to load Melaka trip list',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              SliverList.builder(
                itemCount: vm.categories.length,
                itemBuilder: (context, index) {
                  final category = vm.categories.elementAt(index);
                  final items = vm.getItemsByCategory(category);
                  final packed = items.where((e) => e.isPacked).length;

                  vm.initControllersForCategory(category);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: AppWidgetStyles.cardDecoration(
                        context,
                      ).copyWith(borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: theme.copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  category,
                                  style: theme.textTheme.headlineSmall?.weight(
                                    ManropeFontWeight.medium,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              AppButton.textOnly(
                                text: "$packed / ${items.length}",
                                onPressed: () {},
                                radius: 6,
                                backgroundVariant:
                                    BackgroundVariant.primaryTrans,
                                minHeight: 30,
                                minWidth: 48,
                                textStyleOverride: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          children: [
                            for (final item in items)
                              ListTile(
                                leading: AppCheckBox(
                                  value: item.isPacked,
                                  onChanged: (_) => vm.togglePacked(item),
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
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                                  ),
                                  onPressed: () => vm.removeItem(item),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  AppButton.iconOnly(
                                    icon: CupertinoIcons.add,
                                    iconSize: 16,
                                    minHeight: 24,
                                    minWidth: 24,
                                    radius: 6,
                                    backgroundVariant:
                                        BackgroundVariant.primaryTrans,
                                    onPressed: () {
                                      final controller =
                                          vm.newItemControllers[category];
                                      final text =
                                          controller?.text.trim() ?? '';
                                      if (text.isNotEmpty) {
                                        vm.addItem(text, category);
                                        controller?.clear();
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          vm.newItemControllers[category],
                                      decoration: const InputDecoration(
                                        hintText: "Add new item...",
                                        border: InputBorder.none,
                                      ),
                                      onSubmitted: (value) {
                                        if (value.trim().isNotEmpty) {
                                          vm.addItem(value.trim(), category);
                                          vm.newItemControllers[category]
                                              ?.clear();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
