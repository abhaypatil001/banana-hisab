import 'package:flutter/material.dart';
import '../services/calculation_service.dart';

class CalculatorProvider with ChangeNotifier {
  double _grossWeight = 0;
  double _rate = 0;
  String _party = '';
  String _pattiMode = 'rate'; // 'rate' or 'fixed'
  double _pattiValue = 2.0;
  double _dandaRate = 2.0;
  double _commissionRate = 1.0;
  double _majuriRate = 1.0;

  CalculationResult? _result;

  double get grossWeight => _grossWeight;
  double get rate => _rate;
  String get party => _party;
  String get pattiMode => _pattiMode;
  double get pattiValue => _pattiValue;
  double get dandaRate => _dandaRate;
  double get commissionRate => _commissionRate;
  double get majuriRate => _majuriRate;
  CalculationResult? get result => _result;

  void setGrossWeight(double value) {
    _grossWeight = value;
    _calculate();
  }

  void setRate(double value) {
    _rate = value;
    _calculate();
  }

  void setParty(String value) {
    _party = value;
    notifyListeners();
  }

  void setPattiMode(String mode) {
    _pattiMode = mode;
    _calculate();
  }

  void setPattiValue(double value) {
    _pattiValue = value;
    _calculate();
  }

  void setDandaRate(double value) {
    _dandaRate = value;
    _calculate();
  }

  void setCommissionRate(double value) {
    _commissionRate = value;
    _calculate();
  }

  void setMajuriRate(double value) {
    _majuriRate = value;
    _calculate();
  }

  void _calculate() {
    if (_grossWeight > 0 && _rate > 0) {
      _result = CalculationService.calculate(
        grossWeight: _grossWeight,
        rate: _rate,
        pattiMode: _pattiMode,
        pattiValue: _pattiValue,
        dandaRate: _dandaRate,
        commissionRate: _commissionRate,
        majuriRate: _majuriRate,
      );
    } else {
      _result = null;
    }
    notifyListeners();
  }

  void reset() {
    _grossWeight = 0;
    _rate = 0;
    _party = '';
    _result = null;
    notifyListeners();
  }

  void loadTransaction({
    required double grossWeight,
    required double rate,
    required String party,
    required String pattiMode,
    required double pattiValue,
    required double dandaRate,
  }) {
    _grossWeight = grossWeight;
    _rate = rate;
    _party = party;
    _pattiMode = pattiMode;
    _pattiValue = pattiValue;
    _dandaRate = dandaRate;
    _calculate();
  }
}
