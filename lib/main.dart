import 'package:flutter/material.dart';
//import 'package:pisang_meledak/admin/produk/listproduct.dart';
import 'splashscreen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan semua binding Flutter sudah diinisialisasi
  runApp(const MyApp()); // Pastikan untuk menambahkan 'const' jika MyApp adalah widget stateless
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Tambahkan konstruktor dengan key opsional

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.grey),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 248, 255, 253)),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 18),
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16),
          bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 14),
          titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
          titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      home: const SplashScreen(), 
    );
  }
}
