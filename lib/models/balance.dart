class Balance {
  final double amount;
  final String status;
  final int daysUntilDue;

  Balance({
    required this.amount,
    required this.status,
    required this.daysUntilDue,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: (json['status'] ?? '').toString(),
      daysUntilDue: (json['daysUntilDue'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'status': status,
      'daysUntilDue': daysUntilDue,
    };
  }

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
