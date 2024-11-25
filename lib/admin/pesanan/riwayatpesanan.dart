import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List orders = [];
  Map<int, String> userMap = {}; // Map untuk menyimpan data pengguna
  bool isLoadingOrders = true;
  String? token;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
    if (token != null) {
      await fetchUsers(); // Ambil data pengguna terlebih dahulu
      fetchOrders();
    } else {
      print('Token not found');
    }
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/users');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List rawUsers = json.decode(response.body);
      setState(() {
        userMap = {
          for (var user in rawUsers) user['id']: user['name']
        }; // Peta ID pengguna ke nama pengguna
      });
    } else {
      print('Failed to load users: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/orders');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List rawOrders = json.decode(response.body);
      setState(() {
        orders = rawOrders
            .where((order) =>
                order['status'] == 'completed' || order['status'] == 'canceled')
            .map((order) {
          order['user_name'] =
              userMap[order['user_id']] ?? 'Tidak Diketahui'; // Tambahkan nama pengguna
          return order;
        }).toList();
        isLoadingOrders = false;
      });
    } else {
      print('Failed to load orders: ${response.statusCode} ${response.body}');
    }
  }

  List filterOrders(String query) {
    if (query.isEmpty) {
      return orders;
    }
    return orders.where((order) {
      final userName = order['user_name'].toLowerCase();
      return userName.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFF67C4A7),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: OrderSearchDelegate(orders));
            },
          ),
        ],
      ),
      body: isLoadingOrders
          ? const Center(child: CircularProgressIndicator())
          : OrderList(orders: filterOrders(searchQuery)),
    );
  }
}

class OrderList extends StatelessWidget {
  final List orders;

  const OrderList({required this.orders, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? const Center(child: Text('Tidak ada pesanan.'))
        : ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Order ID: ${order['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${order['user_name']}'),
                      Text('Total Harga: Rp ${order['total_price']}'),
                      Text('Status: ${order['status']}'),
                    ],
                  ),
                  onTap: () {
                    // Navigasi ke detail pesanan jika perlu
                  },
                ),
              );
            },
          );
  }
}

class OrderSearchDelegate extends SearchDelegate {
  final List orders;

  OrderSearchDelegate(this.orders);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredOrders = orders.where((order) {
      final userName = order['user_name'].toLowerCase();
      return userName.contains(query.toLowerCase());
    }).toList();

    return OrderList(orders: filteredOrders);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return OrderList(orders: orders);
  }
}
