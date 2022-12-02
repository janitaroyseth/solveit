import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/chat_image_service.dart';

/// Provider for chat image service.
final chatImageProvider = Provider<ChatImageService>((ref) {
  final ChatImageService chatImageService = FirebaseChatImageService();
  return chatImageService;
});
