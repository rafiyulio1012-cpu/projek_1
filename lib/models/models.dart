class UserModel {
  String fullName;
  String email;
  String username;
  String phone;
  String password;

  UserModel({
    required this.fullName,
    required this.email,
    required this.username,
    required this.phone,
    required this.password,
  });
}

class TransactionModel {
  final String id;
  final double amount;
  final DateTime date;
  final String description;
  final String classification;
  final bool isIncome;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.classification,
    required this.isIncome,
  });

  double get signedAmount => isIncome ? amount : -amount;
}