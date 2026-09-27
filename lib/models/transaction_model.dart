/// Transaction types supported by the app.
enum TransactionType { airtime, data, electricity, cable, education, walletFunding, withdrawal }

/// Transaction status.
enum TransactionStatus { pending, success, failed }

/// A single wallet/service transaction.
class TransactionModel {
  final String id;
  final TransactionType type;
  final String description;
  final double amount;
  final TransactionStatus status;
  final DateTime date;
  final String? reference;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.status,
    required this.date,
    this.reference,
  });

  String get typeLabel {
    switch (type) {
      case TransactionType.airtime:
        return 'Airtime';
      case TransactionType.data:
        return 'Data';
      case TransactionType.electricity:
        return 'Electricity';
      case TransactionType.cable:
        return 'Cable TV';
      case TransactionType.education:
        return 'Education';
      case TransactionType.walletFunding:
        return 'Wallet Funding';
      case TransactionType.withdrawal:
        return 'Withdrawal';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'description': description,
        'amount': amount,
        'status': status.name,
        'date': date.toIso8601String(),
        'reference': reference,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'] as String,
        type: TransactionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => TransactionType.airtime,
        ),
        description: json['description'] as String,
        amount: (json['amount'] as num).toDouble(),
        status: TransactionStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => TransactionStatus.success,
        ),
        date: DateTime.parse(json['date'] as String),
        reference: json['reference'] as String?,
      );
}
