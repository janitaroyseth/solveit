import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/notifications_service.dart';

/// Notifications provider for displaying notifications in app.
final notificationProvider = Provider<NotificationService>((ref) {
  final NotificationService notificationService = FirebaseNotificationService();
  return notificationService;
});
