import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/comment_service.dart';

final commentProvider = Provider<CommentService>((ref) {
  final CommentService commentService = FirebaseCommentService();
  return commentService;
});
