import 'package:solveit/models/tag.dart';

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

  Task(
      {this.title = "task title",
      this.description = "task description",
      this.tags = const [],
      this.done = false,
      this.deadline,
      this.comments = const []});

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
