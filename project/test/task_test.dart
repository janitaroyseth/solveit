import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';

void main() {
  group("from map", () {
    test("null data", () {
      final message = Task.fromMap(null);
      expect(message, null);
    });

    test(
      "missing data",
      () {
        String taskId = "some id";
        String title = "an awesome task title";

        final message = Task.fromMap({
          "taskId": taskId,
          "title": title,
        });

        expect(message, null);
      },
    );

    test("valid data", () {
      String taskId = "some id";
      String projectId = "some project id";
      String title = "an awesome title for your task";
      String description = "a cool description";
      bool done = false;
      Timestamp deadline = Timestamp.fromDate(DateTime.now());
      List<String> assigned = ["my user id goes here", "your user id too"];
      List<Map<String, dynamic>> tags = [
        {"tagId": "some tag id", "text": "awesome", "color": "#0400FF"},
        {"tagId": "other tag id", "text": "cool", "color": "#0400FF"},
      ];

      final task = Task.fromMap({
        "taskId": taskId,
        "projectId": projectId,
        "title": title,
        "description": description,
        "done": done,
        "deadline": deadline,
        "assigned": assigned,
        "tags": tags,
      });

      expect(task, isNot(null));
      expect(
        task,
        Task(
          taskId: taskId,
          projectId: projectId,
          title: title,
          description: description,
          done: done,
          deadline: deadline.toDate(),
          assigned: assigned,
          tags: Tag.fromMaps(tags),
        ),
      );
    });

    test("valid with missing data", () {
      String taskId = "some id";
      String projectId = "some project id";
      String title = "an awesome title for your task";
      String description = "a cool description";
      bool done = false;
      Timestamp deadline = Timestamp.fromDate(DateTime.now());

      final task = Task.fromMap({
        "taskId": taskId,
        "projectId": projectId,
        "title": title,
        "description": description,
        "done": done,
        "deadline": deadline,
      });

      expect(task, isNot(null));
      expect(
        task,
        Task(
          taskId: taskId,
          projectId: projectId,
          title: title,
          description: description,
          done: done,
          deadline: deadline.toDate(),
        ),
      );
    });
  });

  test("to map", () {
    String taskId = "some id";
    String projectId = "some project id";
    String title = "an awesome title for your task";
    String description = "a cool description";
    bool done = false;
    Timestamp deadline = Timestamp.fromDate(DateTime.now());
    List<String> assigned = ["my user id goes here", "your user id too"];
    List<Map<String, dynamic>> tags = [
      {"tagId": "some tag id", "text": "awesome", "color": "#0400FF"},
      {"tagId": "other tag id", "text": "cool", "color": "#0400FF"},
    ];

    final task = Task(
      taskId: taskId,
      projectId: projectId,
      title: title,
      description: description,
      done: done,
      deadline: deadline.toDate(),
      assigned: assigned,
      tags: Tag.fromMaps(tags),
    ).toMap();

    expect(task, isNot(null));
    expect(task, {
      "taskId": taskId,
      "projectId": projectId,
      "title": title,
      "description": description,
      "done": done,
      "deadline": deadline.toDate(),
      "assigned": assigned,
      "tags": tags,
    });
  });
}
