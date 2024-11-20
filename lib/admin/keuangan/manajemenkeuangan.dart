import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManajemenKeuangan extends StatefulWidget {
  @override
  _ManajemenKeuanganState createState() => _ManajemenKeuanganState();
}

class _ManajemenKeuanganState extends State<ManajemenKeuangan> {
  String _filter = "daily";
  double _totalIncome = 0;
  double _totalExpense = 0;

  List<Map<String, dynamic>> incomeData = [];
  List<Map<String, dynamic>> expenseData = [];

  @override
  void initState() {
    super.initState();
    _fetchFinancialData();
  }

  Future<void> _fetchFinancialData() async {
    try {
      String baseUrl = 'http://127.0.0.1:8000/api'; // Ganti dengan URL API Anda
      final incomeResponse = await http.get(Uri.parse('$baseUrl/income?filter=$_filter'));
      final expenseResponse = await http.get(Uri.parse('$baseUrl/expenses?filter=$_filter'));

      if (incomeResponse.statusCode == 200 && expenseResponse.statusCode == 200) {
        final incomeJson = json.decode(incomeResponse.body);
        final expenseJson = json.decode(expenseResponse.body);

        setState(() {
          incomeData = List<Map<String, dynamic>>.from(incomeJson['data'] ?? []);
          expenseData = List<Map<String, dynamic>>.from(expenseJson['data'] ?? []);

          _totalIncome = incomeData.fold(0.0, (sum, item) {
            return sum + (double.tryParse(item['amount'].toString()) ?? 0.0);
          });

          _totalExpense = expenseData.fold(0.0, (sum, item) {
            return sum + (double.tryParse(item['amount'].toString()) ?? 0.0);
          });
        });
      } else {
        throw Exception('Gagal mengambil data dari server');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _getFilterLabel() {
    switch (_filter) {
      case "daily":
        return "Hari ini";
      case "weekly":
        return "Minggu ini";
      case "monthly":
        return "Bulan ini";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manajemen Keuangan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown untuk memilih filter
            DropdownButton<String>(
              value: _filter,
              items: [
                DropdownMenuItem(value: "daily", child: Text("Harian")),
                DropdownMenuItem(value: "weekly", child: Text("Mingguan")),
                DropdownMenuItem(value: "monthly", child: Text("Bulanan")),
              ],
              onChanged: (value) {
                setState(() {
                  _filter = value!;
                });
                _fetchFinancialData();
              },
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.arrow_downward, color: Colors.green, size: 30),
                        SizedBox(height: 5),
                        Text("Pemasukan"),
                        Text("Rp ${_totalIncome.toStringAsFixed(0)}"),
                        Text("(${_getFilterLabel()})", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.arrow_upward, color: Colors.red, size: 30),
                        SizedBox(height: 5),
                        Text("Pengeluaran"),
                        Text("Rp ${_totalExpense.toStringAsFixed(0)}"),
                        Text("(${_getFilterLabel()})", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.blue, size: 30),
                        SizedBox(height: 5),
                        Text("Saldo"),
                        Text("Rp ${(_totalIncome - _totalExpense).toStringAsFixed(0)}"),
                        Text("(${_getFilterLabel()})", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDataCard("Pemasukan", incomeData),
            SizedBox(height: 20),
            _buildDataCard("Pengeluaran", expenseData),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(String title, List<Map<String, dynamic>> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(item['description']),
                  subtitle: Text(item['date']),
                  trailing: Text("Rp ${item['amount']}"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
