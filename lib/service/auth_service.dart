import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl = "http://127.0.0.1:8000/api/login";

  Future<String?> login(String email, String password) async {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      // Simpan token ke SharedPreferences
      final token = response.body; // Sesuaikan ini untuk mengambil token dari respons
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      return token;
    } else {
      // Tangani error
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
