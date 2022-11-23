import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project.dart';
import 'package:project/services/project_service.dart';

final projectProvider = Provider<ProjectService>((ref) {
  final ProjectService projectService = FirebaseProjectService();
  return projectService;
});

final currentProjectProvider =
    StateNotifierProvider<CurrentProjectNotifier, Project>((ref) {
  return CurrentProjectNotifier();
});

class CurrentProjectNotifier extends StateNotifier<Project> {
  CurrentProjectNotifier() : super(Project());

  void setProject(Project project) {
    state = project;
  }
}
