import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xor_cipher/xor_cipher.dart';

/// Represents a group of user's in a chat conversation.
class Group {
  /// The id of the group.
  String groupId;

  /// List of the member's user id's.
  List<String> members;

  /// The most recent message sent.
  String recentMessage;

  /// When the group was last updated.
  DateTime lastUpdated;

  static String encryptionKey = "${dotenv.env["MESSAGE_ENCRYPTION_KEY"]}";

  /// Creates an instance of [Group].
  Group({
    this.groupId = "",
    required this.members,
    this.recentMessage = "",
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Returns this instance of groups as a [Map<String, dynamic].
  Map<String, dynamic> toMap() {
    return {
      "groupId": groupId,
      "members": members,
      "recentMessage": XOR.encrypt(recentMessage, encryptionKey),
      "lastUpdated": lastUpdated,
    };
  }

  /// Convers the given [data] of [Map<String, dynamic] to a new instance
  /// of [Group]. If data wasn't valid [null] is returned.
  static Group? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final groupId = data["groupId"];

    if (data["members"] == null) return null;
    final members = data["members"].cast<String>();

    final recentMessage = data["recentMessage"] != null
        ? XOR.decrypt(data["recentMessage"], encryptionKey)
        : "";

    final lastUpdated = data["lastUpdated"] != null
        ? (data["lastUpdated"] as Timestamp).toDate()
        : null;

    if (groupId == null || members == null) {
      return null;
    }

    return Group(
      groupId: groupId,
      members: members,
      recentMessage: recentMessage,
      lastUpdated: lastUpdated,
    );
  }

  /// Creates new instances of [Group] for the list
  /// given, returns the list of group.
  static List<Group> fromMaps(var data) {
    List<Group> groups = [];
    for (var value in data) {
      Group? group;
      if (data is List<Map<String, dynamic>>) {
        group = fromMap(value);
      } else {
        group = fromMap(value.data());
      }
      if (group != null) {
        groups.add(group);
      }
    }
    return groups;
  }

  @override
  int get hashCode => groupId.hashCode;

  @override
  bool operator ==(Object other) {
    return groupId == (other as Group).groupId;
  }
}
