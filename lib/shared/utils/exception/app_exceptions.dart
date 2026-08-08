import 'package:dio/dio.dart';

enum AppExceptionType { network, server, validation, unknown }

class AppExceptionImpl {
  static AppException fromDioException(DioException error,
      {bool canRefreshToken = false}) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw AppException('Connection timeout');
      case DioExceptionType.sendTimeout:
        return AppException('Connection timeout',
            prefix: 'Network Error: ', type: AppExceptionType.network);
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.unknown:
        if (error.response?.data != null) {
          return BadRequestException(error);
        }
        return AppException(error.message ?? 'Unknown error occurred',
            prefix: 'Network Error: ', type: AppExceptionType.network);
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return BadRequestException(error);
          case 401:
            return BadRequestException(error);
          case 404:
            return AppException('Path not found',
                type: AppExceptionType.server);
          case 413:
            return SomethingWentWrongException(
                errorMessage: error.response?.statusMessage);
          case 422:
            return BadRequestException(error);
          case 500:
            return InternalServerErrorException();
          case 502:
            return SomethingWentWrongException(
              errorMessage:
                  "Server issues detected! We're on it. Please try again later.",
            );
          case 504:
            return SomethingWentWrongException(
              errorMessage:
                  "Server issues detected! We're on it. Please try again later.",
            );
          default:
            return SomethingWentWrongException(
                errorMessage: errorMessage(error));
        }
      default:
        return SomethingWentWrongException(errorMessage: errorMessage(error));
    }
  }

  static String errorMessage(DioException err) {
    return err.response?.data['error'] ??
        err.response?.data['errors'] ??
        err.response?.data['message'] ??
        err.response?.data['detail'] ??
        err.message ??
        err.response ??
        'Unknown error occurred';
  }
}

class AppException implements Exception {
  final String message;
  final String prefix;
  final AppExceptionType type;

  AppException(this.message,
      {this.prefix = '', this.type = AppExceptionType.unknown});

  @override
  String toString() {
    return "$prefix$message";
  }
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException()
      : super("Internal Server Error", type: AppExceptionType.server);
}

class SomethingWentWrongException extends AppException {
  SomethingWentWrongException({String? errorMessage})
      : super(errorMessage ?? "Something went wrong",
            type: AppExceptionType.server);
}

class BadRequestException extends AppException {
  late final List<String> errors;
  BadRequestException(DioException error)
      : super("Bad Request", type: AppExceptionType.validation) {
    errors = [];
    if (error.response?.data != null) {
      var responseData = error.response?.data;

      if (responseData['status'] == 'fail' &&
          responseData.containsKey('errors')) {
        if (responseData['errors'] is Map) {
          for (List<dynamic> values in responseData['errors'].values) {
            for (var err in values) {
              errors.add(err.toString());
            }
          }
        } else if (responseData['errors'] is List) {
          errors.addAll(responseData['errors'].cast<String>());
        } else if (responseData['errors'] is String) {
          errors.add(responseData['errors'] as String);
        }
      } else if (responseData['message'] is String) {
        errors.add(responseData['message'] as String);
      } else if (responseData['error'] is String) {
        errors.add(responseData['error'] as String);
      } else if (responseData['detail'] is String) {
        errors.add(responseData['detail'] as String);
      } else if (responseData['data'] != null &&
          responseData['data']['message'] != null) {
        errors.add(responseData['data']['message'] as String);
      } else {
        errors.add('Unknown error occurred!!');
      }
    } else {
      errors.add('An unknown error occurred');
    }

    if (errors.isEmpty) {
      throw SomethingWentWrongException();
    }
    throw errors.map<String>((e) => e);
  }
}
