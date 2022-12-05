import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/alert.dart';
import 'package:project/services/auth_service.dart';

/// Business logic for alerts.
abstract class AlertService {
  /// Saves the given [alert] to the user with the given [userId].
  Future<Alert> saveAlert(Alert alert, String userId);

  /// Returns a stream of the alert belonging to the current user.
  Stream<Alert?> getAlert();
}

/// Firebaseimplementation of AlertService.
class FirebaseAlertService implements AlertService {
  CollectionReference<Map<String, dynamic>> alertsCollection(String userId) =>
      FirebaseFirestore.instance
          .collection("alerts")
          .doc(userId)
          .collection("alert");

  @override
  Stream<Alert?> getAlert() {
    return alertsCollection(Auth().currentUser!.uid)
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      if (event.isEmpty) return null;
      return Alert.fromMap(event.first.data());
    });
  }

  @override
  Future<Alert> saveAlert(Alert alert, String userId) async {
    if (alert.alertId == "") {
      alert.alertId = (await alertsCollection(userId).add(alert.toMap())).id;
    }
    await alertsCollection(userId).doc(alert.alertId).set(alert.toMap());

    return alert;
  }
}
