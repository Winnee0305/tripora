import 'package:flutter/material.dart';
import 'package:tripora/core/models/expense_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/expense_repository.dart';
import 'package:tripora/core/utils/date_utils.dart';
import 'package:tripora/core/utils/format_utils.dart';

class ExpenseViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepo;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();

  bool isEditingInitialized = false;
  double budget = 0;
  List<ExpenseData> expenses = [];
  int? selectedDayIndex;
  TripData? trip;
  bool _isLoading = false;
  bool showErrors = false;

  bool get isLoading => _isLoading;

  ExpenseViewModel(this._expenseRepo);
  setTrip(TripData tripData) {
    trip = tripData;
  }

  Future<void> initialise() async {
    await loadExpenses();
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Fetching expense");
      expenses = await _expenseRepo.getExpenses(trip!.tripId);
      budget = await _expenseRepo.getBudget(trip!.tripId);
      print('Expenses loaded: ${expenses.length} items');
    } catch (e) {}

    _isLoading = false;
    notifyListeners();
  }

  bool validateForm() {
    final isValid =
        nameController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty &&
        selectedCategory != null;

    showErrors = !isValid; // trigger error display
    notifyListeners();
    return isValid;
  }

  // ----- Expense List Management
  List<ExpenseData> getExpensesForDate(DateTime date) =>
      expenses.where((e) => isSameDay(e.date, date)).toList();

  List<ExpenseData> get filteredExpenses {
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

  int? expenseDayIndex(ExpenseData expense) {
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

  double get totalExpense =>
      expenses.fold<double>(0, (s, e) => s + (e.amount ?? 0));

  double get totalForSelected =>
      filteredExpenses.fold<double>(0, (s, e) => s + (e.amount ?? 0));

  ExpenseCategory? selectedCategory;

  List<ExpenseCategory> get categories => ExpenseCategory.values;

  // ----- Daily expense management

  void setSelectedDay(int? index) {
    selectedDayIndex = index;
    notifyListeners();
  }

  // ----- Expense Form Management
  ExpenseData getNewExpense(String? oldId) {
    final newExpense = ExpenseData.empty();
    return newExpense.copyWith(
      id: oldId ?? '',
      name: nameController.text.trim(),
      desc: descController.text.trim(),
      category: selectedCategory ?? ExpenseCategory.other,
      amount: amountController.text.isNotEmpty
          ? double.parse(amountController.text)
          : 0.0,
      date: trip!.startDate!.add(Duration(days: selectedDayIndex ?? 0)),
      lastUpdated: DateTime.now(),
    );
  }

  void populateFromExpense(ExpenseData expense) {
    amountController.text = expense.amount.toString();
    nameController.text = expense.name;
    descController.text = expense.desc ?? '';
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

  void updateExpense(ExpenseData oldExpense) {
    final index = expenses.indexOf(oldExpense);
    if (index != -1) {
      expenses[index] = getNewExpense(oldExpense.id);
      _expenseRepo.updateExpense(expenses[index], trip!.tripId);
      notifyListeners();
    }
  }

  void addExpense() {
    final newExpense = getNewExpense(null);
    expenses.add(newExpense);
    _expenseRepo.createExpense(newExpense, trip!.tripId);
    notifyListeners();
  }

  // ----- Budget Management
  void updateBudget(double newBudget) {
    budget = newBudget;
    _expenseRepo.updateBudget(newBudget, trip!.tripId);
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
}
