import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';
import 'widgets/packing_page_header_section.dart';
import 'widgets/packing_page_category_card.dart';

class PackingPage extends StatelessWidget {
  const PackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PackingPageViewModel>();
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
                child: PackingPageHeaderSection(
                  packedCount: packedCount,
                  totalCount: totalCount,
                ),
              ),
            ),

            // ---------- Packing List ----------
            if (vm.categories.isEmpty) // ----- Empty State -----
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
                // ----- Build various categories -----
                itemCount: vm.categories.length,
                itemBuilder: (context, index) {
                  final category = vm.categories.elementAt(index);
                  final items = vm.getItemsByCategory(category);
                  final packed = items.where((e) => e.isPacked).length;

                  vm.initControllersForCategory(category);

                  return Padding(
                    // padding around each category section
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 2,
                    ),
                    child: PackingPageCategoryCard(
                      category: category,
                      items: items,
                      packedCount: packed,
                      controller: vm.newItemControllers[category]!,
                      onItemAdded: () {
                        final text = vm.newItemControllers[category]!.text
                            .trim();
                        if (text.isNotEmpty) {
                          vm.addItem(text, category);
                          vm.newItemControllers[category]!.clear();
                        }
                      },
                      onTogglePacked: vm.togglePacked,
                      onRemoveItem: vm.removeItem,
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
