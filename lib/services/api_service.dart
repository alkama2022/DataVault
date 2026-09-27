import 'dart:math';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

/// Simulated latency for mock API calls.
const _apiLatency = Duration(milliseconds: 700);

/// Central API layer for wallet, transactions and service purchases.
///
/// All methods are currently backed by local mock data so the app works
/// offline end-to-end. To integrate a real backend, swap the mock bodies
/// for HTTP requests — the method contracts remain unchanged.
class ApiService {
  ApiService(this._storage);

  final StorageService _storage;

  /// The currently authenticated user, or null when not logged in.
  UserModel? get currentUser {
    final data = _storage.user;
    return data == null ? null : UserModel.fromJson(data);
  }

  // ── Wallet ──────────────────────────────────────────────────────────

  Future<double> fetchWalletBalance() async {
    await Future.delayed(_apiLatency);
    return _storage.user?['walletBalance'] as double? ?? 0;
  }

  /// Funds the wallet. Returns the new balance.
  Future<double> fundWallet(double amount) async {
    await Future.delayed(_apiLatency);
    if (amount <= 0) throw ApiException('Amount must be greater than zero.');
    if (amount > 10000000) throw ApiException('Amount exceeds the maximum limit.');

    final user = _currentUser();
    final newBalance = user.walletBalance + amount;
    await _storage.saveUser(user.copyWith(walletBalance: newBalance).toJson());
    await _addTransaction(TransactionModel(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.walletFunding,
      description: 'Wallet funding',
      amount: amount,
      status: TransactionStatus.success,
      date: DateTime.now(),
      reference: _reference(),
    ));
    return newBalance;
  }

  /// Withdraws earnings. Returns the new earnings balance.
  Future<double> withdraw(double amount) async {
    await Future.delayed(_apiLatency);
    final user = _currentUser();
    if (amount <= 0) throw ApiException('Amount must be greater than zero.');
    if (amount > user.earnings) throw ApiException('Insufficient earnings balance.');

    final newEarnings = user.earnings - amount;
    await _storage.saveUser(user.copyWith(earnings: newEarnings).toJson());
    await _addTransaction(TransactionModel(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.withdrawal,
      description: 'Withdrawal to bank',
      amount: amount,
      status: TransactionStatus.success,
      date: DateTime.now(),
      reference: _reference(),
    ));
    return newEarnings;
  }

  // ── Purchases ───────────────────────────────────────────────────────

  /// Purchases a service (airtime, data, etc.) using wallet balance.
  /// Returns the created transaction.
  Future<TransactionModel> purchase({
    required TransactionType type,
    required String description,
    required double amount,
  }) async {
    await Future.delayed(_apiLatency);
    if (amount <= 0) throw ApiException('Amount must be greater than zero.');

    final user = _currentUser();
    if (user.walletBalance < amount) {
      throw ApiException('Insufficient wallet balance. Please fund your wallet.');
    }

    await _storage.saveUser(
      user.copyWith(walletBalance: user.walletBalance - amount).toJson(),
    );
    final txn = TransactionModel(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      description: description,
      amount: amount,
      status: TransactionStatus.success,
      date: DateTime.now(),
      reference: _reference(),
    );
    await _addTransaction(txn);
    return txn;
  }

  // ── Transactions ────────────────────────────────────────────────────

  Future<List<TransactionModel>> fetchTransactions() async {
    await Future.delayed(_apiLatency);
    return _storage.transactions
        .map(TransactionModel.fromJson)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // ── Helpers ─────────────────────────────────────────────────────────

  UserModel _currentUser() {
    final data = _storage.user;
    if (data == null) throw ApiException('Not authenticated.');
    return UserModel.fromJson(data);
  }

  Future<void> _addTransaction(TransactionModel txn) async {
    final list = _storage.transactions;
    list.insert(0, txn.toJson());
    await _storage.saveTransactions(list);
  }

  static String _reference() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random();
    return List.generate(12, (_) => chars[rnd.nextInt(chars.length)]).join();
  }
}

/// Thrown when an API call fails.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
