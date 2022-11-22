import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

/// Business logic for user images.
abstract class UserImageService {
  /// Adds the given [File image] for the user with the given [userId].
  /// Returns a [String] containing link to the added picture.
  Future<String?> addUserImage(String userId, File image);

  /// Updates the image of the user with the given [UserId] with the given
  /// [File image]. Returns the [String] link for the updated image.
  Future<String?> updateUserImage(String userId, File image);

  /// Deletes the user image for the user with the given [UserId].
  Future<void> deleteUserImage(String userId);
}

/// Firebase implementation of [UserImageService].
class FirebaseUserImageService implements UserImageService {
  final Reference userImagesReference =
      FirebaseStorage.instance.ref().child("user_images");

  @override
  Future<String> addUserImage(String userId, File? image) {
    if (image != null) {
      String imageExtension = extension(image.path);
      return userImagesReference
          .child("$userId$imageExtension")
          .putFile(image)
          .then((value) => value.ref.getDownloadURL());
    } else {
      return Future<String>.value(
          "https://firebasestorage.googleapis.com/v0/b/solveit-1337.appspot.com/o/user_images%2Fprofile_placeholder.png?alt=media&token=892934b3-c3ad-48d5-a946-4c153aefbbbe");
    }
  }

  @override
  Future<String> updateUserImage(String userId, File image) async {
    return deleteUserImage(userId).then(
      (value) => addUserImage(userId, image).then((value) => value),
      onError: (error) => print(error),
    );
  }

  @override
  Future<void> deleteUserImage(String userId) {
    return userImagesReference.listAll().then((userImages) {
      for (Reference userImageReference in userImages.items) {
        if (userImageReference.name.contains(userId)) {
          userImageReference.delete();
        }
      }
    }, onError: (error) => print(error));
  }
}
