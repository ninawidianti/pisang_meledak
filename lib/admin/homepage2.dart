import 'package:flutter/material.dart';
import 'package:pisang_meledak/admin/keuangan/manajemenkeuangan.dart';
import 'package:pisang_meledak/admin/pengguna/listpengguna.dart';
import 'package:pisang_meledak/admin/pesanan/riwayatpesanan.dart';
import 'package:pisang_meledak/admin/produk/listproduct.dart';
import 'package:pisang_meledak/admin/stokbahan/liststokbahan.dart';
import 'package:pisang_meledak/admin/pesanan/listpesanan.dart';
import 'package:pisang_meledak/customer/akun/akuncustomer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage2 extends StatefulWidget {
  final String userName;

  // ignore: use_super_parameters
  const HomePage2({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ListPesananPage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RiwayatPage()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountPage()));
        break;
    }
  }

  Widget _buildCategoryIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Menambahkan aksi saat ditekan
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(
                12.0), // Mengubah padding untuk tampilan lebih baik
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
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
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.shopping_cart,
          //     color: Colors.black,
          //   ),
          // ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 20),
                    hintText: 'Cari di sini',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF67C4A7).withOpacity(0.8),
                      const Color(0xFF8BC34A).withOpacity(0.8),
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
                            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              'Jln. Dr.Moh Hatta, Binuang Kp.Dalam',
                              style: TextStyle(
                                fontSize: 14, // Adjusted font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Text(
                              'Nomor WhatsApp yang di gunakan sekarang :',
                              style: TextStyle(
                                fontSize: 10, // Adjusted font size
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  4), // Spacing between the address and the button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                                '+6281372114967',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A7C5B)
                                    .withOpacity(0.5), // Green color
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
                'Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryIcon(Icons.store, 'Produk', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListProduct()),
                    );
                  }),
                  // _buildCategoryIcon(Icons.receipt_long, 'Pesanan', () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ListPesananPage()),
                  //   );
                  // }),
                  _buildCategoryIcon(Icons.inventory, 'Bahan Baku', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListStokBahan()),
                    );
                  }),
                  _buildCategoryIcon(Icons.person_search, 'Pengguna', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListPengguna()),
                    );
                  }),
                  _buildCategoryIcon(Icons.account_balance_wallet, 'Keuangan',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManajemenKeuangan()),
                    );
                  }),
                ],
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
