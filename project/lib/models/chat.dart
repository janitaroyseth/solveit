import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? chatId;

  String content;

  String author;
  DateTime createdAt;

  Chat(
      {this.chatId,
      required this.content,
      required this.author,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
      "author": author,
      "content": content,
      "createdAt": createdAt,
    };
  }

  static Chat fromMap(var data) {
    final chatId = data["chatId"];
    final author = data["author"];
    final content = data["content"];
    final createdAt = data["createdAt"] != null
        ? (data["createdAt"] as Timestamp).toDate()
        : null;

    return Chat(
      chatId: chatId,
      author: author,
      content: content,
      createdAt: createdAt,
    );
  }

  static List<Chat> fromMaps(var data) {
    List<Chat> chats = [];
    for (var value in data) {
      Chat? chat = fromMap(value.data());
      if (chat != null) {
        chats.add(chat);
      }
    }
    return chats;
  }
}
