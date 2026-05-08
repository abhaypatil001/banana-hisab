class Transaction {
  final String id;
  final String party;
  final DateTime date;
  final double grossWeight;
  final double rate;
  final String pattiMode; // 'rate' or 'fixed'
  final double pattiRate;
  final double pattiWeight;
  final double netWeight;
  final double dandaRate;
  final double dandaWeight;
  final double netWeightDanda;
  final double amount;
  final double commission;
  final double majuri;
  final double total;

  Transaction({
    required this.id,
    required this.party,
    required this.date,
    required this.grossWeight,
    required this.rate,
    required this.pattiMode,
    required this.pattiRate,
    required this.pattiWeight,
    required this.netWeight,
    required this.dandaRate,
    required this.dandaWeight,
    required this.netWeightDanda,
    required this.amount,
    required this.commission,
    required this.majuri,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'party': party,
      'date': date.toIso8601String(),
      'gross_weight': grossWeight,
      'rate': rate,
      'patti_mode': pattiMode,
      'patti_rate': pattiRate,
      'patti_weight': pattiWeight,
      'net_weight': netWeight,
      'danda_rate': dandaRate,
      'danda_weight': dandaWeight,
      'net_weight_danda': netWeightDanda,
      'amount': amount,
      'commission': commission,
      'majuri': majuri,
      'total': total,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      party: map['party'],
      date: DateTime.parse(map['date']),
      grossWeight: map['gross_weight'],
      rate: map['rate'],
      pattiMode: map['patti_mode'],
      pattiRate: map['patti_rate'],
      pattiWeight: map['patti_weight'],
      netWeight: map['net_weight'],
      dandaRate: map['danda_rate'],
      dandaWeight: map['danda_weight'],
      netWeightDanda: map['net_weight_danda'],
      amount: map['amount'],
      commission: map['commission'],
      majuri: map['majuri'],
      total: map['total'],
    );
  }
}
