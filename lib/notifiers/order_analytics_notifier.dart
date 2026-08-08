import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/models/order_analytics_mode.dart';
import 'package:ufc_delivery_app/services/order_service.dart';

class OrderAnalyticsState {
  final OrderAnalyticsModel? analytics;
  final bool isLoading;
  final String? errorMessage;

  OrderAnalyticsState({
    this.analytics,
    this.isLoading = false,
    this.errorMessage,
  });

  OrderAnalyticsState copyWith({
    OrderAnalyticsModel? analytics,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderAnalyticsState(
      analytics: analytics ?? this.analytics,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderAnalyticsNotifier extends StateNotifier<OrderAnalyticsState> {
  final OrderService orderService;

  OrderAnalyticsNotifier(this.orderService)
      : super(OrderAnalyticsState(isLoading: true));

  Future<void> fetchOrderAnalytics(String filterBasedOn) async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await orderService.fetchOrderAnalytics(filterBasedOn);
      state = state.copyWith(analytics: user, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch user profile: ${e.error ?? ''}',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch user profile: $e',
      );
    }
  }
}
