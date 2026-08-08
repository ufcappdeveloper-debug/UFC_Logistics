import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/notifiers/order_analytics_notifier.dart';
import 'package:ufc_delivery_app/services/order_service.dart';
import '../config/dio.dart';

final dioProvider = Provider((ref) => api);

final orderAnalyticsServiceProvider =
    Provider((ref) => OrderService(ref.read(dioProvider)));

final orderAnalyticsProvider =
    StateNotifierProvider<OrderAnalyticsNotifier, OrderAnalyticsState>(
  (ref) => OrderAnalyticsNotifier(ref.read(orderAnalyticsServiceProvider)),
);
