import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage>
    with SingleTickerProviderStateMixin {
List orders = [];
  String? token;
  String? userId; // Menyimpan user_id
  bool isLoadingOrders = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchToken();
  }

  Future<void> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
    userId = prefs.getString('user_id'); // Ambil user_id dari SharedPreferences
    if (token != null && userId != null) {
      fetchOrders();
    } else {
      print('Token atau user_id tidak ditemukan');
    }
  }

Future<void> fetchOrders() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/orders?user_id=$userId'); // Tambahkan user_id ke URL
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List rawOrders = json.decode(response.body);
      setState(() {
        orders = rawOrders;
        isLoadingOrders = false;
      });
    } else {
      print('Gagal memuat pesanan: ${response.statusCode}');
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/orders/$orderId/status');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      fetchOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status berhasil diperbarui menjadi $status'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui status.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List filterOrdersByStatus(String status) {
    return orders.where((order) => order['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: const Color(0xFF67C4A7),
      ),
      body: isLoadingOrders
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Pending'),
                    Tab(text: 'Proses'),
                    Tab(text: 'Complete'),
                    Tab(text: 'Cancel'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      OrderList(
                        orders: filterOrdersByStatus('pending'),
                        onAccept: (orderId) =>
                            updateOrderStatus(orderId, 'process'),
                        onCancel: (orderId) =>
                            updateOrderStatus(orderId, 'canceled'),
                      ),
                      OrderList(
                        orders: filterOrdersByStatus('process'),
                        onComplete: (orderId) =>
                            updateOrderStatus(orderId, 'completed'),
                        onCancel: (orderId) =>
                            updateOrderStatus(orderId, 'canceled'),
                      ),
                      OrderList(
                        orders: filterOrdersByStatus('completed'),
                      ),
                      OrderList(
                        orders: filterOrdersByStatus('canceled'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class OrderList extends StatelessWidget {
  final List orders;
  final void Function(int orderId)? onAccept;
  final void Function(int orderId)? onComplete;
  final void Function(int orderId)? onCancel;

  const OrderList({
    Key? key,
    required this.orders,
    this.onAccept,
    this.onComplete,
    this.onCancel,
  }) : super(key: key);

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
                  subtitle: Text('Total Harga: Rp ${order['total_price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onAccept != null)
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => onAccept!(order['id']),
                        ),
                      if (onComplete != null)
                        IconButton(
                          icon: const Icon(Icons.done, color: Colors.blue),
                          onPressed: () => onComplete!(order['id']),
                        ),
                      if (onCancel != null)
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => onCancel!(order['id']),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
