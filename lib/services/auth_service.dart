import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufc_delivery_app/models/user_model.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Map<String, dynamic>> requestOtp(String phoneNumber) async {
    final data = {
      "phone_number": phoneNumber,
    };

    final response =
        await dio.post('/api/ufc-logistics/v1/driver/send-otp', data: data);
    return response.data;
  }

  // Future<void> verifyOtp(String phoneNumber, String otp) async {
  //   final data = {
  //     "phone_number": phoneNumber,
  //     "otp": otp,
  //   };

  //   final response = await dio.post('/api/ufc-logistics/v1/driver/verify-otp', data: data);
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to verify OTP');
  //   }
  // }

  Future<User> verifyOtp(String phoneNumber, String otp) async {
    final data = {
      "phone_number": phoneNumber,
      "otp": otp,
    };
    try {
      final response =
          await dio.post('/api/ufc-logistics/v1/driver/verify-otp', data: data);

      if (response.statusCode != 200) {
        throw Exception('Failed to verify OTP');
      }
      User? user;

      if (response.data['driver'] != null) {
        user = User.fromJson(response.data);
      } else if (response.data['data']['driver'] != null) {
        user = User.fromJson(response.data['data']);
      }
      Sentry.configureScope(
        (scope) => scope.setUser(
          SentryUser(
            email: user?.email,
            name: user?.fullName,
            data: {
              "phone_number": user?.phoneNumber,
            },
            id: user?.id?.toString(),
          ),
        ),
      );
      if (user == null) {
        throw 'Failed to fetch user info';
      }
      return user;
    } on DioException catch (e) {
      debugPrint('verify otp $e');
      throw e.error?.toString() ?? 'Failed to verify OTP';
    } catch (e) {
      debugPrint('fetch user info $e');
      throw Exception('Failed to fetch user info $e');
    }
  }

  Future<String?> getSavedToken() async {
    // Retrieve the saved token (e.g., from shared preferences or secure storage)
    final token = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString('token'));
    return token;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    // Call your API to check if the user is authenticated
    try {
      final response = await dio.get(
        '/api/ufc-logistics/v1/admin/whoami',
        // options: Options(
        //   headers: {'Authorization': 'Bearer ${await getSavedToken()}'}, // Pass the token here
        // ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch user info');
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await dio.post('/api/ufc-logistics/v1/driver/logout');
      if (response.statusCode == 200) {
        // Clear the saved token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
      } else {
        throw Exception('Logout failed');
      }
      return response.data;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
