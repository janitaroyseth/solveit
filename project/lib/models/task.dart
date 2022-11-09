import 'package:project/models/tag.dart';

import 'comment.dart';

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

  /// Converts a [Map] object to a [Task] object.
  factory Task.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      //return null;
    }
    final String title = data['title'];
    final String description = data['description'];
    final List<Tag> tags = [];
    if (null != data['tags']) {
      for (Map<String, dynamic> map in data['tags']) {
        tags.add(Tag.fromMap(map));
      }
    }
    final bool done = data['done'];
    final String? deadline = data['deadline'];
    final List<Comment> comments = [];
    if (null != data['comments']) {
      for (Map<String, dynamic> map in data['comments']) {
        comments.add(Comment.fromMap(map));
      }
    }
    return Task(
        title: title,
        description: description,
        tags: tags,
        done: done,
        deadline: deadline,
        comments: comments);
  }

  Task(
      {this.title = "task title",
      this.description = "task description",
      this.tags = const [],
      this.done = false,
      this.deadline,
      this.comments = const []});

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
    return Task(
        title: title,
        description: description,
        tags: tags,
        done: done,
        deadline: deadline,
        comments: comments);
  }

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [title, description, done, deadline, tags];
  }

  /// Returns the data content of the task as a map.
  Map asMap() {
    return {
      "title": title,
      "description": description,
      "tags": tags,
      "done": done,
      "deadline": deadline,
      "comments": comments
    };
  }
}
