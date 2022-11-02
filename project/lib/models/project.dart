import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';

/// The data content of a project in the application.
class Project {
  // The name of the project.
  String title;

  // The list of tasks in the project.
  List<Task> tasks;

  // The list of tags in the project.
  List<Tag> tags;

  /// Path to project avatar.
  String imageUrl;

  /// Description of the project.
  String description;

  /// Whether the project is public or not.
  bool isPublic;

  /// When the project was last updated.
  String? lastUpdated;

  /// Creates an instance of [Project],
  Project({
    this.title = "project title",
    this.tasks = const [],
    this.tags = const [],
    this.imageUrl = "",
    this.description = "",
    this.lastUpdated,
    this.isPublic = false,
  });
}
