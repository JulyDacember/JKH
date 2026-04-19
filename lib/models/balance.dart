class Balance {
  final double amount;
  final String status;
  final int daysUntilDue;

  Balance({
    required this.amount,
    required this.status,
    required this.daysUntilDue,
  });

  String get formattedAmount => amount.toStringAsFixed(2);
  String get dueText {
    if (daysUntilDue < 0) {
      return 'Due: ${daysUntilDue.abs()} days ago';
    } else if (daysUntilDue == 0) {
      return 'Due: today';
    } else {
      return 'Due: in $daysUntilDue days';
    }
  }
}

