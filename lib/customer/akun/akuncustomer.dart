// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pisang_meledak/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pisang_meledak/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: use_key_in_widget_constructors
class AccountPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthService _authService = AuthService();
  String? userName = "User";
  String? userEmail = "user@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.fetchUserData();
    if (userData != null) {
      setState(() {
        userName = userData['name'];
        userEmail = userData['email'];
      });
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Iya"),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _authService.logout();
      // Navigasi ke halaman login dan hapus semua halaman sebelumnya dari tumpukan
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Menghapus semua rute sebelumnya
      );
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(name: userName!, email: userEmail!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun Saya"),
        // leading: IconButton(  // HAPUS BAGIAN INI
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo, $userName", style: const TextStyle(fontSize: 24)),
            Text(
              userEmail ??
                  "Email tidak ditemukan", // Tampilkan email di bawah nama
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 30, thickness: 1),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Pengaturan"),
              subtitle: const Text("Edit profil dan notifikasi"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _openSettings,
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              subtitle: const Text("Keluar Dari Akun"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _confirmLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final String name;
  final String email;

  // ignore: use_super_parameters
  const SettingsPage({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool salesNotifications = true;
  bool newArrivalsNotifications = false;
  bool statusDeliveryNotifications = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
  }

  Future<void> _saveChanges() async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text);
      await prefs.setString('user_email', _emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui profil")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "************",
                suffixText: 'Change',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Notifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Sales'),
              value: salesNotifications,
              onChanged: (bool value) {
                setState(() {
                  salesNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('New arrivals'),
              value: newArrivalsNotifications,
              onChanged: (bool value) {
                setState(() {
                  newArrivalsNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Status Delivery'),
              value: statusDeliveryNotifications,
              onChanged: (bool value) {
                setState(() {
                  statusDeliveryNotifications = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
