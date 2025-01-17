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

  Future<Map<String, dynamic>> getUserInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response headers: ${response.headers}');
      // Check the content type here
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

  // Thêm phương thức updateUserProfile
  // user_service.dart
  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> userData) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/user/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to change password: ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
