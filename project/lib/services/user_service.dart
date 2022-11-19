import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project/models/user.dart';

abstract class UserService {
  User? addUser({
    required String userId,
    required String username,
    required String email,
    String bio = "",
    File? image,
  });

  Future<User?> getUser(String userId);

  User? updateUser(String userId, User user);

  User? deleteUser(User user);
}

class FirebaseUserService implements UserService {
  final userCollection = FirebaseFirestore.instance.collection("users");

  @override
  User? addUser({
    required String userId,
    required String username,
    required String email,
    String bio = "",
    File? image,
  }) {
    String imageUrl = "";
    if (image != null) {
      FirebaseStorage.instance
          .ref()
          .child("profile_pictures")
          .child("$userId.jpg")
          .putFile(image)
          .then((value) =>
              value.ref.getDownloadURL().then((value) => imageUrl = value));
    } else {
      FirebaseStorage.instance
          .ref()
          .child("profile_pictures")
          .child("profile_placeholder.png")
          .getDownloadURL()
          .then((value) => imageUrl = value);
    }

    User user = User(
      userId: userId,
      username: username,
      email: email,
      bio: bio,
      imageUrl: imageUrl,
    );

    userCollection.add(User.toMap(user));
    return user;
  }

  @override
  Future<User?> getUser(String userId) async {
    return User.fromMap(
      (await userCollection.where("userId", isEqualTo: userId).get())
          .docs[0]
          .data(),
    );
  }

  @override
  User? updateUser(String userId, User user) {
    Map<String, dynamic>? userMap;
    userCollection.doc(user.userId).set(User.toMap(user)).then((value) =>
        userCollection
            .doc(user.userId)
            .get()
            .then((value) => userMap = value.data()));

    return User.fromMap(userMap);
  }

  @override
  User? deleteUser(User user) {
    userCollection.doc(user.userId).delete();
    return user;
  }
}
