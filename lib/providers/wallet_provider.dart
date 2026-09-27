import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

/// Wallet, transactions and purchase state notifier.
class WalletProvider extends ChangeNotifier {
  WalletProvider(this._api, {NotificationService? notificationService})
      : _notificationService = notificationService;

  final ApiService _api;
  final NotificationService? _notificationService;

  bool _isLoading = false;
  bool _isProcessing = false;
  String? _error;
  UserModel? _user;
  List<TransactionModel> _transactions = [];

  bool get isLoading => _isLoading;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  UserModel? get user => _user;
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  double get walletBalance => _user?.walletBalance ?? 0;
  double get earnings => _user?.earnings ?? 0;

  /// Loads the user profile and transaction history.
  Future<void> loadDashboard() async {
    _setLoading(true);
    try {
      final balance = await _api.fetchWalletBalance();
      final txns = await _api.fetchTransactions();
      _user = _api.currentUser;
      // Ensure balance reflects latest fetch.
      _user = _user?.copyWith(walletBalance: balance);
      _transactions = txns;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> fundWallet(double amount) async {
    return _process(() async {
      final newBalance = await _api.fundWallet(amount);
      _user = _user?.copyWith(walletBalance: newBalance);
      await _refreshTransactions();
    });
  }

  Future<bool> withdraw(double amount) async {
    return _process(() async {
      final newEarnings = await _api.withdraw(amount);
      _user = _user?.copyWith(earnings: newEarnings);
      await _refreshTransactions();
    });
  }

  Future<TransactionModel?> purchase({
    required TransactionType type,
    required String description,
    required double amount,
  }) async {
    TransactionModel? result;
    final ok = await _process(() async {
      result = await _api.purchase(
        type: type,
        description: description,
        amount: amount,
      );
      _user = _api.currentUser;
      await _refreshTransactions();
      // Fire in-app notification for the completed purchase.
      if (result != null) {
        await _notificationService?.notifyTransaction(result!);
      }
    });
    return ok ? result : null;
  }

  Future<void> _refreshTransactions() async {
    _transactions = await _api.fetchTransactions();
  }

  Future<bool> _process(Future<void> Function() action) async {
    _setProcessing(true);
    try {
      await action();
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }
}
