import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xor_cipher/xor_cipher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a message.
abstract class Message {
  // The id of the message.
  String messageId;

  /// The id of a foreign entity to connect to.
  String otherId;

  // The user id of the author of this message.
  String author;

  // The date on which the message was made.
  DateTime date;

  static String encryptionKey = "${dotenv.env["MESSAGE_ENCRYPTION_KEY"]}";

  /// Creates an instce of [Message].
  Message({
    this.messageId = "",
    required this.otherId,
    required this.author,
    required DateTime? date,
  }) : date = date ?? DateTime.now();

  /// Converts a [Map] object to a [Message] object.
  static Message? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String messageId = data["messageId"];
    final String otherId = data["otherId"];
    final String author = data["author"];
    final DateTime date = (data['date'] as Timestamp).toDate();
    final String? imageUrl = data['imageUrl'];
    final String? text = data['text'];

    if (imageUrl != null) {
      return ImageMessage(
          messageId: messageId,
          otherId: otherId,
          author: author,
          date: date,
          imageUrl: imageUrl);
    } else if (text != null) {
      return TextMessage(
          messageId: messageId,
          otherId: otherId,
          author: author,
          date: date,
          text: XOR.decrypt(text, encryptionKey, urlDecode: true));
    } else {
      return null;
    }
  }

  /// Converts given data of [List<QueryDocumentSnapshot<Map<String, dynamic>>>]
  /// to a list of messages.
  static List<Message> fromMaps(var data) {
    List<Message> comments = [];

    for (var value in data) {
      if (data is List<Map<String, dynamic>>) {
        Message? comment = fromMap(value);
        if (comment != null) {
          comments.add(comment);
        }
      } else {
        Message? comment = fromMap(value.data());
        if (comment != null) {
          comments.add(comment);
        }
      }
    }
    return comments;
  }

  /// Converts given [Message] to a [Map<String, dynamic>].
  static Map<String, dynamic> toMap(Message message) {
    Map<String, dynamic> map = {
      "messageId": message.messageId,
      "otherId": message.otherId,
      "author": message.author,
      "date": message.date,
    };

    if (message is TextMessage) {
      map["text"] = XOR.encrypt(message.text, encryptionKey, urlEncode: true);
    } else if (message is ImageMessage) {
      map["imageUrl"] = message.imageUrl;
    }

    return map;
  }

  @override
  int get hashCode => messageId.hashCode + otherId.hashCode + author.hashCode;

  @override
  bool operator ==(Object other) {
    return messageId == (other as Message).messageId &&
        author == other.author &&
        otherId == other.otherId;
  }
}

/// Message where the content is a [imageUrl].
class ImageMessage extends Message {
  /// The image url of the message.
  String imageUrl;

  /// Creates an instance of [ImageMessage], a message where the content
  /// is [imageUrl].
  ImageMessage({
    super.messageId = "",
    super.date,
    required super.otherId,
    required super.author,
    required this.imageUrl,
  });

  /// Creates an instance of [ImageMessage] from the given [Map].
  static ImageMessage? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String messageId = data["messageId"];
    final String otherId = data["otherId"];
    final String author = data["author"];
    final DateTime date = (data["date"] as Timestamp).toDate();
    final String imageUrl = data["imageUrl"];

    return ImageMessage(
      messageId: messageId,
      otherId: otherId,
      author: author,
      date: date,
      imageUrl: imageUrl,
    );
  }
}

/// Message where the content is a [String].
class TextMessage extends Message {
  /// The text content (body) of the message.
  String text;

  /// Creates an instant of [TextMessage], a message where the content
  /// is a [String].
  TextMessage({
    super.messageId = "",
    super.date,
    required super.otherId,
    required super.author,
    required this.text,
  });
  static String encryptionKey = "${dotenv.env["MESSAGE_ENCRYPTION_KEY"]}";

  /// Creates an instance of [TextMessage] from the given [Map].
  static TextMessage? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final String messageId = data["messageId"];
    final String otherId = data["otherId"];
    final String author = data["author"];
    final DateTime date = (data["date"] as Timestamp).toDate();
    final String text = data["text"];

    return TextMessage(
      messageId: messageId,
      otherId: otherId,
      author: author,
      date: date,
      text: XOR.decrypt(text, encryptionKey),
    );
  }
}
