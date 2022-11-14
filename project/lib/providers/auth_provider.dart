import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/auth_service.dart';

/// The Auth Provider
final authProvider = Provider<AuthService>((ref) {
  final AuthService auth = Auth();
  return auth;
});
