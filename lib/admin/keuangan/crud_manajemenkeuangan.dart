// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: use_key_in_widget_constructors
class UnexpectedExpenseScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
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
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biaya Tidak Terduga berhasil dihapus')));
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
        title: const Text('Biaya Tidak Terduga'),
        actions: [
          DropdownButton<String>(
            value: _filter,
            items: const [
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
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Jumlah harga'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _dateController,
                      decoration:
                          const InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addUnexpectedExpense,
                      child: const Text('Tambahkan Biaya Tidak Terduga'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteUnexpectedExpense(expense['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            // ignore: unnecessary_to_list_in_spreads
            }).toList(),
          ],
        ),
      ),
    );
  }
}