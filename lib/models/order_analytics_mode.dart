class OrderAnalyticsModel {
  int? ordersTaken;
  int? ordersDelivered;
  int? ordersCancelled;

  OrderAnalyticsModel(
      {this.ordersTaken, this.ordersDelivered, this.ordersCancelled});

  OrderAnalyticsModel.fromJson(Map<String, dynamic> json) {
    ordersTaken = int.tryParse((json['orders_taken'] ?? '').toString());
    ordersDelivered = int.tryParse((json['orders_delivered'] ?? '').toString());
    ordersCancelled = int.tryParse((json['orders_cancelled'] ?? '').toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orders_taken'] = ordersTaken;
    data['orders_delivered'] = ordersDelivered;
    data['orders_cancelled'] = ordersCancelled;
    return data;
  }
}
