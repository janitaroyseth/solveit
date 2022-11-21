import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/user_service.dart';

// This will provide a stream with a User? object - the authenticated user
final userAuthProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userProvider = Provider<UserService>((ref) {
  final UserService userService = FirebaseUserService();
  return userService;
});
