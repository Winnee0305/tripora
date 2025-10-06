import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/widgets/app_check_box.dart';

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              // ----- Top bar -----
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

              const SizedBox(height: 30),

              // ---- Header with packed count ----
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
                    textStyleOverride: theme.textTheme.titleLarge?.weight(
                      ManropeFontWeight.regular,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ----- Packing List -----
              vm.categories.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Text(
                          'Tap the refresh icon to load Melaka trip list',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // disable nested scroll
                      shrinkWrap: true, // let it size within the scroll view
                      itemCount: vm.categories.length,
                      itemBuilder: (context, index) {
                        final category = vm.categories.elementAt(index);
                        final items = vm.getItemsByCategory(category);
                        final packed = items.where((e) => e.isPacked).length;

                        vm.initControllersForCategory(category);

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: AppWidgetStyles.cardDecoration(
                            context,
                          ).copyWith(borderRadius: BorderRadius.circular(10)),
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              backgroundColor: Colors.transparent,
                              collapsedBackgroundColor: Colors.transparent,
                              childrenPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      category,
                                      style: theme.textTheme.headlineSmall
                                          ?.weight(ManropeFontWeight.medium),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AppButton.textOnly(
                                    text: "$packed / ${items.length}",
                                    onPressed: () {},
                                    radius: 6,
                                    backgroundVariant:
                                        BackgroundVariant.primaryTrans,
                                    minHeight: 30,
                                    minWidth: 48,
                                    textStyleOverride: theme
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.delete_simple,
                                      size: 18,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                    tooltip: "Remove category",
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("Delete Category"),
                                          content: Text(
                                            "Are you sure you want to remove '$category'? All its items will be deleted.",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        vm.removeCategory(category);
                                      }
                                    },
                                  ),
                                ],
                              ),

                              // ----- Items inside each category -----
                              children: [
                                ...items.map((item) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AppCheckBox(
                                          value: item.isPacked,
                                          onChanged: (_) =>
                                              vm.togglePacked(item),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.name,
                                                  style: theme
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        decoration:
                                                            item.isPacked
                                                            ? TextDecoration
                                                                  .lineThrough
                                                            : TextDecoration
                                                                  .none,
                                                      ),
                                                  softWrap: true,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  CupertinoIcons
                                                      .clear_circled_solid,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.3),
                                                  size: 20,
                                                ),
                                                onPressed: () =>
                                                    vm.removeItem(item),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),

                                // ----- Add item row -----
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 2,
                                    bottom: 14,
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
                                        tooltipMessage: "Add item",
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
                                          decoration: InputDecoration(
                                            hintText: "Add new item...",
                                            hintStyle: theme
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.5),
                                                ),
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
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
                                              vm.addItem(
                                                value.trim(),
                                                category,
                                              );
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
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
