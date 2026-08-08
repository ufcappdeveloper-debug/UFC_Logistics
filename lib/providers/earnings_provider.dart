import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/models/earnings_model.dart';
import 'package:ufc_delivery_app/notifiers/earnings_notifier.dart';
import 'package:ufc_delivery_app/services/earnings_service.dart';

import '../config/dio.dart';

// Dio Provider
final dioProvider = Provider((ref) => api);

// Earnings Service Provider
final earningsServiceProvider =
    Provider((ref) => EarningsService(ref.read(dioProvider)));

// Earnings Notifier Provider
final earningsProvider = StateNotifierProvider<EarningsNotifier, EarningsState>(
  (ref) => EarningsNotifier(ref.read(earningsServiceProvider)),
);

// Earnings Fetch Provider
final earningsDataProvider = FutureProvider<EarningsModel>((ref) async {
  final earningsService = ref.read(earningsServiceProvider);

  // Fetch earnings data
  return await earningsService.fetchEarningsAnalytics();
});
