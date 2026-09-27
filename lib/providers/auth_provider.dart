import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Authentication state notifier.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;

  bool _isLoading = false;
  String? _error;
  UserModel? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get user => _user;
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Restores a previously persisted session (called at startup).
  void restoreSession() {
    _user = _authService.currentUser;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    final result = await _authService.login(email, password);
    _setLoading(false);

    if (result.success) {
      _user = result.user;
      _error = null;
      notifyListeners();
      return true;
    }
    _error = result.error;
    notifyListeners();
    return false;
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    final result = await _authService.signUp(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    );
    _setLoading(false);

    if (result.success) {
      _user = result.user;
      _error = null;
      notifyListeners();
      return true;
    }
    _error = result.error;
    notifyListeners();
    return false;
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    final result = await _authService.resetPassword(email);
    _setLoading(false);

    if (result.success) {
      _error = null;
      return true;
    }
    _error = result.error;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  /// Updates the current user's profile.
  Future<UserModel?> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? email,
  }) async {
    final updated = await _authService.updateProfile(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
    );
    if (updated != null) {
      _user = updated;
      notifyListeners();
    }
    return updated;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
