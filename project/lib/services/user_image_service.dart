import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

abstract class UserImageService {
  Future<String> addUserImage(String userId, File image);

  Future<String> getUserImage(String userId);

  Future<String> updateUserImage(String userId, File image);

  Future<void> deleteUserImage(String userId);
}

class FirebaseUserImageService implements UserImageService {
  final Reference userImagesReference =
      FirebaseStorage.instance.ref().child("user_images");

  @override
  Future<String> addUserImage(String userId, File? image) {
    if (image != null) {
      String imageExtension = extension(image.path);
      return FirebaseStorage.instance
          .ref()
          .child("profile_pictures")
          .child("$userId$imageExtension")
          .putFile(image)
          .then((value) => value.ref.getDownloadURL());
    } else {
      return FirebaseStorage.instance
          .ref()
          .child("profile_pictures")
          .child("profile_placeholder.png")
          .getDownloadURL();
    }
  }

  @override
  Future<String> getUserImage(String userId) {
    userImagesReference.listAll().then((userImages) {
      for (Reference userImageReference in userImages.items) {
        if (userImageReference.name.contains(userId)) {
          return userImageReference.getDownloadURL();
        }
      }
    }, onError: (error) => print(error));

    return Future<String>.error("no image found");
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
