import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

void debugLog(String message) {
  if (kDebugMode) log(message);
}

class AppErrorLogger {
  static Future<void> logError(String errorMessage, {String? type}) async {
    // Log error details to New Relic
    // NewrelicMobile.instance.recordError(errorMessage, StackTrace.current);

    // Log error details
    debugLog("-----------------${type ?? 'Error'}-----------------");
    debugLog(errorMessage);
    debugLog("-----------------End ${type ?? 'Error'}-----------------");
    return;
  }

  static Future<void> onDioErrorLogger(DioException error) async {
    // Log error details to New Relic
    // NewRelicUtils.recordDioError(error);

    // Log error details
    debugLog("-----------------Dio Error-----------------");
    debugLog("$error");
    debugLog("Message:");
    debugLog("${error.message}");
    debugLog("Response:");
    debugLog("${error.response}");
    debugLog("Data: ${error.response?.data}");
    debugLog("${error.response?.statusCode}");
    debugLog("${error.response?.statusMessage}");
    debugLog("Request:");
    debugLog("Path: ${error.requestOptions.path}");
    debugLog("${error.requestOptions.headers}");
    debugLog("${error.response?.requestOptions.data}");
    debugLog("${error.requestOptions.queryParameters}");
    debugLog("-----------------End Dio Error-----------------");
    return;
  }
}
