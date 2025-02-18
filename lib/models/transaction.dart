class Transaction {
  final String description;
  final double amount;
  final bool isIncome; // true para ingreso, false para egreso
  final DateTime date;

  Transaction({
    required this.description,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}
