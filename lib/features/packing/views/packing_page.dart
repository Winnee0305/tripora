import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/features/packing/viewmodels/packing_viewmodel.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';
import 'widgets/packing_page_header_section.dart';
import 'widgets/packing_page_category_card.dart';

class PackingPage extends StatefulWidget {
  const PackingPage({super.key});

  @override
  State<PackingPage> createState() => _PackingPageState();
}

class _PackingPageState extends State<PackingPage> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PackingViewModel>();
    final packedCount = vm.packedItemCount;
    final totalCount = vm.getTotalItems();

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

            // ---------- Add Category Field (Always Visible) ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 16, 30, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _categoryController,
                        label: "Add New Category",
                      ),
                    ),
                    const SizedBox(width: 10),
                    AppButton.textOnly(
                      minWidth: 80,
                      text: "Add",
                      backgroundVariant: BackgroundVariant.primaryFilled,
                      onPressed: () {
                        final text = _categoryController.text.trim();
                        if (text.isEmpty) return;
                        if (vm.categories.contains(text)) return;

                        vm.addCategory(text);
                        _categoryController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ---------- Empty State ----------
            if (vm.categories.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Text(
                      'There is not packing list, add now!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              // ============================================================
              // Category List
              // ============================================================
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
                      onDeleteCategory: () => vm.removeCategory(category),
                      onRenameCategory: (newName) =>
                          vm.renameCategory(category, newName),
                      onRenameItem: (item, newName) =>
                          vm.renameItem(item, newName),
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
