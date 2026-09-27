import 'dart:math';
import '../models/user_model.dart';
import 'storage_service.dart';

/// Result of an authentication operation.
class AuthResult {
  final bool success;
  final String? error;
  final UserModel? user;

  const AuthResult({required this.success, this.error, this.user});
}

/// Handles authentication against the backend.
///
/// NOTE: This currently uses a local mock implementation so the app is
/// fully functional offline. To connect a real backend, replace the body
/// of each method with an HTTP call (e.g. via `http` or `dio`) to your
/// authentication endpoint — the method signatures and [AuthResult]
/// contract stay the same.
class AuthService {
  AuthService(this._storage);

  final StorageService _storage;

  /// Simulated network latency.
  static const _latency = Duration(milliseconds: 900);

  UserModel? get currentUser {
    final data = _storage.user;
    return data == null ? null : UserModel.fromJson(data);
  }

  bool get isLoggedIn => _storage.token != null && currentUser != null;

  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(_latency);

    if (email.isEmpty || password.isEmpty) {
      return const AuthResult(success: false, error: 'Email and password are required.');
    }
    if (password.length < 6) {
      return const AuthResult(success: false, error: 'Password must be at least 6 characters.');
    }

    // Mock: accept any well-formed credentials.
    final user = UserModel(
      id: 'usr_${Random().nextInt(99999)}',
      fullName: _nameFromEmail(email),
      email: email,
      phoneNumber: '',
      walletBalance: 255008.00,
      earnings: 81200.00,
      currentPlan: 'Premium Plan',
      createdAt: DateTime.now(),
    );
    await _persistSession(user);
    return AuthResult(success: true, user: user);
  }

  Future<AuthResult> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    await Future.delayed(_latency);

    if (fullName.trim().length < 2) {
      return const AuthResult(success: false, error: 'Please enter your full name.');
    }
    if (!_isValidEmail(email)) {
      return const AuthResult(success: false, error: 'Please enter a valid email address.');
    }
    if (phoneNumber.trim().length < 10) {
      return const AuthResult(success: false, error: 'Please enter a valid phone number.');
    }
    if (password.length < 6) {
      return const AuthResult(success: false, error: 'Password must be at least 6 characters.');
    }
    if (password != confirmPassword) {
      return const AuthResult(success: false, error: 'Passwords do not match.');
    }

    final user = UserModel(
      id: 'usr_${Random().nextInt(99999)}',
      fullName: fullName.trim(),
      email: email,
      phoneNumber: phoneNumber.trim(),
      walletBalance: 0,
      earnings: 0,
      currentPlan: 'Free Plan',
      createdAt: DateTime.now(),
    );
    await _persistSession(user);
    return AuthResult(success: true, user: user);
  }

  Future<AuthResult> resetPassword(String email) async {
    await Future.delayed(_latency);
    if (!_isValidEmail(email)) {
      return const AuthResult(success: false, error: 'Please enter a valid email address.');
    }
    // Mock: always succeed for well-formed emails.
    return const AuthResult(success: true);
  }

  Future<void> logout() async {
    await _storage.clearToken();
  }

  /// Updates the current user's profile.
  Future<UserModel?> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? email,
  }) async {
    final user = currentUser;
    if (user == null) return null;
    final updated = user.copyWith(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
    );
    await _storage.saveUser(updated.toJson());
    return updated;
  }

  Future<void> _persistSession(UserModel user) async {
    await _storage.saveUser(user.toJson());
    await _storage.setToken('mock_token_${user.id}');
  }

  static bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  static String _nameFromEmail(String email) {
    final local = email.split('@').first;
    final parts = local.split(RegExp(r'[._\d]+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return 'User';
    return parts.map((p) => p[0].toUpperCase() + p.substring(1)).join(' ');
  }
}
