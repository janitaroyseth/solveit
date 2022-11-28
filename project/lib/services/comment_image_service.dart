import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Business logic for comment images.
abstract class CommentImageService {
  /// Adds the given image to a folder for the given task id, returns a future
  /// containing the url for the image added.
  Future<String?> addCommentImage(String taskId, File image);

  /// Deletes the comment image from the folder of the given task id and with
  /// the given comment url
  Future<void> deleteCommentImage(String taskId, String commentUrl);
}

/// Firebase implementation of comment image service.
class FirebaseCommentImageService implements CommentImageService {
  final Reference commentImagesReference =
      FirebaseStorage.instance.ref().child("comment_images");

  @override
  Future<String?> addCommentImage(String taskId, File image) {
    String imageName = image.path.split("/").last;
    return commentImagesReference
        .child(taskId)
        .child(imageName)
        .putFile(image)
        .then((value) => value.ref.getDownloadURL());
  }

  @override
  Future<void> deleteCommentImage(String taskId, String commentUrl) {
    return commentImagesReference.child(taskId).listAll().then(
          (value) => value.items.forEach(
            (element) {
              element.getDownloadURL().then((value) {
                if (value == commentUrl) {
                  element.delete();
                }
              });
            },
          ),
        );
  }
}
