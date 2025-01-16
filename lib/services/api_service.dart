import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phoneshop/pages/UserInformation.dart';
import 'package:phoneshop/pages/userAuthentication.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.9:3000/api';

  //hàm GET
  static Future<http.Response> getRequest(String endpoint) async {
    print('${baseUrl}/${endpoint}');
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url, headers: _headers());
  }

  //hàm POST
  static Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(url, headers: _headers(), body: body);
  }

  //headers mặc định (có thể thêm token ở đây)
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
    // Thêm các routes khác
  };
}
