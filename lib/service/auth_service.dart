import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl = "http://127.0.0.1:8000/api/login";

  get fetchUser => null;

  Future<String?> login(String email, String password) async {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token']; // Pastikan ini sesuai dengan respons dari backend

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
        return token;
      }
    }
    return null; // Jika gagal
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    await http.post(
      Uri.parse("http://127.0.0.1:8000/api/logout"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Hapus token dari SharedPreferences
    await prefs.remove('access_token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  fetchUserData() {}
}
