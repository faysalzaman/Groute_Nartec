import 'package:intl/intl.dart';

extension StringExtensions on String {
  /// Formats a date string from ISO 8601 to a human-readable format.
  ///
  /// If the date string is null or empty, returns 'N/A'.
  String get formattedDate {
    if (isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      // Log error: print('Date parsing error: $e');
      return this; // Return original string if parsing fails
    }
  }

  /// Formats a currency string from a number string to a human-readable format.
  ///
  /// If the currency string is null or empty, returns 'N/A'.
  String get formattedCurrency {
    if (isEmpty) return 'N/A';
    try {
      final number = double.parse(this);
      final format = NumberFormat.currency(locale: 'en_SA', symbol: 'SAR ');
      return format.format(number);
    } catch (e) {
      // Log error: print('Currency parsing error: $e');
      return 'SAR $this'; // Fallback
    }
  }
}
