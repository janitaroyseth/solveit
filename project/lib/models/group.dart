import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String groupId;
  List<String> members;
  String recentMessage;
  DateTime lastUpdated;

  Group({
    this.groupId = "",
    required this.members,
    this.recentMessage = "",
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      "groupId": groupId,
      "members": members,
      "recentMessage": recentMessage,
      "lastUpdated": lastUpdated,
    };
  }

  static Group? fromMap(Map<String, dynamic> data) {
    final groupId = data["groupId"];
    final members = data["members"].cast<String>();
    final recentMessage = data["recentMessage"];
    final lastUpdated = data["lastUpdated"] != null
        ? (data["lastUpdated"] as Timestamp).toDate()
        : null;

    return Group(
      groupId: groupId,
      members: members,
      recentMessage: recentMessage,
      lastUpdated: lastUpdated,
    );
  }

  static List<Group> fromMaps(var data) {
    List<Group> groups = [];
    for (var value in data) {
      Group? group = fromMap(value.data());
      if (group != null) {
        groups.add(group);
      }
    }
    return groups;
  }
}
