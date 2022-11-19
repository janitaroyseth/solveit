import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project/models/user.dart';

abstract class UserService {
  Future<User?> addUser({
    required String userId,
    required String username,
    required String email,
    String bio = "",
    File? image,
  });

  Future<User?> getUser(String userId);

  Future<void> updateUser(String userId, User user);

  User? deleteUser(User user);

  Future<String> addProfilePictre(String userId, File image);
}

class FirebaseUserService implements UserService {
  final userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<User?> addUser({
    required String userId,
    required String username,
    required String email,
    String bio = "",
    File? image,
  }) async {
    String imageUrl = "";

    if (image != null) {
      imageUrl = await (await FirebaseStorage.instance
              .ref()
              .child("profile_pictures")
              .child("$userId.jpg")
              .putFile(image))
          .ref
          .getDownloadURL();
    } else {
      imageUrl = await FirebaseStorage.instance
          .ref()
          .child("profile_pictures")
          .child("profile_placeholder.png")
          .getDownloadURL();
    }

    User user = User(
      userId: userId,
      username: username,
      email: email,
      bio: bio,
      imageUrl: imageUrl,
    );

    userCollection.doc(userId).set(User.toMap(user));
    return user;
  }

  @override
  Future<User?> getUser(String userId) async {
    return User.fromMap((await userCollection.doc(userId).get())
        .data()); /* where("userId", isEqualTo: userId).get())
          .docs[0]
          .data(),
    ); */
  }

  @override
  Future<void> updateUser(String userId, User user) async {
    // String documentId =
    //     (await userCollection.where("userId", isEqualTo: userId).get())
    //         .docs
    //         .first
    //         .id;
    await userCollection.doc(userId).set(User.toMap(user));
  }

  @override
  User? deleteUser(User user) {
    userCollection.doc(user.userId).delete();
    return user;
  }

  @override
  Future<String> addProfilePictre(String userId, File image) async {
    String imageUrl;

    imageUrl = await (await FirebaseStorage.instance
            .ref()
            .child("profile_pictures")
            .child("$userId.jpg")
            .putFile(image))
        .ref
        .getDownloadURL();

    return imageUrl;
  }
}
