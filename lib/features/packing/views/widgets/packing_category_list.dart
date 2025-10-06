import 'package:flutter/material.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';
import 'packing_category_card.dart';

class PackingCategoryList extends StatelessWidget {
  final PackingPageViewModel vm;
  final ThemeData theme;

  const PackingCategoryList({super.key, required this.vm, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (vm.categories.isEmpty) {
      return const Center(
        child: Text(
          'Tap the refresh icon to load Melaka trip list',
          textAlign: TextAlign.center,
        ),
      );
    }

    final categories = vm.categories.toList();

    return ListView.builder(
      clipBehavior: Clip.none,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        vm.initControllersForCategory(category);
        return PackingCategoryCard(category: category, vm: vm, theme: theme);
      },
    );
  }
}
