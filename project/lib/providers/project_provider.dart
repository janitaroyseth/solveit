import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/project_service.dart';

final userProvider = Provider<ProjectService>((ref) {
  final ProjectService projectService = FirebaseProjectService();
  return projectService;
});
