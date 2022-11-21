import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/project.dart';

/// Business logic for projects.
abstract class ProjectService {
  /// Returns a future with the added project.
  //Future<Project> addProject(Project project);

  /// Returns a future with the project with the given project id.
  Future<Project> getProject(String projectId);

  // Returns a future with the list of projects belonging to the given user.
  Future<List<Project>> getProjectsByUserId(String userId);

  /// Updates the project with the given project id.
  Future<void> updateProject(String projectId, Project project);

  /// Deletes the project with the given project id.
  void deleteProject(String projectId);
}

/// Firebase implementation of [ProjectService].
class FirebaseProjectService implements ProjectService {
  final projectCollection = FirebaseFirestore.instance.collection("projects");

  // @override
  // Future<Project> addProject(Project project) {
  //   dynamic id = projectCollection.add(Project.toMap());
  // }

  @override
  void deleteProject(String projectId) {
    // TODO: implement deleteProject
  }

  @override
  Future<Project> getProject(String projectId) {
    // TODO: implement getProject
    throw UnimplementedError();
  }

  @override
  Future<List<Project>> getProjectsByUserId(String userId) {
    // TODO: implement getProjectsByUserId
    throw UnimplementedError();
  }

  @override
  Future<void> updateProject(String projectId, Project project) {
    // TODO: implement updateProject
    throw UnimplementedError();
  }
}
