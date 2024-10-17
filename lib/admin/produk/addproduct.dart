import 'dart:io'; // Import for File (only for non-web)
import 'package:flutter/foundation.dart'; // Import for platform checking
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'listproduct.dart'; // Import your ListProduct screen

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _errorMessage = '';
  XFile? _image; // Variable to hold the selected image

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    _image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {}); // Refresh the UI to show the selected image
  }

  void _saveProduct() {
    // Logic to save the product
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _image == null) {
      setState(() {
        _errorMessage = 'Semua field harus diisi!';
      });
    } else {
      setState(() {
        _errorMessage = '';
      });

      // Implement save logic here (e.g., send to API or save locally)
      print('Product saved: ${_nameController.text}, ${_priceController.text}, ${_descriptionController.text}, Image: ${_image!.path}');

      // Clear the input fields after saving
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _image = null;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Produk berhasil ditambahkan!'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate back to the ListProduct screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ListProduct()),
        (route) => false, // Remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: const Color(0xFF67C4A7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Nama Produk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Nama Produk',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Harga',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Harga',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Deskripsi',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gambar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Text(
                            'Pilih Gambar',
                            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: kIsWeb
                              ? Image.network(_image!.path, fit: BoxFit.cover) // For Web
                              : Image.file(File(_image!.path), fit: BoxFit.cover), // For mobile or desktop
                        ),
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  child: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF67C4A7), // Button color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
