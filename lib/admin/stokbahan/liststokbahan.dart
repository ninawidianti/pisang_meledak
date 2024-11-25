// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pisang_meledak/admin/stokbahan/addstokbahan.dart';

// ignore: use_key_in_widget_constructors
class ListStokBahan extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ListStokBahanState createState() => _ListStokBahanState();
}

class _ListStokBahanState extends State<ListStokBahan> {
  List<Map<String, dynamic>> stokBahan = [];

  // Function to fetch stock data from API
  Future<void> fetchStokBahan() async {
    final url = Uri.parse('http://localhost:8000/api/stokbahan');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = json.decode(response.body)['data'];
        setState(() {
          stokBahan = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Function to delete stock item
  Future<void> deleteStokBahan(int id) async {
    final url = Uri.parse('http://localhost:8000/api/stokbahan/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          stokBahan.removeWhere((item) => item['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stok bahan berhasil dihapus')),
        );
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print('Error deleting data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus stok bahan')),
      );
    }
  }

  // Function to edit stock item
  Future<void> editStokBahan(Map<String, dynamic> updatedItem) async {
    final url =
        Uri.parse('http://localhost:8000/api/stokbahan/${updatedItem['id']}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedItem),
      );
      if (response.statusCode == 200) {
        final updatedIndex =
            stokBahan.indexWhere((item) => item['id'] == updatedItem['id']);
        if (updatedIndex != -1) {
          setState(() {
            stokBahan[updatedIndex] = updatedItem;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stok bahan berhasil diperbarui')),
        );
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print('Error updating data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui stok bahan')),
      );
    }
  }

  // Function to show edit form dialog
  void showEditDialog(Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name']);
    final stockQuantityController =
        TextEditingController(text: item['stock_quantity'].toString());
    final unitController = TextEditingController(text: item['unit']);
    final purchasePriceController =
        TextEditingController(text: item['purchase_price'].toString());
    final supplierController = TextEditingController(text: item['supplier']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Stok Bahan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: stockQuantityController,
                decoration: const InputDecoration(labelText: 'Jumlah Stok'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Satuan'),
              ),
              TextField(
                controller: purchasePriceController,
                decoration: const InputDecoration(labelText: 'Harga Pembelian'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: supplierController,
                decoration: const InputDecoration(labelText: 'Pemasok'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final updatedItem = {
                  'id': item['id'],
                  'name': nameController.text,
                  'stock_quantity': int.parse(stockQuantityController.text),
                  'unit': unitController.text,
                  'purchase_price': double.parse(purchasePriceController.text),
                  'supplier': supplierController.text,
                };
                editStokBahan(updatedItem);
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchStokBahan(); // Fetch data on app start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Bahan', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xFF67C4A7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Untuk kembali ke halaman sebelumnya
          },
        ),
      ),
      body: stokBahan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: stokBahan.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      stokBahan[index]['name'],
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
                        Text(
                          'Stok: ${stokBahan[index]['stock_quantity']} ${stokBahan[index]['unit']}',
                          style: const TextStyle(color: Color(0xFF6C757D)),
                        ),
                        Text(
                          'Harga: Rp ${stokBahan[index]['purchase_price']}/${stokBahan[index]['unit']}',
                          style: const TextStyle(color: Color(0xFF6C757D)),
                        ),
                        Text(
                          'Pemasok: ${stokBahan[index]['supplier']}',
                          style: const TextStyle(color: Color(0xFF6C757D)),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () {
                            showEditDialog(stokBahan[index]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            deleteStokBahan(stokBahan[index]['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStokBahan()),
          );
        },
        backgroundColor: const Color(0xFF67C4A7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
