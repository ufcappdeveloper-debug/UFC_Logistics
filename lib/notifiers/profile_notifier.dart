import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/models/user_model.dart';
import 'package:ufc_delivery_app/services/profile_service.dart';

class UserState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  UserState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserService userService;

  UserNotifier(this.userService) : super(UserState(isLoading: true));

  Future<void> fetchUserProfile() async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await userService.fetchUserProfile();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch user profile: $e',
      );
    }
  }
}
