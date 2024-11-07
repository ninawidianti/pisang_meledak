import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pisang_meledak/customer/produk/keranjang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProduct extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String image_url; // This should still hold the path for local assets
  final String name;
  final String price;
  final String description;
  final int numberOfPurchases;

  const DetailProduct({
    super.key,
    // ignore: non_constant_identifier_names
    required this.image_url,
    required this.name,
    required this.price,
    required this.description,
    required this.numberOfPurchases,
  });

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  bool _isFavorite = false;
  int _quantity = 1; // Initialize the quantity with 1
  List<CartItem> cartItems =
      []; // List untuk menampung item yang ditambahkan ke keranjang

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedPrice = formatter.format(int.tryParse(widget.price) ?? 0);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      widget.image_url), // Use NetworkImage for URLs
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Product Title and Favorite Button
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Price and Purchases Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    'Rp. $formattedPrice',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${widget.numberOfPurchases} terjual',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Product Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Quantity Selector and Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Quantity Selector
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_quantity > 1) {
                              _quantity--;
                            }
                          });
                        },
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () async {
                      // Muat item keranjang yang sudah ada
                      final prefs = await SharedPreferences.getInstance();
                      String? cartData = prefs.getString('cartItems');
                      List<CartItem> cartItems = [];

                      if (cartData != null) {
                        List<dynamic> jsonList = jsonDecode(cartData);
                        cartItems = jsonList
                            .map((item) => CartItem.fromJson(item))
                            .toList();
                      }

                      // Tambahkan item baru
                      cartItems.add(
                        CartItem(
                          imageUrl: widget.image_url,
                          name: widget.name,
                          price: double.parse(widget.price),
                          quantity: _quantity,
                        ),
                      );

                      // Simpan ulang keranjang ke SharedPreferences
                      prefs.setString(
                          'cartItems',
                          jsonEncode(
                              cartItems.map((item) => item.toJson()).toList()));

                      // Tampilkan pesan konfirmasi
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Produk berhasil ditambahkan ke keranjang'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF67C4A7),
                      minimumSize: const Size(150, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Masukkan ke keranjang'),
                  ),

                  const SizedBox(width: 16), // Spacing between buttons
                  // Buy Now Button
                  OutlinedButton(
                    onPressed: () {
                      // Logic to buy now
                    },
                    // ignore: sort_child_properties_last
                    child: const Text(
                      'Beli Sekarang',
                      style: TextStyle(color: Colors.black87), // Text color
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFFBFBFBF)), // Border color
                      backgroundColor: Colors.white, // Button background color
                      minimumSize: const Size(150, 48), // Button size
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
