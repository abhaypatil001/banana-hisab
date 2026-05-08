import 'package:flutter/material.dart';
import '../models/party.dart';
import '../utils/constants.dart';

class PartyTile extends StatelessWidget {
  final Party party;
  final int transactionCount;
  final double totalAmount;
  final VoidCallback onTap;

  const PartyTile({
    super.key,
    required this.party,
    required this.transactionCount,
    required this.totalAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppConstants.partyColors[party.colorIndex],
          child: Text(
            party.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          party.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          party.phone ?? 'No phone',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$transactionCount txns',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '₹${totalAmount.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
