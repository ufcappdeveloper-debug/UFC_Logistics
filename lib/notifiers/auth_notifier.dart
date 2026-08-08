import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_delivery_app/models/user_model.dart';
import 'package:ufc_delivery_app/services/auth_service.dart';

enum AuthErrorType { sendOtp, verifyOtp, resendOtp, none }

class AuthState {
  final bool isLoading;
  final bool isOtpSent;
  final bool isAuthenticated;
  final AuthErrorType errorType;
  final String? errorMessage;
  final User? user;
  final UserAutoLogin? autoLoginUser;

  AuthState({
    this.isLoading = false,
    this.isOtpSent = false,
    this.isAuthenticated = false,
    this.errorType = AuthErrorType.none,
    this.errorMessage,
    this.user,
    this.autoLoginUser,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isOtpSent,
    bool? isAuthenticated,
    AuthErrorType? errorType,
    String? errorMessage,
    User? user,
    UserAutoLogin? autoLoginUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorType: errorType ?? this.errorType,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      autoLoginUser: autoLoginUser ?? this.autoLoginUser,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  AuthNotifier(this.authService) : super(AuthState());

  Future<String> requestOtp(String phoneNumber) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, errorType: AuthErrorType.none);
    try {
      final response = await authService.requestOtp(phoneNumber);
      if (response['status'] == 'success') {
        state = state.copyWith(isOtpSent: true, isLoading: false);
        final message = response['data']['message'];

        return message;
      } else {
        state = state.copyWith(
            isOtpSent: false,
            isLoading: false,
            errorType: AuthErrorType.sendOtp);
        return "Failed to send OTP";
      }
    } on DioException catch (e) {
      state = state.copyWith(
          isOtpSent: false, isLoading: false, errorType: AuthErrorType.sendOtp);
      return e.error?.toString() ?? "An error occurred while sending OTP ";
    } catch (e) {
      state = state.copyWith(
          isOtpSent: false, isLoading: false, errorType: AuthErrorType.sendOtp);
      Sentry.captureException(e);
      return "An error occurred while sending OTP ";
    }
  }

  Future<String> resendOtp(String phoneNumber) async {
    state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        isOtpSent: true,
        errorType: AuthErrorType.none);

    try {
      // Request a new OTP from the auth service
      final response = await authService.requestOtp(phoneNumber);

      if (response['status'] == 'success') {
        // Keep isOtpSent true to ensure the OTP input UI remains visible
        state = state.copyWith(isOtpSent: true, isLoading: false);

        final message = response['data']['message'];
        return message;
      } else {
        // Even on failure, ensure isOtpSent remains true for UI purposes
        state = state.copyWith(
            isOtpSent: true,
            isLoading: false,
            errorType: AuthErrorType.resendOtp);
        return "Failed to resend OTP";
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            e.error?.toString() ?? "An error occurred while resending OTP",
        errorType: AuthErrorType.verifyOtp,
      );
      return e.error?.toString() ?? "An error occurred while resending OTP";
    } catch (e) {
      // Handle exceptions and ensure isOtpSent remains true
      state = state.copyWith(
          isOtpSent: true,
          isLoading: false,
          errorType: AuthErrorType.resendOtp);
      return "An error occurred while resending OTP";
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(
        isLoading: true, errorMessage: '', errorType: AuthErrorType.none);
    try {
      final response = await authService.verifyOtp(phoneNumber, otp);

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        errorMessage: '',
        user: response,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            e.error?.toString() ?? "An error occurred while verifying OTP",
        errorType: AuthErrorType.verifyOtp,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        errorType: AuthErrorType.verifyOtp,
      );
    }
  }

  Future<void> autoLogin() async {
    // state = state.copyWith(isLoading: true);
    try {
      // Check if the user has a saved token or session info
      final token = await authService
          .getSavedToken(); // Example: Retrieve token from shared preferences or secure storage
      if (token != null) {
        final userResponse = await authService
            .getUserInfo(); // Example: API call to check if the user is still valid
        if (userResponse['status'] == 'success') {
          final user = UserAutoLogin.fromJson(userResponse['data']);
          state = state.copyWith(
              isAuthenticated: true, isLoading: false, autoLoginUser: user);
        } else {
          state = state.copyWith(isAuthenticated: false, isLoading: false);
        }
      } else {
        state = state.copyWith(isAuthenticated: false, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isAuthenticated: false, isLoading: false);
      print("Error during auto-login: $e");
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Call the logout API through the AuthService
      await authService.logout();

      // Update the state to reflect that the user is logged out
      state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
          user: null,
          isOtpSent: false);
    } catch (e) {
      state =
          state.copyWith(isLoading: false, errorMessage: 'Logout failed: $e');
      print("Error during logout: $e");
    }
  }

  Future<void> restToSendOtp() async {
    state = state.copyWith(isOtpSent: false);
  }
}
