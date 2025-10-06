import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/packing/viewmodels/packing_page_viewmodel.dart';
import 'package:tripora/features/packing/views/widgets/packing_category_list.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              // --- Page Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

              // --- Packing Header + Add Button
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
              // ---- Packing List ----
              Expanded(
                child: PackingCategoryList(vm: vm, theme: theme),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
