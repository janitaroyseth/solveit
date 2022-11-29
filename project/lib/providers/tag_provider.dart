import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/tag_service.dart';

final tagProvider = Provider<TagService>((ref) {
  final TagService tagService = FirebaseTagService();
  return tagService;
});
