import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/expense_page_viewmodel.dart';
import 'widgets/expense_card.dart';
import 'widgets/expense_summary.dart';
import 'add_expense_page.dart';
import '../../../../core/widgets/app_sticky_header_delegate.dart';
import '../../../../core/widgets/app_sticky_header.dart';
import '../../../../core/widgets/app_button.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  String _weekdayShort(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpensePageViewModel>();
    final filteredExpenses = vm.filteredExpenses;
    final totalForDay = vm.totalForSelected;

    // Generate trip day list
    final dayStartDates = List<DateTime>.generate(vm.tripDays, (i) {
      return vm.tripStartDate.add(Duration(days: i));
    });

    const orange = Color(0xFFF4A261);
    const lightGray = Color(0xFFF2F2F2);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppButton.primary(
            text: "+ Add Expense",
            icon: Icons.add,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddExpensePage()),
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Sticky Header
              SliverPersistentHeader(
                pinned: true,
                delegate: AppStickyHeaderDelegate(
                  minHeight: 80,
                  maxHeight: 80,
                  child: const AppStickyHeader(
                    title: 'Melaka 2 days family trip',
                    showRightButton: true,
                  ),
                ),
              ),

              // Expense Summary
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: ExpenseSummary(
                    onBudgetChanged: (newBudget) => vm.updateBudget(newBudget),
                    totalExpense: totalForDay,
                    budget: vm.budget,
                  ),
                ),
              ),

              // Tabs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black54,
                      indicator: BoxDecoration(
                        color: orange,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      tabs: [
                        Tab(text: "Overview"),
                        Tab(text: "Details"),
                      ],
                    ),
                  ),
                ),
              ),

              // Tab content
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    // -------------------- OVERVIEW TAB --------------------
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: vm.tripDays,
                      itemBuilder: (context, i) {
                        final dayExpenses = vm.expenses.where((e) {
                          final idx = vm.expenseDayIndex(e);
                          return idx == i;
                        }).toList();

                        final dayTotal = dayExpenses.fold<double>(
                          0,
                          (s, e) => s + e.amount,
                        );
                        final dayDate = dayStartDates[i];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: orange.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _weekdayShort(dayDate.weekday),
                                        style: const TextStyle(
                                          color: orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Day ${i + 1}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "${dayDate.day}/${dayDate.month}/${dayDate.year}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                "RM ${dayTotal.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // -------------------- DETAILS TAB --------------------
                    Column(
                      children: [
                        // Date filter buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              for (
                                int i = 0;
                                i < dayStartDates.length;
                                i++
                              ) ...[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => vm.setSelectedDay(i),
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: vm.selectedDayIndex == i
                                            ? orange
                                            : lightGray,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _weekdayShort(
                                                dayStartDates[i].weekday,
                                              ),
                                              style: TextStyle(
                                                color: vm.selectedDayIndex == i
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${dayStartDates[i].day}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: vm.selectedDayIndex == i
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (i < dayStartDates.length - 1)
                                  const SizedBox(width: 8),
                              ],
                            ],
                          ),
                        ),

                        // Expense List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: filteredExpenses.length,
                            itemBuilder: (context, index) {
                              final expense = filteredExpenses[index];
                              return ExpenseCard(expense: expense);
                            },
                          ),
                        ),

                        // Daily total card
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Daily Total",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "RM ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      totalForDay.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
