import 'package:intl/intl.dart';

class NumberUtils {
  static final _indianFormat = NumberFormat('#,##,##,##0.00', 'en_IN');
  static final _weightFormat = NumberFormat('#,##,##,##0.00', 'en_IN');

  static String formatCurrency(double amount, {bool isTotal = false}) {
    return '₹${_indianFormat.format(amount)}';
  }

  static String formatWeight(double weight) {
    return _weightFormat.format(weight);
  }

  static String numberToWords(double number) {
    if (number == 0) return 'Zero';
    
    int intPart = number.floor();
    int decimalPart = ((number - intPart) * 100).round();
    
    String words = _convertToWords(intPart);
    
    if (decimalPart > 0) {
      words += ' and ${_convertToWords(decimalPart)} Paise';
    }
    
    return words;
  }

  static String _convertToWords(int number) {
    if (number == 0) return '';
    
    final ones = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
    final teens = ['Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
    final tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];
    
    if (number < 10) return ones[number];
    if (number < 20) return teens[number - 10];
    if (number < 100) {
      return '${tens[number ~/ 10]} ${ones[number % 10]}'.trim();
    }
    if (number < 1000) {
      return '${ones[number ~/ 100]} Hundred ${_convertToWords(number % 100)}'.trim();
    }
    if (number < 100000) {
      return '${_convertToWords(number ~/ 1000)} Thousand ${_convertToWords(number % 1000)}'.trim();
    }
    if (number < 10000000) {
      return '${_convertToWords(number ~/ 100000)} Lakh ${_convertToWords(number % 100000)}'.trim();
    }
    return '${_convertToWords(number ~/ 10000000)} Crore ${_convertToWords(number % 10000000)}'.trim();
  }
}
