import '../models/notification_model.dart';
import '../models/transaction_model.dart';
import 'storage_service.dart';

/// Manages in-app notifications.
///
/// Currently backed by local storage. To integrate a push notification
/// service (FCM, OneSignal, etc.), add the send logic here — the rest
/// of the app only depends on [NotificationService]'s contract.
class NotificationService {
  NotificationService(this._storage);

  final StorageService _storage;

  static const _key = 'notifications';

  List<AppNotification> get notifications {
    final raw = _storage.getList(_key);
    return raw.map(AppNotification.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> markAsRead(String id) async {
    final list = notifications.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    await _save(list);
  }

  Future<void> markAllAsRead() async {
    final list = notifications.map((n) => n.copyWith(isRead: true)).toList();
    await _save(list);
  }

  Future<void> clearAll() async => _storage.remove(_key);

  /// Creates a transaction notification after a purchase.
  Future<void> notifyTransaction(TransactionModel txn) async {
    final list = notifications;
    list.insert(
      0,
      AppNotification(
        id: 'ntf_${DateTime.now().millisecondsSinceEpoch}',
        title: '${txn.typeLabel} Successful',
        body: '${txn.description} — ₦${txn.amount.toStringAsFixed(2)}',
        date: DateTime.now(),
        category: NotificationCategory.transaction,
      ),
    );
    await _save(list);
  }

  Future<void> _save(List<AppNotification> list) async {
    await _storage.setList(_key, list.map((n) => n.toJson()).toList());
  }
}
