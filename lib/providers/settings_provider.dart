import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// Settings state: dark mode toggle, notification preferences.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._storage) {
    _darkMode = _storage.darkMode;
  }

  final StorageService _storage;

  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _transactionAlerts = true;
  bool _promotionalOffers = false;

  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get transactionAlerts => _transactionAlerts;
  bool get promotionalOffers => _promotionalOffers;

  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    await _storage.setDarkMode(_darkMode);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  Future<void> toggleTransactionAlerts() async {
    _transactionAlerts = !_transactionAlerts;
    notifyListeners();
  }

  Future<void> togglePromotionalOffers() async {
    _promotionalOffers = !_promotionalOffers;
    notifyListeners();
  }
}
