import 'package:project/models/comment.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/user.dart';

/// Represents a task in a project.
class Task {
  // The name of the task.
  String title;
  // The description of the task.
  String description;
  // The list of tags belonging to the task.
  List<Tag> tags;
  // Whether or not the task has been completed.
  bool done;
  // The (optional) deadline of the task.
  String? deadline;
  // List of comments of this task.
  List<Comment> comments;

  List<User> assigned;

  Task({
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
    final String title = data['title'];
    final String description = data['description'];
    final List<Tag> tags = [];
    if (null != data['tags']) {
      for (Map<String, dynamic> map in data['tags']) {
        Tag? tag = Tag.fromMap(map);
        if (tag != null) tags.add(tag);
      }
    }
    final bool done = data['done'];
    final String? deadline = data['deadline'];
    final List<Comment> comments = [];
    if (null != data['comments']) {
      for (Map<String, dynamic> map in data['comments']) {
        Comment? comment = Comment.fromMap(map);
        if (comment != null) comments.add(comment);
      }
    }
    final List<User> assigned = [];
    if (data["assigned"] != null) {
      for (Map<String, dynamic> map in data["assigned"]) {
        User? user = User.fromMap(map);
        if (user != null) assigned.add(user);
      }
    }
    return Task(
      title: title,
      description: description,
      tags: tags,
      done: done,
      deadline: deadline,
      comments: comments,
      assigned: assigned,
    );
  }

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [title, description, done, deadline, tags, assigned, comments];
  }

  /// Returns the data content of the task as a map.
  Map toMap() {
    return {
      "title": title,
      "description": description,
      "tags": tags,
      "done": done,
      "deadline": deadline,
      "comments": comments,
      "assigned": assigned,
    };
  }
}
