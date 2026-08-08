import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/config/dio.dart';
import 'package:ufc_delivery_app/models/user_model.dart';
import 'package:ufc_delivery_app/notifiers/profile_notifier.dart';
import 'package:ufc_delivery_app/services/profile_service.dart';

// Dio Provider
final dioProvider =
    Provider((ref) => api); // Assuming 'api' is your Dio instance

// User Service Provider
final userServiceProvider =
    Provider((ref) => UserService(ref.read(dioProvider)));

// User Notifier Provider
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(ref.read(userServiceProvider)),
);

// Fetch User Profile Provider
final userProfileProvider = FutureProvider<User>((ref) async {
  final userService = ref.read(userServiceProvider);
  return await userService.fetchUserProfile();
});
