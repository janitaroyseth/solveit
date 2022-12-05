import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/tag.dart';

/// Represents a task in a project.
class Task {
  /// The id of the task.
  String taskId;

  /// The id of the project this task belongs to.
  String projectId;

  /// The name of the task.
  String title;

  /// The description of the task.
  String description;

  /// The list of tags belonging to the task.
  List<Tag> tags;

  /// Whether or not the task has been completed.
  bool done;

  /// The (optional) deadline of the task.
  DateTime? deadline;

  /// List of the users assigned ot this task.
  List<String> assigned;

  /// Who the task was last updated by.
  String? updatedBy;

  /// Creates a new instance of task.
  Task({
    this.taskId = "",
    this.projectId = "",
    this.title = "",
    this.description = "",
    List<Tag>? tags,
    this.done = false,
    this.deadline,
    List<String>? assigned,
    this.updatedBy,
  })  : assigned = assigned ?? [],
        tags = tags ?? [];

  /// Converts a [Map] object to a [Task] object.
  static Task? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String? taskId = data["taskId"];
    final String? projectId = data["projectId"];
    final String? title = data['title'];
    final String? description = data['description'] ?? "";
    final bool? done = data['done'] ?? false;
    final DateTime? deadline = data['deadline'] != null
        ? (data['deadline'] as Timestamp).toDate()
        : null;

    final List<String>? assigned =
        data["assigned"] != null ? data["assigned"].cast<String>() : [];
    final tags = data["tags"] != null ? Tag.fromMaps(data["tags"]) : <Tag>[];

    if (taskId == null || projectId == null || title == null) return null;

    final updatedBy = data["updatedBy"];
    return Task(
      taskId: taskId,
      projectId: projectId,
      title: title,
      description: description!,
      done: done!,
      deadline: deadline,
      assigned: assigned,
      tags: tags,
      updatedBy: updatedBy,
    );
  }

  static List<Task> fromMaps(var data) {
    List<Task> tasks = [];
    for (var value in data) {
      Task? task = fromMap(value.data());
      if (null != task) {
        tasks.add(task);
      }
    }
    return tasks;
  }

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [
      title,
      projectId,
      description,
      done,
      deadline,
      tags,
      assigned,
    ];
  }

  /// Returns the data content of the task as a map.
  Map<String, dynamic> toMap() {
    return {
      "taskId": taskId,
      "projectId": projectId,
      "title": title,
      "description": description,
      "done": done,
      "deadline": deadline,
      "assigned": assigned,
      "tags": tags.map((e) => e.toMap()).toList(),
      "updatedBy": updatedBy,
    };
  }

  @override
  int get hashCode => taskId.hashCode + projectId.hashCode;

  @override
  bool operator ==(Object other) {
    return taskId == (other as Task).taskId && projectId == other.projectId;
  }
}
