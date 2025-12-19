import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/expense_data.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header_delegate.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/utils/math_utils.dart';
import 'package:tripora/features/expense/viewmodels/expense_viewmodel.dart';
import 'package:tripora/features/expense/views/widgets/add_edit_expense_bottom_sheet.dart';
import 'package:tripora/features/expense/views/widgets/expense_card.dart';

class DailyExpensePage extends StatelessWidget {
  final GlobalKey? listKey;
  const DailyExpensePage({super.key, this.listKey});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseViewModel>();
    final theme = Theme.of(context);
    final selectedDay = vm.selectedDayIndex ?? 0;
    final selectedDate = vm.trip!.startDate!.add(Duration(days: selectedDay));

    final dayExpenses = vm.getExpensesForDate(selectedDate);

    final dayTotal = calcTotal<ExpenseData>(dayExpenses, (e) => e.amount ?? 0);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// ====== SCROLLABLE CONTENT ======
            Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: CustomScrollView(
                slivers: [
                  // --- Sticky Header
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: AppStickyHeaderDelegate(
                      minHeight: 80,
                      maxHeight: 80,
                      child: AppStickyHeader(
                        title:
                            "Day ${selectedDay + 1} — ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        showRightButton: false,
                      ),
                    ),
                  ),

                  // --- Expense List Content ---
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final expense = dayExpenses[index];

                      return GestureDetector(
                        onTap: () => _openAddExpenseSheet(context, expense),
                        child: ExpenseCard(
                          leadingIcon: vm.getCategoryIcon(expense.category),
                          title: expense.name,
                          subtitle: expense.desc ?? '',
                          trailingText: expense.amount.toString(),
                          trailingTextUnit: "RM",
                        ),
                      );
                    }, childCount: dayExpenses.length),
                  ),

                  if (dayExpenses.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "No expenses recorded for this day.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// ====== STICKY BOTTOM BAR ======
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ), // extra bottom

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ----- Gradient Divider -----
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.0),
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    // Daily total summary
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Daily Total",
                            style: theme.textTheme.headlineMedium,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("RM ", style: theme.textTheme.bodyLarge),
                              Text(
                                dayTotal.toStringAsFixed(2),
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Add Expense button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: AppButton.primary(
                        text: "Add Expense",
                        icon: Icons.add_rounded,
                        minWidth: 150,

                        onPressed: () {
                          _openAddExpenseSheet(context, null);
                        },

                        // Add navigation to AddExpensePage here
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddExpenseSheet(BuildContext context, [ExpenseData? expense]) {
    final vm = context.read<ExpenseViewModel>();

    // Reset and populate if editing
    vm.clearForm();
    if (expense != null) {
      vm.populateFromExpense(expense);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: AddEditExpenseBottomSheet(expense: expense),
      ),
    );
  }
}
