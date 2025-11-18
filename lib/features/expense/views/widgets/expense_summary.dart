import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_text_field.dart';
import 'package:tripora/features/expense/viewmodels/expense_viewmodel.dart';

class ExpenseSummary extends StatelessWidget {
  const ExpenseSummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expenseVm = context.watch<ExpenseViewModel>();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppWidgetStyles.cardDecoration(
        context,
      ).copyWith(borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message: "Tap to adjust budget",
            child: GestureDetector(
              onTap: () async {
                final newBudget = await showModalBottomSheet<double>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    final controller = TextEditingController(
                      text: expenseVm.budget.toStringAsFixed(0),
                    );

                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                        left: 30,
                        right: 30,
                        top: 30,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              "Adjust Budget",
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                          const SizedBox(height: 20),
                          AppTextField(
                            label: "Enter new budget",
                            controller: controller,
                            isNumber: true,
                            isCurrency: true,
                            autofocus: true,
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            text: "Save",
                            minWidth: 100,
                            onPressed: () {
                              final value = double.tryParse(controller.text);
                              if (value != null && value > 0) {
                                Navigator.pop(context, value);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please enter a valid amount",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                );

                // Handle result after closing bottom sheet
                if (newBudget != null && newBudget != expenseVm.budget) {
                  expenseVm.updateBudget(newBudget);

                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Success"),
                      content: const Text(
                        "Your budget was updated successfully.",
                      ),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: const Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Budget: RM${expenseVm.budget.toStringAsFixed(0)}",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.edit, size: 18, color: theme.primaryColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Expense", style: theme.textTheme.titleMedium),
              Text(
                "RM ${expenseVm.totalExpense.toStringAsFixed(2)}",
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: expenseVm.totalExpense > expenseVm.budget
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
