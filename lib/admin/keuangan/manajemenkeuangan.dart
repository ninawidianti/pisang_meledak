import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ManajemenKeuangan extends StatefulWidget {
  const ManajemenKeuangan({super.key});

  @override
  State<ManajemenKeuangan> createState() => _ManajemenKeuanganState();
}

class _ManajemenKeuanganState extends State<ManajemenKeuangan> {
  List<BarChartGroupData> _createSampleData() {
    final data = [
      RevenueData('Jan', 30),
      RevenueData('Feb', 70),
      RevenueData('Mar', 100),
      RevenueData('Apr', 50),
      RevenueData('May', 90),
    ];

    return data.asMap().entries.map((entry) {
      int index = entry.key;
      RevenueData revenue = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: revenue.amount.toDouble(),
            color: Colors.green,
            width: 20,
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Manajemen Keuangan",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pemasukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to income entry page
                },
                // ignore: sort_child_properties_last
                child: const Text('Tambah Pemasukan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A7C5B),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pengeluaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to expense entry page
                },
                // ignore: sort_child_properties_last
                child: const Text('Tambah Pengeluaran'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A7C5B),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Laporan Omset',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _createSampleData(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(months[value.toInt()]),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Riwayat Pemasukan dan Pengeluaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Replace with actual data from your records
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10, // Replace with your data count
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Pemasukan/Pengeluaran $index'),
                      subtitle: Text('Detail transaksi $index'),
                      trailing: Text('Rp ${index * 1000}'), // Example amount
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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

class RevenueData {
  final String month;
  final int amount;

  RevenueData(this.month, this.amount);
}
