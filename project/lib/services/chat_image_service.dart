import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Business logic for chat images.
abstract class ChatImageService {
  /// Adds the given image to a folder for the given other id, returns a future
  /// containing the url for the image added.
  Future<String?> addChatImage(String otherId, File image);

  /// Deletes the chat image from the folder of the given other id and with
  /// the given chat url
  Future<void> deleteChatImage(String otherId, String chatUrl);
}

/// Firebase implementation of chat image service.
class FirebaseChatImageService implements ChatImageService {
  final Reference chatImagesReference =
      FirebaseStorage.instance.ref().child("chat_images");

  @override
  Future<String?> addChatImage(String otherId, File image) {
    String imageName = image.path.split("/").last;
    return chatImagesReference
        .child(otherId)
        .child(imageName)
        .putFile(image)
        .then((value) => value.ref.getDownloadURL());
  }

  @override
  Future<void> deleteChatImage(String otherId, String chatUrl) {
    return chatImagesReference.child(otherId).listAll().then((value) {
      for (var element in value.items) {
        element.getDownloadURL().then((value) {
          if (value == chatUrl) {
            element.delete();
          }
        });
      }
    });
  }
}
