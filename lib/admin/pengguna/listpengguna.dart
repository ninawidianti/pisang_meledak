import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPengguna extends StatefulWidget {
  @override
  _ListPenggunaState createState() => _ListPenggunaState();
}

class _ListPenggunaState extends State<ListPengguna>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> admins = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/users'));

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json
          .decode(response.body); // Parse the response body as List<dynamic>

      setState(() {
        customers = data
            .where((user) => user['role'] == 'customer')
            .map((user) => user as Map<String,
                dynamic>) // Cast each item to Map<String, dynamic>
            .toList();
        admins = data
            .where((user) => user['role'] == 'admin')
            .map((user) => user as Map<String,
                dynamic>) // Cast each item to Map<String, dynamic>
            .toList();
      });
    } else {
      print('Gagal mengambil data');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengguna',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: const Color(0xFF67C4A7),
      ),
      body: Column(
        children: [
          // Tab bar untuk memilih antara customer dan admin
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text(
                  'Customer',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  'Admin',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          // Daftar pengguna berdasarkan tab yang dipilih
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserList(customers),
                _buildUserList(admins),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal.shade200,
              child: Text(
                users[index]['name'][0].toUpperCase(), // Inisial nama
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              users[index]['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Email: ${users[index]['email']}',
                    style: const TextStyle(color: Color(0xFF6C757D))),
                Text('No HP: ${users[index]['no_hp']}',
                    style: const TextStyle(color: Color(0xFF6C757D))),
                Text('Alamat: ${users[index]['alamat']}',
                    style: const TextStyle(color: Color(0xFF6C757D))),
                Text('Role: ${users[index]['role']}',
                    style: TextStyle(
                        color: users[index]['role'] == 'admin'
                            ? Colors.red.shade400
                            : Colors.teal.shade400,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListPengguna(),
    theme: ThemeData(
      fontFamily: 'Poppins',
      primaryColor: const Color(0xFF67C4A7),
    ),
  ));
}