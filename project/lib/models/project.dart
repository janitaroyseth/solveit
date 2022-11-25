import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// User id of the owner of this project.
  String? owner;

  /// List of user ids for collaborators on this project.
  List<dynamic> collaborators;

  /// Path to project avatar.s
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
    print(data["collaborators"]);
    final String id = data["projectId"];
    final String title = data['title'];
    final String description = data['description'];
    final collaborators = data["collaborators"];
    final bool isPublic = data['isPublic'];
    final String? lastUpdated = data['lastUpdated'];
    final String imageUrl = data['imageUrl'];

    return Project(
        projectId: id,
        title: title,
        imageUrl: imageUrl,
        description: description,
        collaborators: collaborators,
        isPublic: isPublic,
        lastUpdated: lastUpdated);
  }

  static List<Project> fromMaps(var data) {
    List<Project> projects = [];
    for (var value in data) {
      Project? project = fromMap(value.data());
      if (null != project) {
        projects.add(project);
      }
    }
    return projects;
  }

  Map<String, dynamic> toMap() {
    return {
      "projectId": projectId,
      "title": title,
      "tasks": tasks.map((e) => e.taskId).toList(),
      "tags": tags.map((e) => e.tagId).toList(),
      "collaborators": collaborators,
      "owner": owner,
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
    List<dynamic>? collaborators,
    String? imageUrl,
    this.description = "",
    this.lastUpdated,
    this.isPublic = false,
  })  : imageUrl = imageUrl ?? projectAvatars[0],
        collaborators = collaborators ?? [];
}
