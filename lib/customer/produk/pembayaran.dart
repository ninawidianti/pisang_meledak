import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PembayaranPage extends StatefulWidget {
  final List<String> productIds; // ID produk yang dipilih
  final List<int> quantities; // Jumlah produk yang dipilih
  final double totalPrice;

  const PembayaranPage({
    Key? key,
    required this.productIds,
    required this.quantities,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final formatter = NumberFormat('#,###', 'id_ID');
  String selectedPaymentMethod = 'Bank Transfer';
  String selectedDeliveryMethod = 'Diantar';
  TextEditingController addressController = TextEditingController();

  void createOrder() async {
    final url = Uri.parse('http://localhost:8000/api/orders'); // Ganti dengan URL yang sesuai

    final response = await http.post(url, body: {
      'product_id': json.encode(widget.productIds), // Mengirimkan daftar ID produk
      'quantity': json.encode(widget.quantities), // Mengirimkan daftar jumlah
    });

    print('Order Response status: ${response.statusCode}'); // Log status
    print('Order Response body: ${response.body}'); // Log body

    if (response.statusCode == 201) {
      final orderData = json.decode(response.body);
      final orderId = orderData['data']['id']; // Ambil ID order yang baru dibuat
      processPayment(orderId); // Panggil fungsi untuk memproses pembayaran
    } else {
      // Gagal membuat order
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal membuat order")));
    }
  }

  void processPayment(int orderId) async {
    final url = Uri.parse('http://localhost:8000/api/orders/$orderId/payment'); // Ganti dengan URL yang sesuai

    final response = await http.post(url, body: {
      'payment_method': selectedPaymentMethod,
      'delivery_method': selectedDeliveryMethod,
      'address': selectedDeliveryMethod == 'Diantar' ? addressController.text : '',
      'total_price': widget.totalPrice.toString(),
    });

    print('Payment Response status: ${response.statusCode}'); // Log status
    print('Payment Response body: ${response.body}'); // Log body

    if (response.statusCode == 201) {
      // Pembayaran berhasil
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 16),
              Text("Pesanan Anda akan segera diproses"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Pembayaran gagal
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal memproses pembayaran")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pesanan:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${formatter.format(widget.totalPrice)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: const Text('Bank Transfer'),
              value: 'Bank Transfer',
              groupValue: selectedPaymentMethod,
              onChanged: (value) => setState(() => selectedPaymentMethod = value.toString()),
            ),
            RadioListTile(
              title: const Text('Cash'),
              value: 'Cash',
              groupValue: selectedPaymentMethod,
              onChanged: (value) => setState(() => selectedPaymentMethod = value.toString()),
            ),
            const SizedBox(height: 20),
            if (selectedPaymentMethod == 'Bank Transfer')
              const Text(
                'Nomor Rekening: 123-456-7890 (Nama Pemilik)',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            const SizedBox(height: 20),
            const Text('Pilih Metode Pengiriman',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text('Diantar'),
              value: 'Diantar',
              groupValue: selectedDeliveryMethod,
              onChanged: (value) => setState(() => selectedDeliveryMethod = value.toString()),
            ),
            RadioListTile(
              title: const Text('Jemput Sendiri'),
              value: 'Jemput Sendiri',
              groupValue: selectedDeliveryMethod,
              onChanged: (value) => setState(() => selectedDeliveryMethod = value.toString()),
            ),
            if (selectedDeliveryMethod == 'Diantar')
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan alamat lengkap Anda',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createOrder, // Mengubah fungsi untuk membuat order
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF67C4A7),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Pesan Sekarang',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}