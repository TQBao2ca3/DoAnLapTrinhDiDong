// user_service.dart
import 'dart:convert';
import 'package:phoneshop/services/api_service.dart';

class UserService {
  // Hàm xử lý đăng ký
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      // Gọi API đăng ký thông qua ApiService
      final response = await ApiService.postRequest('user/register', userData);

      // Parse response
      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối server'};
    }
  }
}
