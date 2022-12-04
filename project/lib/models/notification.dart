import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String userId;
  String notificationId;
  String message;
  DateTime sentAt;

  Notification({
    required this.userId,
    this.notificationId = "",
    required this.message,
    required this.sentAt,
  });

  static Notification fromMap(var data) {
    String userId = data["userId"];
    String notificationId = data["notificationId"] ?? "";
    String message = data["message"];
    DateTime sentAt = (data["sentAt"] as Timestamp).toDate();

    return Notification(
        userId: userId,
        notificationId: notificationId,
        message: message,
        sentAt: sentAt);
  }

  static List<Notification> fromMaps(var data) {
    List<Notification> notifications = [];

    for (var value in data) {
      if (data is List<Map<String, dynamic>>) {
        Notification? notification = fromMap(value);
        notifications.add(notification);
      } else {
        Notification? notification = fromMap(value.data());
        notifications.add(notification);
      }
    }
    return notifications;
  }
}
