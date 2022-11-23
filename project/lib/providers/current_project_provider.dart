import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project.dart';

final currentProjectProvider = Provider<Project>((ref) {
  return Project();
});
