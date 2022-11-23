import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/comment.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/user.dart';

/// Represents a task in a project.
class Task {
  // The id of the task.
  String taskId;
  // The name of the task.
  String title;
  // The description of the task.
  String description;
  // The list of tags belonging to the task.
  List<Tag> tags;
  // Whether or not the task has been completed.
  bool done;
  // The (optional) deadline of the task.
  DateTime? deadline;
  // List of comments of this task.
  List<Comment> comments;

  List<User> assigned;

  Task({
    this.taskId = "",
    this.title = "task title",
    this.description = "task description",
    this.tags = const [],
    this.done = false,
    this.deadline,
    List<Comment>? comments,
    this.assigned = const [],
  }) : comments = comments ?? [];

  /// Converts a [Map] object to a [Task] object.
  static Task? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String taskId = data["taskId"];
    final String title = data['title'];
    final String description = data['description'];
    final bool done = data['done'];
    final DateTime? deadline = data['deadline'] != null
        ? (data['deadline'] as Timestamp).toDate()
        : null;
    final List<Comment> comments = [];
    final List<User> assigned = [];
    final List<Tag> tags = [];

    return Task(
        taskId: taskId,
        title: title,
        description: description,
        done: done,
        deadline: deadline);
  }

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [title, description, done, deadline, tags, assigned, comments];
  }

  /// Returns the data content of the task as a map.
  Map<String, dynamic> toMap() {
    return {
      "taskId": taskId,
      "title": title,
      "description": description,
      "done": done,
      "deadline": deadline,
      "comments": comments.map((e) => e.commentId).toList(),
      "assigned": assigned.map((e) => e.userId).toList(),
      "tags": tags.map((e) => e.tagId)
    };
  }
}
