import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pisang_meledak/admin/produk/addproduct.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/products');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> productList = jsonResponse['data'];

          setState(() {
            products = productList.map((product) {
              return {
                'id': product['id'],
                'image_url': product[
                    'image_url'], // Mengambil URL gambar dari respons API
                'name': product['name'],
                'price': double.parse(product['price']).toStringAsFixed(0),
                'description': product['description'],
              };
            }).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isError = true;
            isLoading = false;
          });
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      print('Exception: $e');
    }
  }

  void _editProduct(int index) {
    print('Edit product at index: $index');
  }

  void _deleteProduct(int index) {
    final productId = products[index]['id'];
    final url = Uri.parse('http://127.0.0.1:8000/api/products/$productId');

    http.delete(url).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          products.removeAt(index);
        });
      } else {
        print('Failed to delete the product');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void _addProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProduct()),
    ).then((_) => fetchProducts());
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedPrice =
        formatter.format(int.tryParse(product['price']) ?? 0);
    debugPrint('foto');
    debugPrint(product['image_url']);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5), // Jarak antar kartu
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Menjaga semua elemen di atas
          children: [
            // Gambar
            Container(
              height: 80, // Ukuran gambar
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  //product['image_url'],
                  //'./lib/assets/gambar4.jpg',
                  'https://assets-a1.kompasiana.com/items/album/2023/06/12/nasi-goreng-indonesian-fried-rice-sugar-spice-more-6486e9184d498a53171a2c62.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12), // Jarak antara gambar dan teks
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Harga produk
                    Text(
                      'Rp. $formattedPrice',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Deskripsi produk
                    Text(
                      product['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tombol Edit dan Delete
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Menjadikan lebar row sesedikit mungkin
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFF67C4A7)),
                            onPressed: () => _editProduct(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(index),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFF67C4A7),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? const Center(child: Text('Failed to load products'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(products[index], index);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF67C4A7),
      ),
    );
  }
}
