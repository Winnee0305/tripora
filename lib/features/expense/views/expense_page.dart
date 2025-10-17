import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/utils/date_utils.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/expense/viewmodels/expense_viewmodel.dart';
import 'package:tripora/features/expense/views/widgets/expense_card.dart';
import 'package:tripora/features/expense/views/widgets/expense_summary.dart';
import 'widgets/daily_expense_page.dart'; // For daily expense details

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky Header
            SliverPersistentHeader(
              pinned: true,
              delegate: AppStickyHeaderDelegate(
                minHeight: 220,
                maxHeight: 220,
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      const AppStickyHeader(
                        title: 'Melaka 2 days family trip',
                        showRightButton: true,
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ExpenseSummary(
                          onBudgetChanged: (newBudget) =>
                              vm.updateBudget(newBudget),
                          totalExpense: vm.totalExpense, // total of all days
                          budget: vm.budget,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Daily Expense Cards
            SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                final dayExpenses = vm.expenses.where((e) {
                  final idx = vm.expenseDayIndex(e);
                  return idx == i;
                }).toList();

                final dayTotal = dayExpenses.fold<double>(
                  0,
                  (s, e) => s + e.amount,
                );
                final dayDate = generateDateSequence(
                  startDate: vm.tripStartDate,
                  count: vm.tripDays,
                )[i];

                return GestureDetector(
                  onTap: () {
                    vm.setSelectedDay(i);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: vm,
                          child: DailyExpensePage(
                            listKey: GlobalKey(),
                          ), // daily view
                        ),
                      ),
                    );
                  },
                  child: ExpenseCard(
                    leadingTag: getWeekdayShort(dayDate.weekday),
                    title: "Day ${i + 1}",
                    subtitle: "${dayDate.day}/${dayDate.month}/${dayDate.year}",
                    trailingText: "${dayTotal.toStringAsFixed(2)}",
                    trailingTextUnit: "RM",
                  ),
                );
              }, childCount: vm.tripDays),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
