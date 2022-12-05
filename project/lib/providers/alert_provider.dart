import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/alert.dart';
import 'package:project/services/alert_service.dart';

class AlertNotifier extends StateNotifier<Stream<Alert?>> {
  final AlertService alertService;
  AlertNotifier(super.state, this.alertService);

  void saveAlert(Alert alert, String userId) {
    alertService.saveAlert(alert, userId);
  }

  Stream<Alert?> getAlert() {
    return alertService.getAlert();
  }
}

final alertServiceProvider = Provider<AlertService>((ref) {
  final AlertService alertService = FirebaseAlertService();
  return alertService;
});

final alertProvider =
    StateNotifierProvider<AlertNotifier, Stream<Alert?>>((ref) {
  final alertService = ref.watch(alertServiceProvider);
  final userAlert = alertService.getAlert();
  return AlertNotifier(userAlert, alertService);
});
