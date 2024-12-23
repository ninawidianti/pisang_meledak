// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pisang_meledak/admin/homepage2.dart';
import 'package:pisang_meledak/customer/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Halaman login utama

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.grey),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 248, 255, 253)),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 18),
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16),
          bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 14),
          titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
          titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final role = prefs.getString('role'); // Simpan role saat login
    final userName = prefs.getString('name');

    if (token != null) {
      // Token ditemukan, arahkan ke halaman sesuai role
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage2(userName: userName!),
          ),
        );
      } else if (role == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userName: userName!),
          ),
        );
      }
    } else {
      // Tidak ada token, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Tampilan loading
      ),
    );
  }
}
