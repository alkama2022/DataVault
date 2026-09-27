import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/empty_state.dart';

/// Notifications screen with read/unread states and mark-all-as-read.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  IconData _iconFor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.transaction:
        return Icons.receipt_long_rounded;
      case NotificationCategory.promotion:
        return Icons.local_offer_rounded;
      case NotificationCategory.security:
        return Icons.shield_rounded;
      case NotificationCategory.general:
        return Icons.notifications_rounded;
    }
  }

  Color _colorFor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.transaction:
        return AppColors.success;
      case NotificationCategory.promotion:
        return AppColors.gold;
      case NotificationCategory.security:
        return AppColors.error;
      case NotificationCategory.general:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = notificationService.notifications;
    final unreadCount = notificationService.unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () => notificationService.markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_off_rounded,
              title: 'No notifications',
              message: 'You\'re all caught up! New notifications will appear here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, i) {
                final n = notifications[i];
                final color = _colorFor(n.category);
                return Dismissible(
                  key: Key(n.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => notificationService.clearAll(),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: n.isRead
                          ? Theme.of(context).cardColor
                          : AppColors.primaryLight.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: n.isRead ? AppColors.border : AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => notificationService.markAsRead(n.id),
                      borderRadius: BorderRadius.circular(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_iconFor(n.category), color: color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        n.title,
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: n.isRead
                                              ? FontWeight.w500
                                              : FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (!n.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  n.body,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('MMM d, yyyy • h:mm a').format(n.date),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
