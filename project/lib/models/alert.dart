/// Represents an alert for user, contains information about
/// if latest message has been seen or not.
class Alert {
  /// The id of the alert.
  String alertId;

  /// Whether the notifications has not been seen.
  bool unseenNotification;

  /// Whether a message has not been seen.
  bool unseenMessage;

  /// A set of group ids of containing the messages that
  /// have not been read.
  Set<String> groupIds;

  /// Creates an instance of [Alert].
  Alert({
    this.alertId = "",
    required this.unseenNotification,
    this.unseenMessage = false,
    required this.groupIds,
  });

  /// Creates an instance of [Alert] from the given map.
  static Alert fromMap(Map<String, dynamic> data) {
    String alertId = data["alertId"];
    bool unseenNotification = data["unseenNotification"];
    final groupIdsList = List<String>.from(data["groupIds"]);
    final groupIds = groupIdsList.toSet();
    bool unseenMessage = groupIds.isNotEmpty;

    return Alert(
      alertId: alertId,
      unseenNotification: unseenNotification,
      unseenMessage: unseenMessage,
      groupIds: groupIds,
    );
  }

  /// Creates an instance of [List<Alert>] from the given maps.
  static List<Alert> fromMaps(var data) {
    List<Alert> alerts = [];

    for (var value in data) {
      if (data is List<Map<String, dynamic>>) {
        Alert? alert = fromMap(value);
        alerts.add(alert);
      } else {
        Alert? alert = fromMap(value.data());
        alerts.add(alert);
      }
    }
    return alerts;
  }

  /// Converts the alert to a map of string and dynamic.
  Map<String, dynamic> toMap() {
    return {
      "alertId": alertId,
      "unseenNotification": unseenNotification,
      "groupIds": groupIds.toList(),
    };
  }
}
