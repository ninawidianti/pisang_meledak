import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  // ignore: use_super_parameters
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  final formatter = NumberFormat('#,###', 'id_ID');
  Set<int> checkedItems = {};

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cartItems');
    if (cartData != null) {
      List<dynamic> jsonList = jsonDecode(cartData);
      setState(() {
        cartItems = jsonList.map((item) => CartItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartData =
        jsonEncode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cartItems', cartData);
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      saveCartItems();
    });
  }

  double calculateTotalPrice() {
    return checkedItems.fold(0, (total, index) {
      final item = cartItems[index];
      return total + (item.price * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final formattedPrice = formatter.format(item.price);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Checkbox untuk cek produk
                  Checkbox(
                    value: checkedItems.contains(index),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          checkedItems.add(index);
                        } else {
                          checkedItems.remove(index);
                        }
                      });
                    },
                  ),
                  // Gambar produk dan deskripsi
                  Expanded(
                    child: Row(
                      children: [
                        Image.network(item.imageUrl,
                            width: 60, height: 60, fit: BoxFit.cover),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal)),
                            Text('Rp $formattedPrice',
                                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            Text('x${item.quantity}',
                                style: const TextStyle(fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Tombol hapus
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeItem(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tampilkan Total Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Harga:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  'Rp ${formatter.format(calculateTotalPrice())}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tombol Pembayaran
            ElevatedButton(
              onPressed: () {
                // Implementasi logika pembayaran di sini
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: const Text('Pembayaran',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem {
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
