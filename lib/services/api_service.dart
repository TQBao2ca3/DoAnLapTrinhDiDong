import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.4:3000/api';

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
