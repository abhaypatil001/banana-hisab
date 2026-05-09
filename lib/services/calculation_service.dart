class CalculationResult {
  final double pattiWeight;
  final double netWeight;
  final double dandaWeight;
  final double netWeightDanda;
  final double amount;
  final double commission;
  final double majuri;
  final double total;

  CalculationResult({
    required this.pattiWeight,
    required this.netWeight,
    required this.dandaWeight,
    required this.netWeightDanda,
    required this.amount,
    required this.commission,
    required this.majuri,
    required this.total,
  });
}

class CalculationService {
  static CalculationResult calculate({
    required double grossWeight,
    required double rate,
    required String pattiMode,
    required double pattiValue,
    required double dandaRate,
    required double commissionRate,
    required double majuriRate,
  }) {
    // Calculate patti weight
    double pattiWeight;
    if (pattiMode == 'rate') {
      pattiWeight = (grossWeight * pattiValue) / 100;
    } else {
      pattiWeight = pattiValue;
    }

    // Calculate net weight
    double netWeight = grossWeight - pattiWeight;

    // Calculate danda weight (Kg per QTL formula)
    double dandaWeight = (netWeight / 100) * dandaRate;

    // Calculate net weight with danda
    double netWeightDanda = netWeight + dandaWeight;

    // Calculate amount
    double amount = netWeightDanda * rate;

    // Calculate commission and majuri
    double commission = netWeightDanda * commissionRate;
    double majuri = netWeightDanda * majuriRate;

    // Calculate total
    double total = amount + commission + majuri;

    return CalculationResult(
      pattiWeight: pattiWeight,
      netWeight: netWeight,
      dandaWeight: dandaWeight,
      netWeightDanda: netWeightDanda,
      amount: amount,
      commission: commission,
      majuri: majuri,
      total: total,
    );
  }
}
