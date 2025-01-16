// user_service.dart
import 'dart:convert';
import 'package:phoneshop/models/User.dart';
import 'package:phoneshop/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:phoneshop/services/userPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 'http://192.168.1.9:3000/api';
  // Hàm xử lý đăng ký
  // Future<Map<String, dynamic>> postRegister(User user) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${ApiService.baseUrl}/user/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(user.toJson()),
  //     );

  //     final responseData = jsonDecode(response.body);

  //     if (response.statusCode == 201) {
  //       return {
  //         'success': true,
  //         'data': responseData,
  //       };
  //     } else {
  //       return {
  //         'success': false,
  //         'message': responseData['message'] ?? 'Registration failed',
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'message': 'Network error occurred',
  //     };
  //   }
  // }
  Future<Map<String, dynamic>> postRegister(
      Map<String, dynamic> userData) async {
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

  // user_service.dart
  Future<Map<String, dynamic>> getUserInformation() async {
    print('Calling URL: $baseUrl/user/profile');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Kiểm tra response type
      String contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        return {
          'success': false,
          'message': 'Invalid response format from server'
        };
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        // Token invalid hoặc expired
        await UserPreferences.removeToken(); // Xóa token
        return {'success': false, 'message': 'Authentication failed'};
      }

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseBody['data']};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Failed to load user profile'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
