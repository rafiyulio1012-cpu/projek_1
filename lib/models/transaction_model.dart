class Transaction {
  final String date;
  final String description;
  final String type; // 'Pemasukan' atau 'Pengeluaran'
  final double amount;

  Transaction({
    required this.date,
    required this.description,
    required this.type,
    required this.amount,
  });
}