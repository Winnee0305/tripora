import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/expense_repository.dart';
import 'package:tripora/core/utils/date_utils.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/expense/models/expense.dart';

class ExpenseViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepo;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();

  bool isEditingInitialized = false;
  double budget = 0;
  List<Expense> expenses = [];
  int? selectedDayIndex;
  TripData? trip;

  ExpenseViewModel(this._expenseRepo);
  setTrip(TripData tripData) {
    trip = tripData;
  }

  initialise() {}

  bool validateForm() => {
    nameController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty &&
        selectedCategory != null,
  }.every((element) => element == true);

  // ----- Expense List Management
  List<Expense> getExpensesForDate(DateTime date) =>
      expenses.where((e) => isSameDay(e.date, date)).toList();

  List<Expense> get filteredExpenses {
    if (selectedDayIndex == null) return expenses;
    return expenses.where((e) {
      final idx = expenseDayIndex(e);
      return idx != null && idx == selectedDayIndex;
    }).toList();
  }

  int get tripDays {
    final days = trip!.endDate!.difference(trip!.startDate!).inDays + 1;
    return days > 0 ? days : 1;
  }

  int? expenseDayIndex(Expense expense) {
    final d = DateTime(expense.date.year, expense.date.month, expense.date.day);
    final start = DateTime(
      trip!.startDate!.year,
      trip!.startDate!.month,
      trip!.startDate!.day,
    );
    final diff = d.difference(start).inDays;
    if (diff < 0 || diff >= tripDays) return null;
    return diff;
  }

  double get totalExpense => expenses.fold<double>(0, (s, e) => s + e.amount);

  double get totalForSelected =>
      filteredExpenses.fold<double>(0, (s, e) => s + e.amount);

  ExpenseCategory? selectedCategory;

  List<ExpenseCategory> get categories => ExpenseCategory.values;

  // ----- Daily expense management

  void setSelectedDay(int? index) {
    selectedDayIndex = index;
    notifyListeners();
  }

  // ----- Expense Form Management
  Expense getNewExpense() {
    return Expense(
      name: nameController.text.trim(),
      description: descController.text.trim(),
      category: selectedCategory ?? ExpenseCategory.other,
      amount: amountController.text.isNotEmpty
          ? double.parse(amountController.text)
          : 0.0,
      date: trip!.startDate!.add(Duration(days: selectedDayIndex ?? 0)),
    );
  }

  void populateFromExpense(Expense expense) {
    amountController.text = expense.amount.toString();
    nameController.text = expense.name;
    descController.text = expense.description ?? '';
    categoryController.text = expense.category.name.capitalize();
    selectedCategory = expense.category;
    isEditingInitialized = true;
    notifyListeners();
  }

  void setCategory(ExpenseCategory? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void clearForm() {
    amountController.clear();
    nameController.clear();
    descController.clear();
    categoryController.clear();
    selectedCategory = null;
    isEditingInitialized = false;
    notifyListeners();
  }

  void updateExpense(Expense oldExpense) {
    final index = expenses.indexOf(oldExpense);
    if (index != -1) {
      expenses[index] = getNewExpense();
      notifyListeners();
    }
  }

  void addExpense() {
    final newExpense = getNewExpense();
    expenses.add(newExpense);
    notifyListeners();
  }

  // ----- Budget Management
  void updateBudget(double newBudget) {
    budget = newBudget;
    notifyListeners();
  }

  // ----- Expense Icon Mapping
  IconData getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant_menu_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.accommodation:
        return Icons.hotel_rounded;
      case ExpenseCategory.entertainment:
        return Icons.movie_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.other:
        return Icons.receipt_long_rounded;
    }
  }

  // ----- Cleanup
  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  // ----- Mock data
  void loadMockData() {
    final random = Random();

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

    for (int day = 0; day < tripDays; day++) {
      final date = trip!.startDate!.add(Duration(days: day));
      final dailyCount = random.nextInt(3) + 2; // 2–4 expenses per day
      for (int i = 0; i < dailyCount; i++) {
        final title = sampleTitles[random.nextInt(sampleTitles.length)];
        final amount = (random.nextDouble() * 100) + 10; // RM10–RM110

        generatedExpenses.add(
          Expense(
            name: title,
            amount: double.parse(amount.toStringAsFixed(2)),
            date: date,
            category: ExpenseCategory
                .values[random.nextInt(ExpenseCategory.values.length)],
            description: "Melaka",
          ),
        );
      }
    }

    expenses = generatedExpenses;
    budget = 1000; // Default mock budget
    notifyListeners();
  }
}
