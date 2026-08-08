import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/notifiers/order_notifier.dart';
import 'package:ufc_delivery_app/services/order_service.dart';

import '../config/dio.dart';

// Dio Provider
final dioProvider = Provider((ref) => api);

// Order Service Provider
final orderServiceProvider =
    Provider((ref) => OrderService(ref.read(dioProvider)));

// Order Notifier Provider
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(ref.read(orderServiceProvider)),
);

final orderDetailsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, orderId) async {
  // Only watch the orderProvider for updated state
  final orderState = ref.watch(orderProvider);

  // If the order details are already fetched, return them directly
  if (orderState.orderDetails != null) {
    return orderState.orderDetails!;
  }

  // Return an empty map if order details are not yet available
  return {};
});

// Scheduled Orders Provider
final scheduledOrdersProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, page) async {
  final orderService = ref.read(orderServiceProvider);

  // Fetch the scheduled orders for the given page
  return await orderService.fetchScheduledOrders(page);
});

// Accept Order Provider
final acceptOrderProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, orderId) async {
  final orderService = ref.read(orderServiceProvider);

  // Call the accept order method with the given order ID
  return await orderService.acceptOrder(orderId);
});

final outForDeliveryProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, page) async {
  final orderService = ref.read(orderServiceProvider);

  // Fetch orders that are out for delivery for the provided page
  return await orderService.fetchOutForDeliveryOrders(page);
});

// Completed Orders Provider
final completedOrdersProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, page) async {
  final orderService = ref.read(orderServiceProvider);

  // Fetch completed orders for the provided page
  return await orderService.fetchCompletedOrders(page);
});
