import 'package:flutter/material.dart';
import '../services/calculation_service.dart';
import '../utils/number_utils.dart';

class ResultCard extends StatelessWidget {
  final CalculationResult result;
  final double grossWeight;
  final double rate;
  final String pattiMode;
  final double pattiValue;
  final double dandaRate;

  const ResultCard({
    super.key,
    required this.result,
    required this.grossWeight,
    required this.rate,
    required this.pattiMode,
    required this.pattiValue,
    required this.dandaRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRow('Gross Weight', '${NumberUtils.formatWeight(grossWeight)} QTL'),
                _buildRow('Patti (${pattiMode == 'rate' ? '$pattiValue%' : 'Fixed'})', '${NumberUtils.formatWeight(result.pattiWeight)} QTL'),
                _buildRow('Net Weight', '${NumberUtils.formatWeight(result.netWeight)} QTL', isHighlighted: true),
                const Divider(),
                _buildRow('Danda ($dandaRate Kg/QTL)', '${NumberUtils.formatWeight(result.dandaWeight)} QTL'),
                _buildRow('Net Weight with Danda', '${NumberUtils.formatWeight(result.netWeightDanda)} QTL', isHighlighted: true),
                const Divider(),
                _buildRow('Rate', '${NumberUtils.formatCurrency(rate)}/QTL'),
                _buildRow('Amount', NumberUtils.formatCurrency(result.amount)),
                _buildRow('Commission', NumberUtils.formatCurrency(result.commission)),
                _buildRow('Majuri', NumberUtils.formatCurrency(result.majuri)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[600]!, Colors.green[700]!],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  NumberUtils.formatCurrency(result.total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  NumberUtils.numberToWords(result.total),
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isHighlighted ? Colors.green[700] : Colors.grey[700],
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.green[700] : Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
