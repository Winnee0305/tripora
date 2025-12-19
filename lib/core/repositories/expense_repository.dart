import 'package:tripora/core/models/expense_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class ExpenseRepository {
  final FirestoreService _firestoreService;
  final String _uid; // The current user's ID

  ExpenseRepository(this._firestoreService, this._uid);
  // ---- CREATE ----
  Future<void> createExpense(ExpenseData expense, String tripId) async {
    await _firestoreService.addExpense(_uid, expense, tripId);
  }

  // ---- READ (All for this trip) ----
  Future<List<ExpenseData>> getExpenses(String tripId) async {
    return await _firestoreService.getExpenses(_uid, tripId);
  }

  // ---- DELETE ----
  Future<void> deleteExpense(String expenseId, String tripId) async {
    await _firestoreService.deleteExpense(_uid, expenseId, tripId);
  }

  // ---- UPDATE ----
  Future<void> updateExpense(ExpenseData expense, String tripId) async {
    await _firestoreService.updateExpense(_uid, expense, tripId);
  }

  // ---- READ BUDGET ----
  Future<double> getBudget(String tripId) async {
    return await _firestoreService.getExpenseBudget(_uid, tripId);
  }

  // ---- UPDATE BUDGET ----
  Future<void> updateBudget(double newBudget, String tripId) async {
    await _firestoreService.updateExpenseBudget(_uid, newBudget, tripId);
  }
}
