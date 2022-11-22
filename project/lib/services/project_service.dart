import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:project/models/user.dart';
import 'package:project/services/tag_service.dart';
import 'package:project/services/task_service.dart';
import 'package:project/services/user_service.dart';

/// Business logic for projects.
abstract class ProjectService {
  /// Saves a new or updates an existing project.
  /// Returns a future with the added or updated project.
  Future<Project> saveProject(Project project);

  /// Returns a future with the project with the given project id.
  Future<Project?> getProject(String projectId);

  // Returns a future with the list of projects belonging to the given user.
  Future<List<Project>> getProjectsByUserId(String userId);

  /// Deletes the project with the given project id.
  void deleteProject(String projectId);
}

/// Firebase implementation of [ProjectService].
class FirebaseProjectService implements ProjectService {
  final projectCollection = FirebaseFirestore.instance.collection("projects");
  final taskService = FirebaseTaskService();
  final userService = FirebaseUserService();
  final tagService = FirebaseTagService();

  @override
  Future<Project> saveProject(Project project) async {
    if (project.projectId == "") {
      project.projectId = (await projectCollection.add(project.toMap())).id;
    } else {
      await projectCollection.doc(project.projectId).set(project.toMap());
    }
    return project;
  }

  @override
  void deleteProject(String projectId) async {
    Map<String, dynamic>? map =
        (await projectCollection.doc(projectId).get()).data();
    if (null != map) {
      for (String taskId in map["tasks"]) {
        taskService.deleteTask(taskId);
      }
    }
    projectCollection.doc(projectId).delete();
  }

  @override
  Future<Project?> getProject(String projectId) async {
    // Fetch and convert the project info
    Map<String, dynamic>? map =
        (await projectCollection.doc(projectId).get()).data();
    Project? project = Project.fromMap(map);
    if (null != map && null != project) {
      // Fetch and add the tasks
      for (String taskId in map["tasks"]) {
        Task? task = await taskService.getTask(taskId);
        if (null != task) {
          project.tasks.add(task);
        }
      }

      // Fetch and add the collaborators
      for (String userId in map["collaborators"]) {
        User? user = await userService.getUser(userId);
        if (null != user) {
          project.collaborators.add(user);
        }
      }

      // Fetch and add the tags
      for (String tagId in map["tags"]) {
        Tag? tag = await tagService.getTag(tagId);
        if (null != tag) {
          project.tags.add(tag);
        }
      }
    }
    return project;
  }

  @override
  Future<List<Project>> getProjectsByUserId(String userId) async {
    List<Project> projects = [];
    for (var doc in (await projectCollection.get()).docs) {
      List<String> collaborators = doc.data()["collaborators"];
      if (collaborators.contains(userId)) {
        Project? project = await getProject(doc.id);
        if (null != project) {
          projects.add(project);
        }
      }
    }
    return projects;
  }
}
