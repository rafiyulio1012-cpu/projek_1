import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class ReportScreen extends StatelessWidget {
  final List<Transaction> transactions;

  ReportScreen({required this.transactions});

  @override
  Widget build(BuildContext context) {
    double totalMasuk = 0;
    double totalKeluar = 0;
    double currentSaldo = 0;

    return Scaffold(
      appBar: AppBar(title: Text('Laporan Keuangan')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Keterangan')),
                  DataColumn(label: Text('Pemasukan')),
                  DataColumn(label: Text('Pengeluaran')),
                  DataColumn(label: Text('Saldo')),
                ],
                rows: transactions.map((tx) {
                  double masuk = tx.type == 'Pemasukan' ? tx.amount : 0;
                  double keluar = tx.type == 'Pengeluaran' ? tx.amount : 0;
                  
                  totalMasuk += masuk;
                  totalKeluar += keluar;
                  currentSaldo = totalMasuk - totalKeluar;

                  return DataRow(cells: [
                    DataCell(Text(tx.date)),
                    DataCell(Text(tx.description)),
                    DataCell(Text(masuk > 0 ? masuk.toString() : '-')),
                    DataCell(Text(keluar > 0 ? keluar.toString() : '-')),
                    DataCell(Text(currentSaldo.toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
          // Kotak Ringkasan Saldo Akhir
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blueGrey[50],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total Pemasukan:'), Text('Rp $totalMasuk', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total Pengeluaran:'), Text('Rp $totalKeluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
                ),
                Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SALDO AKHIR:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Rp ${totalMasuk - totalKeluar}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}