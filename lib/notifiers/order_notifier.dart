import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/models/order_model.dart';
import 'package:ufc_delivery_app/models/scheduled_order_model.dart';
import 'package:ufc_delivery_app/services/order_service.dart';

class OrderState {
  final bool isLoadingOrders;
  final bool isLoadingScheduledOrders;
  final bool isLoadingdOrderDetails;
  final bool isAcceptingOrder;
  final bool isLoadingOutForDeliveryOrders;
  final bool isLoadingCompletedOrders;

  final List<OrderModel> orders;
  final int currentPage;
  final bool hasMoreOrders;

  final Map<String, dynamic>? orderDetails;

  final List<ScheduledOrderModel> scheduledOrders;
  final int currentScheduledPage;
  final bool hasMoreScheduledOrders;

  final List<OrderModel> outForDeliveryOrders;
  final int currentOutForDeliveryPage;
  final bool hasMoreOutForDeliveryOrders;

  final List<OrderModel> completedOrders;
  final int currentCompletedOrdersPage;
  final bool hasMoreCompletedOrders;

  final String? errorMessageOrders;
  final String? errorMessageScheduledOrders;
  final String? errorMessageOrderDetails;
  final String? errorMessageAcceptOrder;
  final String? errorMessageOutForDeliveryOrders;
  final String? errorMessageCompletedOrders;

  final int openTotalOrders;
  final int scheduledTotalOrders;
  final int outForDeliveryTotalOrders;
  final int completedTotalOrders;

  OrderState({
    this.isLoadingOrders = false,
    this.isLoadingScheduledOrders = false,
    this.isLoadingdOrderDetails = false,
    this.isAcceptingOrder = false,
    this.isLoadingOutForDeliveryOrders = false,
    this.isLoadingCompletedOrders = false,
    this.orders = const [],
    this.currentPage = 1,
    this.hasMoreOrders = true,
    this.orderDetails,
    this.scheduledOrders = const [],
    this.currentScheduledPage = 1,
    this.hasMoreScheduledOrders = true,
    this.outForDeliveryOrders = const [],
    this.currentOutForDeliveryPage = 1,
    this.hasMoreOutForDeliveryOrders = true,
    this.completedOrders = const [],
    this.currentCompletedOrdersPage = 1,
    this.hasMoreCompletedOrders = true,
    this.errorMessageOrders,
    this.errorMessageScheduledOrders,
    this.errorMessageOrderDetails,
    this.errorMessageAcceptOrder,
    this.errorMessageOutForDeliveryOrders,
    this.errorMessageCompletedOrders,
    this.openTotalOrders = 0,
    this.scheduledTotalOrders = 0,
    this.outForDeliveryTotalOrders = 0,
    this.completedTotalOrders = 0,
  });

  OrderState copyWith(
      {bool? isLoadingOrders,
      bool? isLoadingScheduledOrders,
      bool? isLoadingdOrderDetails,
      bool? isAcceptingOrder,
      bool? isLoadingOutForDeliveryOrders,
      bool? isLoadingCompletedOrders,
      List<OrderModel>? orders,
      int? currentPage,
      bool? hasMoreOrders,
      Map<String, dynamic>? orderDetails,
      List<ScheduledOrderModel>? scheduledOrders,
      int? currentScheduledPage,
      bool? hasMoreScheduledOrders,
      List<OrderModel>? outForDeliveryOrders,
      int? currentOutForDeliveryPage,
      bool? hasMoreOutForDeliveryOrders,
      List<OrderModel>? completedOrders,
      int? currentCompletedOrdersPage,
      bool? hasMoreCompletedOrders,
      String? errorMessageOrders,
      String? errorMessageScheduledOrders,
      String? errorMessageOrderDetails,
      String? errorMessageAcceptOrder,
      String? errorMessageOutForDeliveryOrders,
      String? errorMessageCompletedOrders,
      int? openTotalOrders,
      int? scheduledTotalOrders,
      int? outForDeliveryTotalOrders,
      int? completedTotalOrders}) {
    return OrderState(
      isLoadingOrders: isLoadingOrders ?? this.isLoadingOrders,
      isLoadingScheduledOrders:
          isLoadingScheduledOrders ?? this.isLoadingScheduledOrders,
      isLoadingdOrderDetails:
          isLoadingdOrderDetails ?? this.isLoadingdOrderDetails,
      isAcceptingOrder: isAcceptingOrder ?? this.isAcceptingOrder,
      isLoadingOutForDeliveryOrders:
          isLoadingOutForDeliveryOrders ?? this.isLoadingOutForDeliveryOrders,
      isLoadingCompletedOrders:
          isLoadingCompletedOrders ?? this.isLoadingCompletedOrders,
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMoreOrders: hasMoreOrders ?? this.hasMoreOrders,
      orderDetails: orderDetails ?? this.orderDetails,
      scheduledOrders: scheduledOrders ?? this.scheduledOrders,
      currentScheduledPage: currentScheduledPage ?? this.currentScheduledPage,
      hasMoreScheduledOrders:
          hasMoreScheduledOrders ?? this.hasMoreScheduledOrders,
      outForDeliveryOrders: outForDeliveryOrders ?? this.outForDeliveryOrders,
      currentOutForDeliveryPage:
          currentOutForDeliveryPage ?? this.currentOutForDeliveryPage,
      hasMoreOutForDeliveryOrders:
          hasMoreOutForDeliveryOrders ?? this.hasMoreOutForDeliveryOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      currentCompletedOrdersPage:
          currentCompletedOrdersPage ?? this.currentCompletedOrdersPage,
      hasMoreCompletedOrders:
          hasMoreCompletedOrders ?? this.hasMoreCompletedOrders,
      errorMessageOrders: errorMessageOrders ?? this.errorMessageOrders,
      errorMessageScheduledOrders:
          errorMessageScheduledOrders ?? this.errorMessageScheduledOrders,
      errorMessageOrderDetails:
          errorMessageOrderDetails ?? this.errorMessageOrderDetails,
      errorMessageAcceptOrder:
          errorMessageAcceptOrder ?? this.errorMessageAcceptOrder,
      errorMessageOutForDeliveryOrders: errorMessageOutForDeliveryOrders ??
          this.errorMessageOutForDeliveryOrders,
      errorMessageCompletedOrders:
          errorMessageCompletedOrders ?? this.errorMessageCompletedOrders,
      openTotalOrders: openTotalOrders ?? this.openTotalOrders,
      scheduledTotalOrders: scheduledTotalOrders ?? this.scheduledTotalOrders,
      outForDeliveryTotalOrders:
          outForDeliveryTotalOrders ?? this.outForDeliveryTotalOrders,
      completedTotalOrders: completedTotalOrders ?? this.completedTotalOrders,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderService orderService;

  OrderNotifier(this.orderService) : super(OrderState());

  Future<bool> fetchOrders({bool isRefreshing = false}) async {
    // If it's refreshing, reset the page and orders, else append new ones.
    if (isRefreshing) {
      state =
          state.copyWith(currentPage: 1, orders: [], errorMessageOrders: '');
    }

    // If already loading or no more orders, do not proceed.
    if (state.isLoadingOrders) return false;

    // Set loading state and clear any existing error  messages.
    state =
        state.copyWith(isLoadingOrders: isRefreshing, errorMessageOrders: null);

    try {
      final response = await orderService.fetchOrderList(state.currentPage);
      if (response['status'] == 'success') {
        final List<dynamic> newOrdersJson = response['data']['orders'];
        int totalOrders = response['data']['pagination']['total'];
        final List<OrderModel> newOrders =
            newOrdersJson.map((json) => OrderModel.fromJson(json)).toList();

        // Determine if there are more orders to load.
        bool hasMoreOrders = hasMoreData(response);

        // Update the state with the new orders, loading status, and page info.
        state = state.copyWith(
          orders: isRefreshing
              ? newOrders
              : state.orders + newOrders, // Append new orders
          isLoadingOrders: false,
          currentPage: hasMoreOrders
              ? state.currentPage + 1
              : state.currentPage, // Increment only if there are more orders
          hasMoreOrders: hasMoreOrders,
          openTotalOrders: totalOrders,
        );
        return hasMoreOrders;
      } else {
        // If the response is not successful, just stop loading.
        state = state.copyWith(isLoadingOrders: false);
      }
    } catch (e) {
      // Handle any errors that may have occurred.
      state = state.copyWith(
        isLoadingOrders: false,
        errorMessageOrders: e.toString(),
      );
    }
    return false;
  }

  bool hasMoreData(Map<String, dynamic> response) {
    return (response['data']['pagination']['current_page'] <=
        response['data']['pagination']['last_page']);
  }

  Future<void> fetchOrderDetails(String orderNumber) async {
    // Set loading state to true and reset error message
    state = state.copyWith(
        isLoadingdOrderDetails: true,
        errorMessageOrderDetails: null,
        orderDetails: {});

    try {
      // Fetch the order details from the service
      final response = await orderService.fetchOrderDetails(orderNumber);

      // Check if the response is valid and has the 'status' field
      if (response['status'] == 'success') {
        final details = response['data'];

        // Check if 'data' is not null and assign it to the state
        if (details != null) {
          state = state.copyWith(
              isLoadingdOrderDetails: false,
              orderDetails: details,
              errorMessageOrderDetails: '');
          debugPrint('heeya: ${state.errorMessageOrderDetails}');
        } else {
          state = state.copyWith(
              isLoadingdOrderDetails: false,
              errorMessageOrderDetails: 'No order details available'.tr());
        }
      } else {
        state = state.copyWith(
            isLoadingdOrderDetails: false,
            errorMessageOrderDetails: 'Failed to load order details');
      }
    } catch (e) {
      // Handle any errors that occurred during the fetch
      state = state.copyWith(
          isLoadingdOrderDetails: false,
          errorMessageOrderDetails: e.toString());
    }
  }

  Future<bool> fetchScheduledOrders({bool isRefreshing = false}) async {
    // If it's refreshing, reset the page and orders, else append new ones.
    if (isRefreshing) {
      state = state.copyWith(
        currentScheduledPage: 1,
        scheduledOrders: [],
      );
    }

    // If already loading or no more orders, do not proceed.
    // if (state.isLoadingScheduledOrders || !state.hasMoreScheduledOrders) return;

    // Set loading state and clear any existing error messages.
    state = state.copyWith(
      isLoadingScheduledOrders: isRefreshing,
      errorMessageScheduledOrders: null,
    );

    try {
      final response =
          await orderService.fetchScheduledOrders(state.currentScheduledPage);
      if (response['status'] == 'success') {
        final List<dynamic> newOrdersJson = response['data']['orders'];
        int totalOrders = response['data']['pagination']['total'];
        final List<ScheduledOrderModel> newScheduledOrders = newOrdersJson
            .map((json) =>
                ScheduledOrderModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Determine if there are more scheduled orders to load.
        bool hasMoreScheduledOrders = hasMoreData(response);

        // Update the state with the new orders, loading status, and page info.
        state = state.copyWith(
            scheduledOrders: [
              ...state.scheduledOrders,
              ...newScheduledOrders
            ], // Append new orders
            isLoadingScheduledOrders: false,
            currentScheduledPage: hasMoreScheduledOrders
                ? state.currentScheduledPage + 1
                : state
                    .currentScheduledPage, // Increment only if there are more orders
            hasMoreScheduledOrders: hasMoreScheduledOrders,
            scheduledTotalOrders: totalOrders);
        return hasMoreScheduledOrders;
      } else {
        // If the response is not successful, just stop loading.
        state = state.copyWith(isLoadingScheduledOrders: false);
      }
    } catch (e) {
      // Handle any errors that may have occurred.
      state = state.copyWith(
        isLoadingScheduledOrders: false,
        errorMessageScheduledOrders: e.toString(),
      );
      debugPrint('Error: ${e.toString()}');
    }
    return false;
  }

  Future<void> acceptOrder(String orderId) async {
    state =
        state.copyWith(isAcceptingOrder: true, errorMessageAcceptOrder: null);
    try {
      final response = await orderService.acceptOrder(orderId);
      if (response['status'] == 'success') {
        state = state.copyWith(isAcceptingOrder: false);
      } else {
        state = state.copyWith(
            isAcceptingOrder: false,
            errorMessageAcceptOrder: 'Failed to accept the order');
      }
    } catch (e) {
      state = state.copyWith(
          isAcceptingOrder: false, errorMessageAcceptOrder: e.toString());
    }
  }

  Future<bool> fetchOutForDeliveryOrders({bool isRefreshing = false}) async {
    // If it's refreshing, reset the page and orders; otherwise, append new ones.
    if (isRefreshing) {
      state = state.copyWith(
        currentOutForDeliveryPage: 1,
        outForDeliveryOrders: [],
      );
    }

    // Set loading state and clear any existing error messages.
    state = state.copyWith(
      isLoadingOutForDeliveryOrders: isRefreshing,
      errorMessageOutForDeliveryOrders: null,
    );

    try {
      // Fetch orders from the service using the current page.
      final response = await orderService
          .fetchOutForDeliveryOrders(state.currentOutForDeliveryPage);

      if (response['status'] == 'success') {
        final List<dynamic> newOrdersJson = response['data']['orders'];
        int totalOrders = response['data']['pagination']['total'];
        final List<OrderModel> newOutForDeliveryOrders = newOrdersJson
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Determine if there are more out-for-delivery orders to load.
        bool hasMoreOutForDeliveryOrders = hasMoreData(response);

        // Update the state with the new orders, loading status, and page info.
        state = state.copyWith(
          outForDeliveryOrders: [
            ...state.outForDeliveryOrders,
            ...newOutForDeliveryOrders,
          ], // Append new orders
          isLoadingOutForDeliveryOrders: false,
          currentOutForDeliveryPage: hasMoreOutForDeliveryOrders
              ? state.currentOutForDeliveryPage + 1
              : state
                  .currentOutForDeliveryPage, // Increment only if there are more orders
          hasMoreOutForDeliveryOrders: hasMoreOutForDeliveryOrders,
          outForDeliveryTotalOrders: totalOrders,
        );
        return hasMoreOutForDeliveryOrders;
      } else {
        // If the response is not successful, update the error message.
        state = state.copyWith(
          isLoadingOutForDeliveryOrders: false,
          errorMessageOutForDeliveryOrders:
              'Failed to load out-for-delivery orders',
        );
      }
    } catch (e) {
      // Handle any errors that may have occurred.
      state = state.copyWith(
        isLoadingOutForDeliveryOrders: false,
        errorMessageOutForDeliveryOrders: e.toString(),
      );
      debugPrint('Error: ${e.toString()}');
    }
    return false;
  }

  Future<bool> fetchCompletedOrders({bool isRefreshing = false}) async {
    // If it's refreshing, reset the page and orders; otherwise, append new ones.
    if (isRefreshing) {
      state = state.copyWith(
        currentCompletedOrdersPage: 1,
        completedOrders: [],
      );
    }
    debugPrint('Completed Orders1: ${state.completedOrders.length}');

    state = state.copyWith(
      isLoadingCompletedOrders: isRefreshing,
      errorMessageCompletedOrders: null,
    );

    try {
      // Fetch completed orders from the service using the current page.
      final response = await orderService
          .fetchCompletedOrders(state.currentCompletedOrdersPage);

      if (response['status'] == 'success') {
        final List<dynamic> newOrdersJson = response['data']['orders'];
        int totalOrders = response['data']['pagination']['total'];
        final List<OrderModel> newCompletedOrders = newOrdersJson
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Determine if there are more completed orders to load.
        bool hasMoreCompletedOrders = hasMoreData(response);

        // Update the state with the new orders, loading status, and page info.
        state = state.copyWith(
          completedOrders: [
            ...state.completedOrders,
            ...newCompletedOrders,
          ], // Append new completed orders
          isLoadingCompletedOrders: false,
          currentCompletedOrdersPage: hasMoreCompletedOrders
              ? state.currentCompletedOrdersPage + 1
              : state
                  .currentCompletedOrdersPage, // Increment only if there are more orders
          hasMoreCompletedOrders: hasMoreCompletedOrders,
          completedTotalOrders: totalOrders,
        );

        debugPrint('Completed Orders2: ${state.completedOrders.length}');
        return hasMoreCompletedOrders;
      } else {
        // If the response is not successful, update the error message.
        state = state.copyWith(
          isLoadingCompletedOrders: false,
          errorMessageCompletedOrders: 'Failed to load completed orders',
        );
      }
    } catch (e) {
      // Handle any errors that may have occurred.
      state = state.copyWith(
        isLoadingCompletedOrders: false,
        errorMessageCompletedOrders: e.toString(),
      );
    }
    return false;
  }
}
