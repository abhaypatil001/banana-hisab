class AppSettings {
  final double defaultPattiRate;
  final double standardDandaRate;
  final double highDandaRate;
  final double commission;
  final double majuri;

  AppSettings({
    required this.defaultPattiRate,
    required this.standardDandaRate,
    required this.highDandaRate,
    required this.commission,
    required this.majuri,
  });

  factory AppSettings.defaults() {
    return AppSettings(
      defaultPattiRate: 7.5,
      standardDandaRate: 6.0,
      highDandaRate: 7.0,
      commission: 10.0,
      majuri: 30.0,
    );
  }

  Map<String, String> toMap() {
    return {
      'defaultPattiRate': defaultPattiRate.toString(),
      'standardDandaRate': standardDandaRate.toString(),
      'highDandaRate': highDandaRate.toString(),
      'commission': commission.toString(),
      'majuri': majuri.toString(),
    };
  }

  factory AppSettings.fromMap(Map<String, String> map) {
    return AppSettings(
      defaultPattiRate: double.tryParse(map['defaultPattiRate'] ?? '2.0') ?? 2.0,
      standardDandaRate: double.tryParse(map['standardDandaRate'] ?? '2.0') ?? 2.0,
      highDandaRate: double.tryParse(map['highDandaRate'] ?? '3.0') ?? 3.0,
      commission: double.tryParse(map['commission'] ?? '1.0') ?? 1.0,
      majuri: double.tryParse(map['majuri'] ?? '1.0') ?? 1.0,
    );
  }
}
