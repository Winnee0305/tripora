import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/app_special_tab_n_day_selection_bar.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';

class ExpensePageHeaderSection extends StatelessWidget {
  final AppSpecialTabNDaySelectionBar selectionBar;
  const ExpensePageHeaderSection({super.key, required this.selectionBar});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: AppStickyHeaderDelegate(
        minHeight: 145, // give a bit more height if needed
        maxHeight: 145,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppStickyHeader(
                title: 'Melaka 2 days family trip',
                showRightButton: true,
              ),
              // Wrap in Expanded or SizedBox to constrain ListView height
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: SizedBox(height: 64, child: selectionBar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
