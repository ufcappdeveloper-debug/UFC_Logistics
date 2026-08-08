import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_delivery_app/models/order_analytics_mode.dart';

class OrderService {
  final Dio dio;

  OrderService(this.dio);

  Future<Map<String, dynamic>> fetchOrderList(int page) async {
    final response = await dio.get(
        '/api/ufc-logistics/v1/driver/orders/avilable-orders',
        queryParameters: {
          'page': page,
        });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  Future<Map<String, dynamic>> fetchOrderDetails(String orderNumber) async {
    final response = await dio.get(
      '/api/ufc-logistics/v1/driver/order/$orderNumber/details',
      options: Options(
        validateStatus: (status) {
          return status != null && status < 500; // Allow all statuses below 500
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch order details');
    }
  }

  Future<Map<String, dynamic>> fetchScheduledOrders(int page) async {
    final response = await dio.get(
      '/api/ufc-logistics/v1/driver/orders/scheduled-orders',
      queryParameters: {'page': page},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> acceptOrder(String orderId) async {
    final response = await dio.post(
      '/api/ufc-logistics/v1/driver/accept-order',
      data: {'order_id': orderId},
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to accept order'.tr());
    }
  }

  Future<Map<String, dynamic>> fetchOutForDeliveryOrders(int page) async {
    final response = await dio.get(
      '/api/ufc-logistics/v1/driver/orders/out-for-delivery',
      queryParameters: {'page': page},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> fetchCompletedOrders(int page) async {
    final response = await dio.get(
      '/api/ufc-logistics/v1/driver/orders/out-for-delivery',
      queryParameters: {
        'page': page,
        'order_status': 'COMPLETED',
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch completed orders');
    }
  }

  Future<OrderAnalyticsModel> fetchOrderAnalytics(String filterString) async {
    final response = await dio.get(
      '/api/ufc-logistics/v1/driver/analytics/statistics',
      queryParameters: {
        'filter': filterString,
      },
    );
    return OrderAnalyticsModel.fromJson(response.data ?? {});
  }
}
