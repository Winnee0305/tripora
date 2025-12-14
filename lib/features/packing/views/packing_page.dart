import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/features/packing/viewmodels/packing_viewmodel.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';
import 'package:tripora/features/itinerary/views/widgets/ai_plan_button.dart';
import 'widgets/packing_page_header_section.dart';
import 'widgets/packing_page_category_card.dart';
import 'widgets/smart_tips_widget.dart';

class PackingPage extends StatefulWidget {
  const PackingPage({super.key});

  @override
  State<PackingPage> createState() => _PackingPageState();
}

class _PackingPageState extends State<PackingPage> {
  final TextEditingController _categoryController = TextEditingController();
  Offset? _fabPosition;

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _handleGeneratePacking(BuildContext context) async {
    final vm = context.read<PackingViewModel>();
    final hasExistingItems = vm.getTotalItems() > 0;

    // If list is not empty, show confirmation dialog
    if (hasExistingItems) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Override Packing List?'),
          content: const Text(
            'Your current packing list will be replaced with the new AI-generated list.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Override'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    // Show loading dialog
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Generating packing list...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    // Generate packing list
    await vm.generateAIPackingList();

    // Close loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Wait for next frame before showing result
    await Future.delayed(const Duration(milliseconds: 100));

    // Show result message
    if (context.mounted) {
      if (vm.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Packing list generated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.error ?? 'Failed to generate packing list'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PackingViewModel>();
    final packedCount = vm.packedItemCount;
    final totalCount = vm.getTotalItems();
    final screenSize = MediaQuery.of(context).size;

    // Initialize FAB position if not set (bottom-right corner with padding)
    _fabPosition ??= Offset(screenSize.width - 80, screenSize.height - 180);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
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
                    child: Column(
                      children: [
                        Row(
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
                              backgroundVariant:
                                  BackgroundVariant.primaryFilled,
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
                        const SizedBox(height: 12),
                        if (vm.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              vm.error!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
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
                    itemCount:
                        vm.categories.length + (vm.smartTips != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Display smart tips at the beginning
                      if (vm.smartTips != null && index == 0) {
                        return SmartTipsWidget(tips: vm.smartTips!);
                      }

                      final categoryIndex = vm.smartTips != null
                          ? index - 1
                          : index;
                      final category = vm.categories.elementAt(categoryIndex);
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
            // ----- Draggable AI Generation Button -----
            Positioned(
              left: _fabPosition!.dx,
              top: _fabPosition!.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _fabPosition = Offset(
                      (_fabPosition!.dx + details.delta.dx).clamp(
                        0,
                        screenSize.width - 80,
                      ),
                      (_fabPosition!.dy + details.delta.dy).clamp(
                        0,
                        screenSize.height - 80,
                      ),
                    );
                  });
                },
                child: AIPlanButton(
                  onPressed: () => _handleGeneratePacking(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
