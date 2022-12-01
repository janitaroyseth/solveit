import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/chat_service.dart';

final chatProvider = Provider<ChatService>((ref) {
  final ChatService chatService = FirebaseChatService();
  return chatService;
});
