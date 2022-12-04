import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a notification.
class Notification {
  /// The user id of the recipient of the notification.
  String userId;

  /// The id of the notification itself.
  String notificationId;

  /// The message of the notification.
  String message;

  /// The time the notification was sent.
  DateTime sentAt;

  /// Creates an instance of [Notification].
  Notification({
    required this.userId,
    this.notificationId = "",
    required this.message,
    required this.sentAt,
  });

  /// Returns a notification gathered from the given map..
  static Notification fromMap(Map<String, dynamic> data) {
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

  /// Returns a collection of notifications from the given data.
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
