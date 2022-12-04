import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/notification.dart';

abstract class NotificationService {
  Stream<List<Notification>> getNotificationsForUser(String userId);
}

class FirebaseNotificationService implements NotificationService {
  CollectionReference<Map<String, dynamic>> notificationsCollection(
          String userId) =>
      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("notifications");
  @override
  Stream<List<Notification>> getNotificationsForUser(String userId) {
    return notificationsCollection(userId)
        .orderBy("sentAt", descending: true)
        .snapshots()
        .map((event) => event.docs)
        .map((event) => Notification.fromMaps(event));
  }
}
