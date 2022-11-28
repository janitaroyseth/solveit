import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/comment_image_service.dart';

final commentImageProvider = Provider<CommentImageService>((ref) {
  final CommentImageService commentImageService = FirebaseCommentImageService();
  return commentImageService;
});
