import 'dart:convert';
import 'package:phoneshop/models/User.dart';
import 'package:phoneshop/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:phoneshop/services/userPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = '${ApiService.baseUrl}';

  // Thêm phương thức login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': responseData['token'],
          'userId': responseData['userId'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng nhập thất bại'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  Future<Map<String, dynamic>> postRegister(
      Map<String, dynamic> userData) async {
    try {
      final response = await ApiService.postRequest('user/register', userData);
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

  Future<Map<String, dynamic>> getUserInformation() async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No token found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Invalid response format'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> userData) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No token found'};
      }

      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No token found'};
      }

      final response = await http.put(
        Uri.parse('$baseUrl/user/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
}
