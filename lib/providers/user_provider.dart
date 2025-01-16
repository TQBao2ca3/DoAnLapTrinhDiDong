// user_provider.dart
import 'package:flutter/material.dart';
import 'package:phoneshop/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Hàm xử lý đăng ký
  Future<bool> register({
    required String username,
    required String password,
    required String full_name,
    required String email,
    required String phone,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Chuẩn bị data
      final userData = {
        'username': username,
        'password': password,
        'fullname': full_name,
        'email': email,
        'phone': phone,
      };

      // Gọi service đăng ký
      final result = await _userService.register(userData);

      if (result['success']) {
        return true;
      } else {
        _error = result['message'];
        return false;
      }
    } catch (e) {
      _error = 'Đã có lỗi xảy ra';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
