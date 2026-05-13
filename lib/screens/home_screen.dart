import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/calculator_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/party_provider.dart';
import '../providers/settings_provider.dart';
import '../models/transaction.dart';
import '../services/pdf_service.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/input_card.dart';
import '../widgets/result_card.dart';
import 'history_screen.dart';
import 'parties_screen.dart';
import 'profit_screen.dart';
import 'more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final _grossWeightController = TextEditingController();
  final _rateController = TextEditingController();
  final _partyController = TextEditingController();
  final _pattiValueController = TextEditingController();
  
  String _dandaType = 'Standard';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsProvider>().settings;
      _pattiValueController.text = settings.defaultPattiRate.toString();
      context.read<CalculatorProvider>().setPattiValue(settings.defaultPattiRate);
      context.read<CalculatorProvider>().setDandaRate(settings.standardDandaRate);
      context.read<CalculatorProvider>().setCommissionRate(settings.commission);
      context.read<CalculatorProvider>().setMajuriRate(settings.majuri);
      setState(() => _dandaType = 'Standard');
    });
  }

  @override
  void dispose() {
    _grossWeightController.dispose();
    _rateController.dispose();
    _partyController.dispose();
    _pattiValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionCount = context.watch<TransactionProvider>().transactions.length;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildCalculatorScreen(),
          const HistoryScreen(),
          const PartiesScreen(),
          const ProfitScreen(),
          const MoreScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        transactionCount: transactionCount,
      ),
    );
  }

  Widget _buildCalculatorScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text('Banana Hisab'),
          ],
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<CalculatorProvider>(
        builder: (context, calculator, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InputCard(
                          label: 'Gross Weight (QTL)',
                          hint: 'Enter weight',
                          controller: _grossWeightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            calculator.setGrossWeight(double.tryParse(value) ?? 0);
                          },
                        ),
                        const SizedBox(height: 16),
                        InputCard(
                          label: 'Rate (₹/QTL)',
                          hint: 'Enter rate',
                          controller: _rateController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            calculator.setRate(double.tryParse(value) ?? 0);
                          },
                        ),
                        const SizedBox(height: 16),
                        InputCard(
                          label: 'Party Name',
                          hint: 'Enter party name',
                          controller: _partyController,
                          onChanged: (value) {
                            calculator.setParty(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patti Mode',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(value: 'rate', label: Text('Rate/QTL')),
                                ButtonSegment(value: 'fixed', label: Text('Fixed QTL Cut')),
                              ],
                              selected: {calculator.pattiMode},
                              onSelectionChanged: (Set<String> selection) {
                                calculator.setPattiMode(selection.first);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InputCard(
                          label: calculator.pattiMode == 'rate' ? 'Patti Rate (%)' : 'Fixed QTL Cut',
                          hint: 'Enter value',
                          controller: _pattiValueController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            calculator.setPattiValue(double.tryParse(value) ?? 0);
                          },
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Danda Rate',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Consumer<SettingsProvider>(
                              builder: (context, settings, _) {
                                return DropdownButtonFormField<String>(
                                  value: _dandaType,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Standard', child: Text('Standard')),
                                    DropdownMenuItem(value: 'High', child: Text('High')),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _dandaType = value!);
                                    final rate = value == 'Standard' 
                                        ? settings.settings.standardDandaRate 
                                        : settings.settings.highDandaRate;
                                    calculator.setDandaRate(rate);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (calculator.result != null) ...[
                  ResultCard(
                    result: calculator.result!,
                    grossWeight: calculator.grossWeight,
                    rate: calculator.rate,
                    pattiMode: calculator.pattiMode,
                    pattiValue: calculator.pattiValue,
                    dandaRate: calculator.dandaRate,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            calculator.reset();
                            _grossWeightController.clear();
                            _rateController.clear();
                            _partyController.clear();
                            final settings = context.read<SettingsProvider>().settings;
                            _pattiValueController.text = settings.defaultPattiRate.toString();
                            calculator.setPattiValue(settings.defaultPattiRate);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showShareOptions(context, calculator),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.grey[700],
                          ),
                          child: const Text('Share'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _saveTransaction(context, calculator),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.green[700],
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveTransaction(BuildContext context, CalculatorProvider calculator) async {
    if (calculator.result == null || calculator.party.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      party: calculator.party,
      date: DateTime.now(),
      grossWeight: calculator.grossWeight,
      rate: calculator.rate,
      pattiMode: calculator.pattiMode,
      pattiRate: calculator.pattiValue,
      pattiWeight: calculator.result!.pattiWeight,
      netWeight: calculator.result!.netWeight,
      dandaRate: calculator.dandaRate,
      dandaWeight: calculator.result!.dandaWeight,
      netWeightDanda: calculator.result!.netWeightDanda,
      amount: calculator.result!.amount,
      commission: calculator.result!.commission,
      majuri: calculator.result!.majuri,
      total: calculator.result!.total,
    );

    await context.read<TransactionProvider>().addTransaction(transaction);
    await context.read<PartyProvider>().getOrCreateParty(calculator.party);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved successfully')),
      );
      calculator.reset();
      _grossWeightController.clear();
      _rateController.clear();
      _partyController.clear();
      final settings = context.read<SettingsProvider>().settings;
      _pattiValueController.text = settings.defaultPattiRate.toString();
      calculator.setPattiValue(settings.defaultPattiRate);
    }
  }

  void _showShareOptions(BuildContext context, CalculatorProvider calculator) {
    if (calculator.result == null) return;

    final transaction = Transaction(
      id: 'temp',
      party: calculator.party.isEmpty ? 'Party' : calculator.party,
      date: DateTime.now(),
      grossWeight: calculator.grossWeight,
      rate: calculator.rate,
      pattiMode: calculator.pattiMode,
      pattiRate: calculator.pattiValue,
      pattiWeight: calculator.result!.pattiWeight,
      netWeight: calculator.result!.netWeight,
      dandaRate: calculator.dandaRate,
      dandaWeight: calculator.result!.dandaWeight,
      netWeightDanda: calculator.result!.netWeightDanda,
      amount: calculator.result!.amount,
      commission: calculator.result!.commission,
      majuri: calculator.result!.majuri,
      total: calculator.result!.total,
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Share as Text'),
              onTap: () {
                Navigator.pop(context);
                Share.share(PdfService.generateTextReceipt(transaction));
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Share as PDF'),
              onTap: () {
                Navigator.pop(context);
                PdfService.generateAndSharePdf(transaction);
              },
            ),
          ],
        ),
      ),
    );
  }
}
