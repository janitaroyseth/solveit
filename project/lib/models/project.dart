import 'package:project/data/project_avatar_options.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:project/models/user.dart';

/// The data content of a project in the application.
class Project {
  // The id of the project.
  String projectId;

  // The name of the project.
  String title;

  // The list of tasks in the project.
  List<Task> tasks;

  // The list of tags in the project.
  List<Tag> tags;

  /// Owner of this project.
  User? owner;

  /// List of collaborators on this project.
  List<User> collaborators;

  /// Path to project avatar.
  String imageUrl;

  /// Description of the project.
  String description;

  /// Whether the project is public or not.
  bool isPublic;

  /// When the project was last updated.
  String? lastUpdated;

  /// Converts a [Map] object to a [Project] object.
  static Project? fromMap(Map<String, dynamic>? data) {
    if (null == data) {
      return null;
    }
    final String id = data["projectId"];
    final String title = data['title'];
    final String description = data['description'];
    final bool isPublic = data['isPublic'];
    final String? lastUpdated = data['lastUpdated'];
    final String imageUrl = data['imageUrl'];

    // final List<Task> tasks = [];
    // final List<Tag> tags = [];
    // final User owner = data["owner"];

    // for (Map<String, dynamic> map in data['tasks']) {
    //   Task? task = Task.fromMap(map);
    //   if (task != null) tasks.add(task);
    // }

    // for (Map<String, dynamic> map in data['tags']) {
    //   Tag? tag = Tag.fromMap(map);
    //   if (tag != null) tags.add(tag);
    // }

    return Project(
        projectId: id,
        title: title,
        imageUrl: imageUrl,
        description: description,
        isPublic: isPublic,
        lastUpdated: lastUpdated);
  }

  Map<String, dynamic> toMap() {
    return {
      "projectId": projectId,
      "title": title,
      "tasks": tasks.map((e) => e.taskId).toList(),
      "tags": tags.map((e) => e.tagId).toList(),
      "owner": owner!.userId,
      "imageUrl": imageUrl,
      "description": description,
      "isPublic": isPublic,
      "lastUpdated": lastUpdated
    };
  }

  /// Creates an instance of [Project],
  Project({
    this.projectId = "",
    this.title = "project title",
    this.tasks = const [],
    this.tags = const [],
    this.owner,
    this.collaborators = const [],
    String? imageUrl,
    this.description = "",
    this.lastUpdated,
    this.isPublic = false,
  }) : imageUrl = imageUrl ?? projectAvatars[0];
}
