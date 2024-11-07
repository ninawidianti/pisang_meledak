// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pisang_meledak/customer/akun/setting.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// ignore: use_key_in_widget_constructors
class AkunCustomer extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AkunCustomerState createState() => _AkunCustomerState();
}

class _AkunCustomerState extends State<AkunCustomer> {
  String name = '';
  String email = '';
  String alamat = '';
  // ignore: non_constant_identifier_names
  String no_hp = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check login status
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      fetchUserData(); // Fetch user data if logged in
    } else {
      // Navigate to homepage if not logged in
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
          context, '/homepage'); // Replace with your route
    }
  }

  Future<void> fetchUserData() async {
    final loginResponse = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login'),
      body: {
        'email': 'user@example.com', // Replace with actual user email
        'password': 'password123', // Replace with actual user password
      },
    );

    if (loginResponse.statusCode == 200) {
      final loginData = jsonDecode(loginResponse.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString(
          'token', loginData['token']); // Simpan token di SharedPreferences

      String userId = loginData['user']['id'];
      String token = loginData['token'];

      // Fetch user details using user ID
      final userResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token', // Send token if required
        },
      );

      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        setState(() {
          name = userData['name'] ?? 'No Name';
          email = userData['email'] ?? 'No Email';
          alamat = userData['alamat'] ?? 'No Address';
          no_hp = userData['no_hp'] ?? 'No Phone Number';
        });
      } else {
        setState(() {
          name = 'Error fetching user data';
          email = 'Error fetching user data';
          alamat = 'Error fetching user data';
          no_hp = 'Error fetching user data';
        });
      }
    } else {
      setState(() {
        name = 'Error logging in';
        email = 'Error logging in';
        alamat = 'Error logging in';
        no_hp = 'Error logging in';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Message
            Text(
              'Hello, $name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            // Profile Menu Items
            ProfileMenuItem(
              icon: Icons.settings,
              title: 'Pengaturan',
              subtitle: 'Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(name: name, email: email),
                  ),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Keluar Dari Akun',
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs
                    .getString('token'); // Ambil token dari SharedPreferences

                if (token != null) {
                  final response = await http.post(
                    Uri.parse('http://127.0.0.1:8000/api/logout'),
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                  );

                  if (response.statusCode == 200) {
                    await prefs.remove('token');
                    await prefs.setBool('isLoggedIn', false);

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    print('Logout gagal: ${response.body}');
                  }
                } else {
                  print('Token tidak ditemukan.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
