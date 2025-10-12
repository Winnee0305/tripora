import 'package:flutter/material.dart';
import 'package:tripora/features/expense/models/expense.dart';
import 'dart:math';

class ExpensePageViewModel extends ChangeNotifier {
  double budget = 0;
  List<Expense> expenses = [];

  // Trip metadata
  final DateTime tripStartDate;
  final DateTime tripEndDate;

  ExpensePageViewModel({
    required this.tripStartDate,
    required this.tripEndDate,
    this.expenses = const [],
    this.budget = 0,
  }) {
    loadMockData(); // auto-load mock data for preview
  }

  int? selectedDayIndex;

  int get tripDays {
    final days = tripEndDate.difference(tripStartDate).inDays + 1;
    return days > 0 ? days : 1;
  }

  int? expenseDayIndex(Expense expense) {
    final d = DateTime(expense.date.year, expense.date.month, expense.date.day);
    final start = DateTime(
      tripStartDate.year,
      tripStartDate.month,
      tripStartDate.day,
    );
    final diff = d.difference(start).inDays;
    if (diff < 0 || diff >= tripDays) return null;
    return diff;
  }

  List<Expense> get filteredExpenses {
    if (selectedDayIndex == null) return expenses;
    return expenses.where((e) {
      final idx = expenseDayIndex(e);
      return idx != null && idx == selectedDayIndex;
    }).toList();
  }

  double get totalExpense => expenses.fold<double>(0, (s, e) => s + e.amount);

  double get totalForSelected =>
      filteredExpenses.fold<double>(0, (s, e) => s + e.amount);

  void setSelectedDay(int? index) {
    selectedDayIndex = index;
    notifyListeners();
  }

  void updateBudget(double newBudget) {
    budget = newBudget;
    notifyListeners();
  }

  void addExpense(Expense expense) {
    expenses.add(expense);
    notifyListeners();
  }

  // --------------------------------------------------------------------------
  // ✅ MOCK DATA
  // --------------------------------------------------------------------------

  void loadMockData() {
    final random = Random();
    final categories = [
      'Food & Drinks',
      'Transportation',
      'Attractions',
      'Shopping',
      'Accommodation',
      'Miscellaneous',
    ];

    final sampleTitles = [
      'Lunch at Jonker Street',
      'Grab ride to A\'Famosa',
      'Entrance Ticket – The Shore',
      'Souvenirs from Dataran Pahlawan',
      'Hotel Stay (Day 1)',
      'Coffee & Dessert',
      'Dinner by the River',
      'Breakfast buffet',
    ];

    final generatedExpenses = <Expense>[];

    // spread expenses across trip days
    for (int day = 0; day < tripDays; day++) {
      final date = tripStartDate.add(Duration(days: day));
      final dailyCount = random.nextInt(3) + 2; // 2–4 expenses per day
      for (int i = 0; i < dailyCount; i++) {
        final title = sampleTitles[random.nextInt(sampleTitles.length)];
        final category = categories[random.nextInt(categories.length)];
        final amount = (random.nextDouble() * 100) + 10; // RM10–RM110

        generatedExpenses.add(
          Expense(
            name: title,
            amount: double.parse(amount.toStringAsFixed(2)),
            date: date,
            category: category,
            location: "Melaka",
          ),
        );
      }
    }

    expenses = generatedExpenses;
    budget = 1000; // default mock budget
    notifyListeners();
  }
}
