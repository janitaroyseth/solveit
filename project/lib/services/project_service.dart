import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/services/tag_service.dart';
import 'package:project/services/task_service.dart';
import 'package:project/services/user_service.dart';

/// Business logic for projects.
abstract class ProjectService {
  /// Saves a new or updates an existing project.
  /// Returns a future with the added or updated project.
  Future<Project> saveProject(Project project);

  /// Returns a stream with the project with the given project id.
  Stream<Project?> getProject(String projectId);

  /// Returns a list of projects the user with the given user id is a collaborator
  /// on as a stream.
  Stream<List<Project>> getProjectsByUserIdAsCollaborator(String userId);

  /// Returns a list of projects the user with the given user id is a owner of
  /// as a stream.
  Stream<List<Project>> getProjectsByUserIdAsOwner(String userId);

  /// Deletes the project with the given project id.
  Future<void> deleteProject(String projectId);
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
      project.tags = await tagService.getTags();
      project.projectId = (await projectCollection.add(project.toMap())).id;
      await projectCollection.doc(project.projectId).set(project.toMap());
    } else {
      await projectCollection.doc(project.projectId).set(project.toMap());
    }
    return project;
  }

  @override
  Stream<Project?> getProject(String projectId) {
    return projectCollection.doc(projectId).snapshots().map(
          (event) => Project.fromMap(
            event.data(),
          ),
        );
  }

  @override
  Stream<List<Project>> getProjectsByUserIdAsCollaborator(String userId) {
    return projectCollection
        .where("collaborators", arrayContains: userId)
        .snapshots()
        .map((event) => event.docs)
        .map((event) => Project.fromMaps(event));
  }

  @override
  Stream<List<Project>> getProjectsByUserIdAsOwner(String userId) {
    return projectCollection
        .where("owner", isEqualTo: userId)
        .snapshots()
        .map((event) => event.docs)
        .map((event) => Project.fromMaps(event));
  }

  @override
  Future<void> deleteProject(String projectId) async {
    taskService.getTasks(projectId).first.then((tasks) {
      for (Task? task in tasks) {
        if (task != null) {
          taskService.deleteTask(task.taskId);
        }
      }
    }).whenComplete(() => projectCollection.doc(projectId).delete());
  }
}
