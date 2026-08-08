import 'package:dio/dio.dart';
import 'package:ufc_delivery_app/models/earnings_model.dart';

class EarningsService {
  final Dio dio;

  EarningsService(this.dio);

  Future<EarningsModel> fetchEarningsAnalytics() async {
    try {
      final response =
          await dio.get('/api/ufc-logistics/v1/driver/analytics/earnings');

      if (response.statusCode == 200) {
        // Assuming the API returns data in the expected format
        return EarningsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch earnings');
      }
    } catch (e) {
      throw Exception('Failed to fetch earnings: $e');
    }
  }
}
