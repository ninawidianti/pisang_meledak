import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pisang_meledak/customer/produk/pembayaran.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
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

  void navigateToPaymentPage() {
    // Ambil produk dan jumlah yang dipilih
    List<String> productIds = [];
    List<int> quantities = [];

    for (int index in checkedItems) {
      productIds.add(
          cartItems[index].name); // Gantilah ini dengan ID produk yang sesuai
      quantities.add(cartItems[index].quantity);
    }

    double totalPrice = calculateTotalPrice(); // Hitung total harga

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranPage(
          productIds: productIds,
          quantities: quantities,
          totalPrice: totalPrice,
        ),
      ),
    );
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
                          Image.network(item.image_url,
                              width: 60, height: 60, fit: BoxFit.cover),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                              Text('Rp $formattedPrice',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              Text('x${item.quantity}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey)),
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
          }),
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
                if (checkedItems.isNotEmpty) {
                  navigateToPaymentPage(); // Panggil fungsi untuk navigasi ke halaman pembayaran
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Silakan pilih item untuk dibayar")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF67C4A7),
                minimumSize: const Size.fromHeight(50), // Atur tinggi tombol
              ),
              child: const Text(
                'Pembayaran',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartItem {
  final String image_url;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.image_url,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      image_url: json['image_url'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': image_url,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
