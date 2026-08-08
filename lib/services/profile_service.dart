import 'package:dio/dio.dart';
import 'package:ufc_delivery_app/models/user_model.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<User> fetchUserProfile() async {
    try {
      final response = await dio.get('/api/ufc-logistics/v1/driver/profile');

      if (response.statusCode == 200) {
        // Assuming the API returns data in the expected format
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (e) {
      print('Failed to fetch user profile: $e');
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
