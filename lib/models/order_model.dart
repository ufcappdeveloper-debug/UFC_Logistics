import 'package:easy_localization/easy_localization.dart';

class OrderModel {
  int id;
  double amount;
  String bookingDateTime;
  String orderStatus;
  double? deliveryFee;
  String paymentMethod;
  String? shopName;
  String? deliveryAddress;
  bool driverCanAcceptOrder;
  double deliveryDistance;

  OrderModel({
    required this.id,
    required this.amount,
    required this.bookingDateTime,
    required this.orderStatus,
    this.deliveryFee = 0,
    required this.paymentMethod,
    required this.shopName,
    this.deliveryAddress,
    required this.driverCanAcceptOrder,
    this.deliveryDistance = 0,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      bookingDateTime: json['booking_date_time'] ?? 'N/A'.tr(),
      orderStatus: json['order_status'] ?? 'Unknown'.tr(),
      deliveryFee: double.tryParse(json['delivery_fee'].toString()),
      paymentMethod: json['payment_method'] ?? 'Unknown'.tr(),
      shopName: json['shop']?['name_en'] ?? 'No Station'.tr(),
      deliveryAddress: json['delivery_address']?['address'],
      driverCanAcceptOrder: json['driverCanAcceptOrder'] ?? false,
      deliveryDistance: json['delivery_distance'] != null
          ? double.tryParse(json['delivery_distance'].toString()) ?? 0
          : 0,
    );
  }
}
