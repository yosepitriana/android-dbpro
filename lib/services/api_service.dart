import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://central-app.dbpro.id/api/v1/';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/login'),
      headers: const {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password}),
    ).timeout(const Duration(seconds: 30));

    final body = _json(response);
    if (response.statusCode >= 400) {
      throw ApiException(body['message']?.toString() ?? body['error']?.toString() ?? 'Login gagal');
    }
    final token = body['accessToken']?.toString();
    if (token == null || token.isEmpty) throw ApiException('Token login tidak diterima');
    return token;
  }

  Future<Map<String, dynamic>> dashboard(String token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}monitoring/dashboard'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    ).timeout(const Duration(seconds: 30));

    final body = _json(response);
    if (response.statusCode == 401) throw const UnauthorizedException();
    if (response.statusCode >= 400) {
      throw ApiException(body['message']?.toString() ?? 'Gagal mengambil data monitoring');
    }
    return body;
  }

  Map<String, dynamic> _json(http.Response response) {
    try {
      final value = jsonDecode(response.body);
      return value is Map<String, dynamic> ? value : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{'message': response.body};
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override String toString() => message;
}
class UnauthorizedException implements Exception {
  const UnauthorizedException();
}
