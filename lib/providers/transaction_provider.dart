import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();
    
    _transactions = await _db.getTransactions();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _db.insertTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _db.deleteTransaction(id);
    await loadTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _db.updateTransaction(transaction);
    await loadTransactions();
  }

  List<Transaction> getFilteredTransactions(String filter, String searchQuery) {
    List<Transaction> filtered = _transactions;

    // Apply date filter
    if (filter == 'Today') {
      final now = DateTime.now();
      filtered = filtered.where((t) => 
        t.date.year == now.year && 
        t.date.month == now.month && 
        t.date.day == now.day
      ).toList();
    } else if (filter == 'This Week') {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      filtered = filtered.where((t) => t.date.isAfter(weekStart.subtract(const Duration(days: 1)))).toList();
    } else if (filter == 'This Month') {
      final now = DateTime.now();
      filtered = filtered.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
    }

    // Apply search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((t) => 
        t.party.toLowerCase().contains(searchQuery.toLowerCase()) ||
        t.rate.toString().contains(searchQuery)
      ).toList();
    }

    return filtered;
  }
}
