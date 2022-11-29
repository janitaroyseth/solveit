import 'dart:io';
import 'dart:math';

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
  Stream<User?> getUser(String userId);

  Stream<List<User?>> getUsers();

  Stream<List<User?>> searchUsers(String query);

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
  Stream<User?> getUser(String userId) {
    return userCollection
        .doc(userId)
        .snapshots()
        .map((event) => event.data())
        .map((event) => User.fromMap(event));
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

  @override
  Stream<List<User?>> getUsers() {
    return userCollection
        .snapshots()
        .map((event) => event.docs)
        .map((event) => User.fromMaps(event));
  }

  @override
  Stream<List<User?>> searchUsers(String query) {
    return userCollection.snapshots().map((event) => event.docs).map((event) {
      List<User?> users = [];
      if (query.isEmpty) {
        for (var element in event) {
          users.add(User.fromMap(element.data()));
        }
      } else {
        for (var element in event) {
          User? user = User.fromMap(element.data());
          if (user!.username.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase())) {
            users.add(user);
          }
        }
      }
      return users;
    });
  }
}
