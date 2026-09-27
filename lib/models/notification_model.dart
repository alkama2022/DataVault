/// In-app notification model.
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool isRead;
  final NotificationCategory category;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
    this.category = NotificationCategory.general,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        date: date,
        isRead: isRead ?? this.isRead,
        category: category,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'date': date.toIso8601String(),
        'isRead': isRead,
        'category': category.name,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        date: DateTime.parse(json['date'] as String),
        isRead: json['isRead'] as bool? ?? false,
        category: NotificationCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => NotificationCategory.general,
        ),
      );
}

enum NotificationCategory { general, transaction, promotion, security }
