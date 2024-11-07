import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pisang_meledak/customer/akun/akuncustomer.dart';
import 'package:pisang_meledak/customer/produk/detailproduk.dart';
import 'package:pisang_meledak/customer/produk/keranjang.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String userName;

  // ignore: use_super_parameters
  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;
  bool isError = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products on init
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/products');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> productList = jsonResponse['data'];

          setState(() {
            products = productList.map((product) {
              return {
                'id': product['id'],
                'image_url': product['image_url'],
                'name': product['name'],
                'price': double.parse(product['price']).toStringAsFixed(0),
                'description': product['description'],
              };
            }).toList();
            filteredProducts = products; // Initialize filteredProducts
            isLoading = false;
          });
        } else {
          setState(() {
            isError = true;
            isLoading = false;
          });
          // ignore: avoid_print
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
        // ignore: avoid_print
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      // ignore: avoid_print
      print('Exception: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        // Navigate to Orders Page (if you have one)
        break;
      case 2:
        // Navigate to History Page (if you have one)
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AkunCustomer()),
        );
        break;
    }
  }

  void _filterProducts(String query) {
    final filtered = products.where((product) {
      final nameLower = product['name'].toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredProducts = filtered; // Update filteredProducts
    });
  }

  Widget _buildProductCard(
      // ignore: non_constant_identifier_names
      String image_url,
      String name,
      String price,
      String description) {
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedPrice = formatter.format(int.tryParse(price) ?? 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduct(
              image_url: image_url,
              name: name,
              price: price,
              description: description,
              numberOfPurchases: 0,
            ),
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 900,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(image_url), // Use NetworkImage for URLs
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp. $formattedPrice',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
            // const Spacer(),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Action when 'Add to cart' button is pressed
            //     },
            //     child: const Text(
            //       'Add to cart',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFF67C4A7),
            //       minimumSize: const Size(double.infinity, 48),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Pisang Meledak",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.black),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : isError
              ? const Center(
                  child: Text('Error fetching products')) // Show error message
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: searchController,
                            onChanged: (query) {
                              _filterProducts(query);
                            },
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, size: 20),
                              hintText: 'Cari di sini',
                              hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                          ),
                        ),
                      ),
                      // Horizontal Image Slider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              List<String> imagePaths = [
                                'lib/assets/homepage1.png',
                                'lib/assets/homepage2.png',
                                'lib/assets/homepage3.png',
                                'lib/assets/homepage1.png',
                              ];

                              return Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(imagePaths[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: double.infinity, // Membuat lebar penuh
                          height: 110, // Mengubah tinggi menjadi 80
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF67C4A7)
                                    .withOpacity(0.8), // Membuat lebih deep
                                const Color(0xFF8BC34A)
                                    .withOpacity(0.8), // Membuat lebih deep
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            // Menggunakan Row untuk menempatkan ilustrasi dan teks
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // Menggunakan Expanded untuk menempatkan teks dan tombol di sisi kiri
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 10, 16, 0),
                                      child: Text(
                                        'Ayo Buruan Order Pisang Meledak!!',
                                        style: TextStyle(
                                          fontSize: 14, // Adjusted font size
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      child: Text(
                                        'Jln. Dr.Moh Hatta, Binuang Kp.Dalam',
                                        style: TextStyle(
                                          fontSize: 11, // Adjusted font size
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            4), // Spacing between the address and the button
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 8, 16, 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Open WhatsApp
                                          String url =
                                              "https://wa.me/6281372114967"; // Replace with your WhatsApp number
                                          // ignore: deprecated_member_use
                                          launch(url);
                                        },
                                        // ignore: sort_child_properties_last
                                        child: const Text(
                                          'Hubungi Sekarang',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                              0xFF2A7C5B), // Green color
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Menambahkan ilustrasi di sebelah kanan
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 16), // Spasi antara teks dan gambar
                                child: Image.asset(
                                  './lib/assets/ilustrasi.png',
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Produk Tersedia',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display filtered products in a grid view
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return _buildProductCard(
                              product['image_url'],
                              product['name'],
                              product['price'],
                              product['description'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_checkout_outlined),
              label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
