import 'package:dio/dio.dart';

import 'package:ufc_delivery_app/config/config.dart';
import 'package:ufc_delivery_app/config/dio_interceptors.dart';

final _dio = Dio(
  BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ),
)..interceptors.addAll([
    AppInterceptor(),
  ]);

Dio get api => _dio;
