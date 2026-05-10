import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'report_screen.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  // Simpan list transaksi di sini agar data menetap saat pindah halaman (sementara)
  final List<Transaction> _allTransactions = [];

  final _dateController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'Pemasukan';

  void _submitData() {
    if (_dateController.text.isEmpty || _amountController.text.isEmpty) return;

    final newTx = Transaction(
      date: _dateController.text,
      description: _descController.text,
      type: _selectedType,
      amount: double.parse(_amountController.text),
    );

    setState(() {
      _allTransactions.add(newTx);
    });

    // Pindah ke halaman laporan sambil membawa data list transaksi
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportScreen(transactions: _allTransactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _dateController, decoration: InputDecoration(labelText: 'Tanggal (Contoh: 08/05/2026)')),
            TextField(controller: _descController, decoration: InputDecoration(labelText: 'Keterangan')),
            DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              items: ['Pemasukan', 'Pengeluaran'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Jumlah Nominal'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Tambah Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}