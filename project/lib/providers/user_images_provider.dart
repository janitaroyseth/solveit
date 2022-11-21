import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/user_image_service.dart';

final userImageProvider = Provider<UserImageService>((ref) {
  final UserImageService userImageService = FirebaseUserImageService();
  return userImageService;
});
