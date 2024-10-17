import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pisang_meledak/customer/detailproduct.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = []; // List untuk menyimpan data produk

  @override
  void initState() {
    super.initState();
    fetchDummyProducts(); // Ambil data dummy saat widget diinisialisasi
  }

  void fetchDummyProducts() {
    // Data dummy produk
    products = [
      {
        'image': 'lib/assets/gambar1.jpg',
        'name': 'Pisang Meledak Matcha Coklat',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      {
        'image': 'lib/assets/gambar2.jpg',
        'name': 'Pisang Meledak Coklat',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      {
        'image': 'lib/assets/gambar3.jpg',
        'name': 'Kroket Pisang Keju Coklat',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      {
        'image': 'lib/assets/gambar4.jpg',
        'name': 'Pisang Meledak Keju Coklat',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      {
        'image': 'lib/assets/gambar5.jpg',
        'name': 'Pisang Meledak Tiramisu Coklat',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      {
        'image': 'lib/assets/gambar6.jpg',
        'name': 'Pisang Meledak Strawberry',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      {
        'image': 'lib/assets/gambar7.jpg',
        'name': 'Kroket Pisang Keju Tiramisu',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      {
        'image': 'lib/assets/gambar8.jpg',
        'name': 'Pisang Meledak Matcha',
        'price': '10000',
        'description':
            'Pisang Meledak adalah camilan lezat berbahan dasar pisang goreng renyah yang disajikan dengan berbagai topping menarik. Varian populer termasuk Coklat, yang dilapisi coklat leleh, Keju dengan taburan keju parut dan saus madu, serta Matcha Coklat yang menggabungkan coklat dan bubuk matcha. Ada juga Tiramisu yang disiram krim tiramisu, Vanilla yang disajikan dengan es krim, Karamel dengan saus karamel manis, dan Durian yang diisi daging durian creamy. Setiap varian menawarkan pengalaman rasa unik, menjadikan Pisang Meledak pilihan camilan yang sempurna untuk berbagai kesempatan.',
      },
      // Tambahkan produk lain sesuai kebutuhan
    ];

    setState(() {
      // Memperbarui UI dengan data dummy
    });
  }

  Widget _buildProductCard(
      String imageUrl, String name, String price, String description) {
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedPrice = formatter.format(int.tryParse(price) ?? 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduct(
              imageUrl: imageUrl,
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
          minHeight: 600, // Menentukan tinggi minimum card
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
            // Gambar produk
            Container(
              height: 150, // Menentukan tinggi gambar
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(imageUrl), // Menggunakan AssetImage
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow
                        .ellipsis, // Jika nama produk terlalu panjang
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp. $formattedPrice',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(), // Menambahkan Spacer untuk mengisi ruang yang tersisa
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: ElevatedButton(
                onPressed: () {
                  // Action when 'Add to cart' button is pressed
                },
                child: const Text(
                  'Add to cart',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67C4A7), // Ubah warna tombol
                  minimumSize:
                      const Size(double.infinity, 48), // Lebarkan tombol
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Sudut melengkung ringan
                  ),
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
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Pisang Meledak",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
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
                height: 40, // Mengatur tinggi TextField
                child: TextField(
                  style: const TextStyle(fontSize: 14), // Mengubah ukuran font
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.search, size: 20), // Ukuran ikon
                    hintText: 'Cari di sini',
                    hintStyle: const TextStyle(
                        fontSize: 14, color: Colors.grey), // Ukuran hint text
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5), // Mengatur padding di dalam TextField
                  ),
                ),
              ),
            ),

            // Bagian untuk menampilkan gambar secara horizontal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4, // Jumlah gambar
                  itemBuilder: (context, index) {
                    List<String> imagePaths = [
                      'lib/assets/homepage1.png',
                      'lib/assets/homepage2.png',
                      'lib/assets/homepage3.png',
                      'lib/assets/homepage1.png',
                    ];

                    return Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 350, // Tentukan lebar yang sama untuk semua gambar
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
                height: 100, // Mengubah tinggi menjadi 80
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
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                            child: Column(
                              children: [
                                Text(
                                  'Ayo Buruan Order Pisang Meledak!!',
                                  style: TextStyle(
                                    fontSize:
                                        18, // Mengurangi ukuran font agar sesuai
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                 Text(
                                  'Jln. Dr.Moh Hatta, Binuang Kp.Dalam',
                                  style: TextStyle(
                                    fontSize:
                                        14, // Mengurangi ukuran font agar sesuai
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Tambahkan kode untuk membuka WhatsApp
                                String url =
                                    "https://wa.me/6281372114967"; // Ganti dengan nomor WhatsApp Anda
                                launch(url);
                              },
                              child: const Text(
                                'Hubungi Sekarang',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF2A7C5B), // Menggunakan warna hijau
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
                        './lib/assets/ilustrasi.png', // Ganti dengan path gambar Anda
                        height: 70, // Tinggi gambar yang lebih besar
                        width: 70, // Lebar gambar yang lebih besar, jika perlu
                        fit: BoxFit.cover, // Mengatur gambar agar sesuai
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: products.isEmpty
                  ? Center(
                      child: const Text(
                          'No products available')) // Jika produk kosong
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length, // Berdasarkan jumlah produk
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 produk per baris
                        childAspectRatio: 0.65, // Atur rasio aspek grid
                        crossAxisSpacing: 16, // Jarak antar kolom
                        mainAxisSpacing: 16, // Jarak antar baris
                      ),
                      itemBuilder: (context, index) {
                        return _buildProductCard(
                          products[index]['image'],
                          products[index]['name'],
                          products[index]['price'],
                          products[index]['description'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_checkout_outlined), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
