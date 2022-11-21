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
  User owner;

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
    final List<Task> tasks = [];
    for (Map<String, dynamic> map in data['tasks']) {
      Task? task = Task.fromMap(map);
      if (task != null) tasks.add(task);
    }
    final List<Tag> tags = [];
    for (Map<String, dynamic> map in data['tags']) {
      Tag? tag = Tag.fromMap(map);
      if (tag != null) tags.add(tag);
    }
    final User owner = data["owner"];
    final String imageUrl = data['imageUrl'];
    final String description = data['description'];
    final bool isPublic = data['isPublic'];
    final String? lastUpdated = data['lastUpdated'];
    return Project(
        projectId: id,
        title: title,
        tasks: tasks,
        tags: tags,
        owner: owner,
        imageUrl: imageUrl,
        description: description,
        isPublic: isPublic,
        lastUpdated: lastUpdated);
  }

  static Map<String, dynamic> toMap(Project project) {
    var tasks = [];
    for (Task task in project.tasks) {
      tasks.add(task.toMap());
    }
    var tags = [];
    for (Tag tag in project.tags) {
      tags.add(tag.toMap());
    }
    return {
      "projectId": project.projectId,
      "title": project.title,
      "tasks": tasks,
      "tags": tags,
      "owner": project.owner,
      "imageUrl": project.imageUrl,
      "description": project.description,
      "isPublic": project.isPublic,
      "lastUpdated": project.lastUpdated
    };
  }

  /// Creates an instance of [Project],
  Project({
    this.projectId = "0",
    this.title = "project title",
    this.tasks = const [],
    this.tags = const [],
    required this.owner,
    List<User>? collaborators,
    String? imageUrl,
    this.description = "",
    this.lastUpdated,
    this.isPublic = false,
  })  : imageUrl = imageUrl ?? projectAvatars[0],
        collaborators = collaborators ?? [];
}
