import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListPesananPage extends StatefulWidget {
  const ListPesananPage({Key? key}) : super(key: key);

  @override
  State<ListPesananPage> createState() => _ListPesananPageState();
}

class _ListPesananPageState extends State<ListPesananPage>
    with SingleTickerProviderStateMixin {
  List orders = [];
  bool isLoadingOrders = true;
  String? token;
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
    if (token != null) {
      fetchOrders();
    } else {
      print('Token not found');
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
      final ordersWithUser = await Future.wait(rawOrders.map((order) async {
        final userName = await fetchUserName(order['user_id']);
        return {...order, 'user_name': userName};
      }).toList());

      setState(() {
        orders = ordersWithUser;
        isLoadingOrders = false;
      });
    } else {
      print('Failed to load orders: ${response.statusCode} ${response.body}');
    }
  }

  Future<String> fetchUserName(int userId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/users/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'] ?? 'Unknown User';
    } else {
      print('Failed to load user: ${response.statusCode} ${response.body}');
      return 'Unknown User';
    }
  }

Future<void> fetchOrderDetails(int orderId, BuildContext context) async {
  // Mengambil detail dari order items berdasarkan orderId
  final url = Uri.parse('http://127.0.0.1:8000/api/order-items?order_id=$orderId');
  
  try {
    // Mengambil item pesanan
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List orderItems = json.decode(response.body); // Ambil order items berdasarkan orderId

      // Ambil detail produk untuk setiap item pesanan dan gabungkan dengan data item pesanan
      final itemsWithProductDetails = await Future.wait(orderItems.map((item) async {
        final productDetails = await fetchProductDetails(item['product_id']);
        return {
          ...item,
          ...productDetails,
        }; // Gabungkan detail produk ke dalam item pesanan
      }).toList());

      // Jika berhasil mengambil data, navigasi ke halaman OrderDetailPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailPage(
            orderDetails: {
              'order_id': orderId, // Anda bisa menambahkan detail lain jika perlu
              // Tambahkan detail order lainnya jika ada
            },
            orderItems: itemsWithProductDetails, // Kirim semua orderItems yang sudah digabungkan
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil detail pesanan: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/products/$productId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'product_name': data['data']['name'],
        'description': data['data']['description'],
        'image_url': data['data']['image_url'],
        'price': data['data']['price'],
      };
    } else {
      print('Failed to load product: ${response.statusCode} ${response.body}');
      return {
        'product_name': 'Unknown Product',
        'description': '',
        'image_url': '',
        'price': 0,
      };
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
        SnackBar(
          content: const Text('Gagal memperbarui status. Coba lagi.'),
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
        title: const Text('Daftar Pesanan', style: TextStyle(fontSize: 18)),
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
  final Function(int orderId)? onAccept;
  final Function(int orderId)? onComplete;
  final Function(int orderId)? onCancel;

  const OrderList({
    required this.orders,
    this.onAccept,
    this.onComplete,
    this.onCancel,
    Key? key,
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${order['user_name']}'),
                      Text('Total Harga: Rp ${order['total_price']}'),
                      Text('Status: ${order['status']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (order['status'] == 'pending' && onAccept != null)
                        ElevatedButton(
                          onPressed: () => onAccept!(order['id']),
                          child: const Text('Terima'),
                        ),
                      if (order['status'] == 'pending' && onCancel != null)
                        ElevatedButton(
                          onPressed: () => onCancel!(order['id']),
                          child: const Text('Batalkan'),
                        ),
                      if (order['status'] == 'process' && onComplete != null)
                        ElevatedButton(
                          onPressed: () => onComplete!(order['id']),
                          child: const Text('Selesai'),
                        ),
                      if (order['status'] == 'process' && onCancel != null)
                        ElevatedButton(
                          onPressed: () => onCancel!(order['id']),
                          child: const Text('Batalkan'),
                        ),
                    ],
                  ),
                  onTap: () {
                    context
                        .findAncestorStateOfType<_ListPesananPageState>()
                        ?.fetchOrderDetails(order['id'], context);
                  },
                ),
              );
            },
          );
  }
}

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> orderDetails;
  final List orderItems;

  const OrderDetailPage(
      {required this.orderDetails, required this.orderItems, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFF67C4A7),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metode Pembayaran: ${orderDetails['payment_method']}'),
                Text('Metode Pengiriman: ${orderDetails['delivery_method']}'),
                Text('Alamat: ${orderDetails['address']}'),
                Text('Total Harga: Rp ${orderDetails['total_price']}'),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final item = orderItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(item['product_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jumlah: ${item['quantity']}'),
                        Text('Deskripsi: ${item['description']}'),
                        Text('Harga: Rp ${item['price']}'),
                      ],
                    ),
                    leading: item['image_url'] != null
                        ? Image.network(item['image_url'],
                            width: 50, height: 50, fit: BoxFit.cover)
                        : const SizedBox(width: 50, height: 50),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
