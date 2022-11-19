import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/user.dart';
import 'package:project/services/user_image_service.dart';

/// Business logic for users.
abstract class UserService {
  /// Returns a future with the added user.
  Future<User?> addUser({
    required String userId,
    required String username,
    required String email,
    String bio = "",
    File? image,
  });

  /// Returns a future with the user with the given [userId].
  Future<User?> getUser(String userId);

  /// Updated the user with the given [UserId], with the given [User].
  Future<void> updateUser(String userId, User user);

  /// Deletes the user with the given [UserId].
  void deleteUser(String userId);
}

/// Firebase implementation of [UserService].
class FirebaseUserService implements UserService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final userImageService = FirebaseUserImageService();

  @override
  Future<User?> addUser({
    required String userId,
    required String username,
    required String email,
    String bio = "",
    File? image,
  }) async {
    String imageUrl = await userImageService.addUserImage(userId, image);

    User user = User(
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
    return User.fromMap((await userCollection.doc(userId).get()).data());
  }

  @override
  Future<void> updateUser(String userId, User user) async {
    await userCollection.doc(userId).set(User.toMap(user));
  }

  @override
  void deleteUser(String userId) {
    userImageService
        .deleteUserImage(userId)
        .then((value) => userCollection.doc(userId).delete());
  }
}
