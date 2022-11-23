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
          .child(userId)
          .child("$userId$imageExtension")
          .putFile(image)
          .then((value) => value.ref.getDownloadURL());
    } else {
      return Future<String>.value(
          "https://firebasestorage.googleapis.com/v0/b/solveit-1337.appspot.com/o/user_images%2Fprofile_placeholder.png?alt=media&token=d1167324-93a9-4515-8341-21d27abd3d24");
    }
  }

  @override
  Future<String> updateUserImage(String userId, File image) async {
    await deleteUserImage(userId);
    return await addUserImage(userId, image);
  }

  @override
  Future<void> deleteUserImage(String userId) {
    return userImagesReference
        .child(userId)
        .listAll()
        .then((value) => value.items.first.delete());
  }
}
