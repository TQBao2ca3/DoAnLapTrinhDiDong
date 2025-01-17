// user_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phoneshop/models/User.dart';
import 'package:phoneshop/pages/userAuthentication.dart';
import 'package:phoneshop/services/api_service.dart';
import 'package:phoneshop/services/userPreference.dart';
import 'package:phoneshop/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _userData = {};

  // Getters
  bool get isLoading => _isLoading;
  Map<String, dynamic> get userData => _userData;
  String? get error => _error;

  // Hàm xử lý đăng ký
  Future<void> register({
    required String username,
    required String password,
    required String full_name,
    required String email,
    required String phone,
  }) async {
    if (_isLoading) return; // Tránh gọi nhiều lần

    _isLoading = true;
    // Đợi frame tiếp theo trước khi notify
    Future.microtask(() => notifyListeners());
    // Chuẩn bị data

    try {
      final userData = {
        'username': username,
        'password': password,
        'fullname': full_name,
        'email': email,
        'phone': phone,
      };

      // Gọi service đăng ký
      final userRegister = await _userService.postRegister(userData);
    } catch (e) {
      _error = 'Đã có lỗi xảy ra';
      return;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // user_provider.dart
  Future<void> getUserInformation(BuildContext context) async {
    print('UserProvider - Starting getUserInformation');

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _userService.getUserInformation();
      print('UserProvider - Raw response: $response');

      if (response['success'] == true && response['data'] != null) {
        _userData = response['data'];
        _error = null;
      } else {
        _error = response['message'] ?? 'Unknown error';

        // Kiểm tra token invalid
        if (response['message']?.contains('token') == true ||
            response['message']?.contains('authenticate') == true) {
          // Clear token
          await UserPreferences.removeToken();

          if (context.mounted) {
            // Kiểm tra navigation mounted
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UserAuthentication()));
          }
        }
      }
    } catch (e) {
      _error = 'Connection error: $e';
      print('UserProvider - Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm phương thức updateUserProfile
  // user_provider.dart
  Future<void> updateUserProfile(
    BuildContext context, {
    String? full_name,
    String? email,
    String? phone,
    String? address,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updateData = <String, dynamic>{};
      if (full_name != null) updateData['full_name'] = full_name;
      if (email != null) updateData['email'] = email;
      if (phone != null) updateData['phone'] = phone;
      if (address != null) updateData['address'] = address;

      final response = await _userService.updateUserProfile(updateData);

      if (response['success'] == true) {
        _userData = response['data'];
        _error = null;
      } else {
        _error = response['message'] ?? 'Update failed';
      }
    } catch (e) {
      _error = 'Connection error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // user_provider.dart
  Future<void> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _userService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (response['success'] == true) {
        _error = null;
      } else {
        _error = response['message'] ?? 'Password change failed';
      }
    } catch (e) {
      _error = 'Connection error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
