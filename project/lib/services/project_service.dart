import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/tag_service.dart';
import 'package:project/services/task_service.dart';
import 'package:project/services/user_service.dart';
import 'dart:async';

import 'package:rxdart/rxdart.dart';

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

  Stream<List<Project?>>? searchProjects(String query);
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
        .where("collaborators", arrayContains: Auth().currentUser!.uid)
        .snapshots()
        .map((event) => event.docs)
        .map((event) => Project.fromMaps(event).where((element) {
              for (var user in element.collaborators) {
                if (user == userId) {
                  return true;
                }
              }
              return false;
            }).toList());
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
          taskService.deleteTask(projectId, task.taskId);
        }
      }
    }).whenComplete(() => projectCollection.doc(projectId).delete());
  }

  @override
  Stream<List<Project?>>? searchProjects(String query) {
    List<Project?> projects = [];

    final collaborators = projectCollection
        .where("collaborators", arrayContains: Auth().currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((snapshotList) {
      List<Project> collaboratorsList = [];
      if (query.isEmpty) {
        for (var snapshot in snapshotList) {
          Project project = Project.fromMap(snapshot.data())!;
          projects.add(project);
          collaboratorsList.add(project);
        }
      } else {
        for (var snapshot in snapshotList) {
          Project? project = Project.fromMap(snapshot.data());
          if (project!.title.contains(query)) {
            projects.add(project);
            collaboratorsList.add(project);
          }
        }
      }
      return collaboratorsList;
    });

    final public = projectCollection
        .where("isPublic", isEqualTo: true)
        .snapshots()
        .map((event) => event.docs)
        .map((list) {
      List<Project> publicProjects = [];
      for (var element in list) {
        Project project = Project.fromMap(element.data())!;
        if ((project.title.toLowerCase().contains(query.toLowerCase()) ||
                query.isEmpty) &&
            !projects.contains(project)) {
          publicProjects.add(project);
          projects.add(project);
        }
      }

      return publicProjects;
    });

    return CombineLatestStream([collaborators, public], (values) => projects);
  }
}
