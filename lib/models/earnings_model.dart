class EarningsModel {
  double totalEarnings;
  int totalOrders;
  double lastMonthEarnings;
  List<double> ordersChart;

  EarningsModel({
    required this.totalEarnings,
    required this.totalOrders,
    required this.lastMonthEarnings,
    required this.ordersChart,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      totalEarnings: (json['total_earnings'] as num).toDouble(),
      totalOrders: json['total_orders'],
      lastMonthEarnings: (json['last_month_earnings'] as num).toDouble(),
      ordersChart: List<double>.from(
          json['orders_chart'].map((e) => (e as num).toDouble())),
    );
  }
}
