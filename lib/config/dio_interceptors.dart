import 'package:dio/dio.dart';
import 'package:ufc_delivery_app/config/config.dart';
import 'package:ufc_delivery_app/config/local_storage.dart';
import 'package:ufc_delivery_app/main.dart';
import 'package:ufc_delivery_app/shared/utils/exception/app_exceptions.dart';
import 'package:ufc_delivery_app/shared/utils/log/log_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppErrorLogger.onDioErrorLogger(err);
    Sentry.captureException(err);
    throw AppExceptionImpl.fromDioException(err, canRefreshToken: true);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add headers or tokens here
    if (AppConfig.token != null) {
      debugLog("Token: ${AppConfig.token}");

      options.headers['Authorization'] = 'Bearer ${AppConfig.token}';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Log response token
    debugLog("Response is ${response.data}");

    final data = response.data as Map<String, dynamic>?;

    if (data != null) {
      // Check if token exists and store it
      final token = data['data']?['token'];

      if (token != null) {
        await preferences.setString(LocalStorage.token, token);
        AppConfig.token = token;
      }
    }

    super.onResponse(response, handler);
  }
}

/// Provides a default error message for DioException.
extension DioMessage on DioException {
  String get dioMessage =>
      error?.toString() ??
      "An unexpected error occurred. Please contact the admin for assistance";
}
