import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/transaction.dart' as models;
import '../utils/number_utils.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart' as app_date;

class PdfService {
  static Future<void> generateAndSharePdf(models.Transaction transaction) async {
    final pdf = pw.Document();
    
    // Load logo
    final logoData = await rootBundle.load('assets/logo.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(logoImage, width: 80, height: 80),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Banana Hisab',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#16A34A'),
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#16A34A'),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Text(
                          'RECEIPT',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        app_date.DateUtils.formatDate(transaction.date),
                        style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Party name
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F0FDF4'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  children: [
                    pw.Text(
                      'Party: ',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      transaction.party,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Calculation table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F3F4F6')),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text('Value', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12), textAlign: pw.TextAlign.right),
                      ),
                    ],
                  ),
                  // Rows
                  _buildTableRow('Gross Weight', '${NumberUtils.formatWeight(transaction.grossWeight)} QTL'),
                  _buildTableRow('Patti (${transaction.pattiMode == 'rate' ? '${transaction.pattiRate}%' : 'Fixed'})', '${NumberUtils.formatWeight(transaction.pattiWeight)} QTL'),
                  _buildTableRow('Net Weight', '${NumberUtils.formatWeight(transaction.netWeight)} QTL', isHighlighted: true),
                  _buildTableRow('Danda (${transaction.dandaRate} Kg/QTL)', '${NumberUtils.formatWeight(transaction.dandaWeight)} QTL'),
                  _buildTableRow('Net Weight with Danda', '${NumberUtils.formatWeight(transaction.netWeightDanda)} QTL', isHighlighted: true),
                  _buildTableRow('Rate', '₹ ${transaction.rate.toStringAsFixed(2)}/QTL'),
                  _buildTableRow('Amount', '₹ ${_formatIndianCurrency(transaction.amount)}'),
                  _buildTableRow('Commission', '₹ ${_formatIndianCurrency(transaction.commission)}'),
                  _buildTableRow('Majuri', '₹ ${_formatIndianCurrency(transaction.majuri)}'),
                ],
              ),
              pw.SizedBox(height: 20),

              // Total
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfColor.fromHex('#16A34A'), PdfColor.fromHex('#15803D')],
                  ),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Amount',
                      style: const pw.TextStyle(fontSize: 14, color: PdfColors.white),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      '₹ ${_formatIndianCurrency(transaction.total)}',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      NumberUtils.numberToWords(transaction.total),
                      style: const pw.TextStyle(fontSize: 11, color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.Spacer(),

              // Footer
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Powered by ${AppConstants.developerName}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                    pw.SizedBox(height: 4),
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

  static pw.TableRow _buildTableRow(String label, String value, {bool isHighlighted = false}) {
    return pw.TableRow(
      decoration: isHighlighted ? pw.BoxDecoration(color: PdfColor.fromHex('#F0FDF4')) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: isHighlighted ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isHighlighted ? PdfColor.fromHex('#16A34A') : PdfColors.grey800,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: isHighlighted ? PdfColor.fromHex('#16A34A') : PdfColors.grey900,
            ),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  static String _formatIndianCurrency(double amount) {
    final formatter = amount.toStringAsFixed(2);
    final parts = formatter.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    
    // Indian number formatting
    if (intPart.length <= 3) return '$intPart.$decPart';
    
    final lastThree = intPart.substring(intPart.length - 3);
    final remaining = intPart.substring(0, intPart.length - 3);
    
    final formatted = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (match) => '${match.group(1)},',
    );
    
    return '$formatted,$lastThree.$decPart';
  }

  static String generateTextReceipt(models.Transaction transaction) {
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

Danda (${transaction.dandaRate} Kg/QTL): ${NumberUtils.formatWeight(transaction.dandaWeight)} QTL
Net Weight with Danda: ${NumberUtils.formatWeight(transaction.netWeightDanda)} QTL

Rate: ₹ ${transaction.rate.toStringAsFixed(2)}/QTL
Amount: ₹ ${_formatIndianCurrency(transaction.amount)}
Commission: ₹ ${_formatIndianCurrency(transaction.commission)}
Majuri: ₹ ${_formatIndianCurrency(transaction.majuri)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL: ₹ ${_formatIndianCurrency(transaction.total)}
${NumberUtils.numberToWords(transaction.total)}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Powered by ${AppConstants.developerName}
${AppConstants.developerPhone}
''';
  }
}
