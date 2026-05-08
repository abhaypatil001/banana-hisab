import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/party_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/party_tile.dart';

class PartiesScreen extends StatefulWidget {
  const PartiesScreen({super.key});

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Parties'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search parties',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: Consumer2<PartyProvider, TransactionProvider>(
              builder: (context, partyProvider, transactionProvider, _) {
                final parties = partyProvider.searchParties(_searchQuery);
                
                if (parties.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No parties found',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a party using the + button',
                          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: parties.length,
                  itemBuilder: (context, index) {
                    final party = parties[index];
                    final partyTransactions = transactionProvider.transactions
                        .where((t) => t.party == party.name)
                        .toList();
                    final totalAmount = partyTransactions.fold<double>(
                      0,
                      (sum, t) => sum + t.total,
                    );

                    return PartyTile(
                      party: party,
                      transactionCount: partyTransactions.length,
                      totalAmount: totalAmount,
                      onTap: () => _showPartyDetails(context, party, partyTransactions),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPartyDialog(context),
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPartyDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Party'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Party Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone (Optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter party name')),
                );
                return;
              }

              context.read<PartyProvider>().addParty(
                nameController.text.trim(),
                phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
              );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Party added successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showPartyDetails(BuildContext context, party, transactions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                party.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (party.phone != null)
                Text(
                  party.phone!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              const SizedBox(height: 20),
              Text(
                'Transactions (${transactions.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Text(
                          'No transactions yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return ListTile(
                            title: Text('₹${transaction.total.toStringAsFixed(2)}'),
                            subtitle: Text('${transaction.netWeightDanda.toStringAsFixed(2)} QTL'),
                            trailing: Text(
                              '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
