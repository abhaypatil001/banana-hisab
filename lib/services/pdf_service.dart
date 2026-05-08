import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/transaction.dart';
import '../utils/number_utils.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart' as app_date;

class PdfService {
  static Future<void> generateAndSharePdf(Transaction transaction) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfColor.fromHex('#4CAF50'), PdfColor.fromHex('#66BB6A')],
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          AppConstants.appName,
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Receipt',
                          style: const pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        app_date.DateUtils.formatDate(transaction.date),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#4CAF50'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Party name
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Text(
                  'Party: ${transaction.party}',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              // Calculation table
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Table.fromTextArray(
                  border: pw.TableBorder.all(color: PdfColors.grey400),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellAlignment: pw.Alignment.centerLeft,
                  data: [
                    ['Description', 'Value'],
                    ['Gross Weight', '${NumberUtils.formatWeight(transaction.grossWeight)} QTL'],
                    ['Patti (${transaction.pattiMode == 'rate' ? '${transaction.pattiRate}%' : 'Fixed'})', '${NumberUtils.formatWeight(transaction.pattiWeight)} QTL'],
                    ['Net Weight', '${NumberUtils.formatWeight(transaction.netWeight)} QTL'],
                    ['Danda (${transaction.dandaRate}%)', '${NumberUtils.formatWeight(transaction.dandaWeight)} QTL'],
                    ['Net Weight with Danda', '${NumberUtils.formatWeight(transaction.netWeightDanda)} QTL'],
                    ['Rate', '${NumberUtils.formatCurrency(transaction.rate)}/QTL'],
                    ['Amount', NumberUtils.formatCurrency(transaction.amount)],
                    ['Commission', NumberUtils.formatCurrency(transaction.commission)],
                    ['Majuri', NumberUtils.formatCurrency(transaction.majuri)],
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Total
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfColor.fromHex('#4CAF50'), PdfColor.fromHex('#66BB6A')],
                  ),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Amount',
                      style: const pw.TextStyle(fontSize: 14, color: PdfColors.white),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      NumberUtils.formatCurrency(transaction.total),
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      NumberUtils.numberToWords(transaction.total),
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.Spacer(),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  children: [
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Powered by ${AppConstants.developerName}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      '${AppConstants.developerPhone} | ${AppConstants.developerEmail}',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'receipt_${transaction.party}_${transaction.date.millisecondsSinceEpoch}.pdf');
  }

  static String generateTextReceipt(Transaction transaction) {
    return '''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
${AppConstants.appName.toUpperCase()}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Party: ${transaction.party}
Date: ${app_date.DateUtils.formatDate(transaction.date)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CALCULATION DETAILS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Gross Weight: ${NumberUtils.formatWeight(transaction.grossWeight)} QTL
Patti (${transaction.pattiMode == 'rate' ? '${transaction.pattiRate}%' : 'Fixed'}): ${NumberUtils.formatWeight(transaction.pattiWeight)} QTL
Net Weight: ${NumberUtils.formatWeight(transaction.netWeight)} QTL

Danda (${transaction.dandaRate}%): ${NumberUtils.formatWeight(transaction.dandaWeight)} QTL
Net Weight with Danda: ${NumberUtils.formatWeight(transaction.netWeightDanda)} QTL

Rate: ${NumberUtils.formatCurrency(transaction.rate)}/QTL
Amount: ${NumberUtils.formatCurrency(transaction.amount)}
Commission: ${NumberUtils.formatCurrency(transaction.commission)}
Majuri: ${NumberUtils.formatCurrency(transaction.majuri)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL: ${NumberUtils.formatCurrency(transaction.total)}
${NumberUtils.numberToWords(transaction.total)}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Powered by ${AppConstants.developerName}
${AppConstants.developerPhone}
''';
  }
}
