import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnexpectedExpenseScreen extends StatefulWidget {
  @override
  _UnexpectedExpenseScreenState createState() =>
      _UnexpectedExpenseScreenState();
}

class _UnexpectedExpenseScreenState extends State<UnexpectedExpenseScreen> {
  List<Map<String, dynamic>> unexpectedExpenses = [];
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  String _filter = "daily";

  @override
  void initState() {
    super.initState();
    _fetchUnexpectedExpenses();
  }

  Future<void> _fetchUnexpectedExpenses() async {
    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:8000/api/unexpected-expenses?filter=$_filter'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          unexpectedExpenses = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _addUnexpectedExpense() async {
    try {
      final expenseData = {
        'description': _descriptionController.text,
        'amount': double.parse(_amountController.text),
        'date': _dateController.text,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/unexpected-expenses'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(expenseData),
      );

      if (response.statusCode == 201) {
        setState(() {
          unexpectedExpenses.add(expenseData);
        });
        _clearForm();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Biaya Tidak Terduga berhasil ditambahkan')));
      } else {
        throw Exception('Gagal menambahkan data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _deleteUnexpectedExpense(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/unexpected-expenses/$id'),
      );

      if (response.statusCode == 200) {
        setState(() {
          unexpectedExpenses.removeWhere((expense) => expense['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Biaya Tidak Terduga berhasil dihapus')));
      } else {
        throw Exception('Gagal menghapus data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _clearForm() {
    _descriptionController.clear();
    _amountController.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biaya Tidak Terduga'),
        actions: [
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
              _fetchUnexpectedExpenses();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Deskripsi'),
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: 'Jumlah harga'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _dateController,
                      decoration:
                          InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
                      keyboardType: TextInputType.datetime,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addUnexpectedExpense,
                      child: Text('Tambahkan Biaya Tidak Terduga'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // List of Expenses
            ...unexpectedExpenses.map((expense) {
              return Card(
                child: ListTile(
                  title: Text(expense['description']),
                  subtitle: Text('Tanggal: ${expense['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Rp ${expense['amount']}'),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteUnexpectedExpense(expense['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}