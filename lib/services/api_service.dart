import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phoneshop/pages/UserInformation.dart';
import 'package:phoneshop/pages/userAuthentication.dart';

class ApiService {
  // Khai báo baseUrl là static
  static const String baseUrl = 'http://192.168.31.18:3000/api';

  // Khai báo phương thức getRequest là static
  static Future<http.Response> getRequest(String endpoint) async {
    print('Making GET request to: $baseUrl/$endpoint');
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.get(url, headers: _headers());
      print('Response received from API');
      return response;
    } catch (e) {
      print('Error in API request: $e');
      rethrow;
    }
  }

  // Khai báo phương thức postRequest là static
  static Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(url, headers: _headers(), body: body);
  }

  // Khai báo phương thức _headers là static
  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const UserInformation(),
    '/login': (context) => const UserAuthentication(),
  };
}
