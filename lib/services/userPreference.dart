import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String TOKEN_KEY = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
    print('Token saved: $token'); // Debug
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(TOKEN_KEY);
    print('Token retrieved: $token'); // Debug
    return token;
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
  }

  // Thêm vào initState của UserInformation
  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('Current token: $token'); // In ra để kiểm tra
  }
}
