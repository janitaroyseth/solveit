import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/group.dart';

void main() {
  group("constructor", () {
    test("valid missing data", () {
      List<String> members = ["my user id goes here", "your user id too"];

      final group = Group(members: members);

      expect(group, isNot(null));
      expect(group.members, members);
    });

    test("valid all data passed", () {
      String groupId = "some id";
      List<String> members = ["my user id goes here", "your user id too"];
      String recentMessage = "recently";
      DateTime lastUpdated = DateTime.now();

      final group = Group(
          groupId: groupId,
          members: members,
          recentMessage: recentMessage,
          lastUpdated: lastUpdated);

      expect(group, isNot(null));
      expect(group.groupId, groupId);
      expect(group.members, members);
      expect(group.recentMessage, recentMessage);
      expect(group.lastUpdated, lastUpdated);
    });
  });

  group("from map", () {
    test("null data", () {
      final message = Group.fromMap(null);
      expect(message, null);
    });

    test("missing data", () {
      final group = Group.fromMap({});

      expect(group, null);
    });

    test("valid data", () {
      String groupId = "some id";
      List<String> members = ["my user id goes here", "your user id too"];

      final group = Group.fromMap({
        "groupId": groupId,
        "members": members,
      });

      expect(group, isNot(null));
      expect(
        group,
        Group(groupId: groupId, members: members),
      );
    });
  });
}
