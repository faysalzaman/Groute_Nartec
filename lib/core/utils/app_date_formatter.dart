import 'package:intl/intl.dart';

class AppDateFormatter {
  // Format from DateTime object
  static String fromDate(DateTime date, {bool? showTime = false}) {
    try {
      return showTime == true
          ? DateFormat.yMMMMd('en_US').add_jm().format(date)
          : DateFormat.yMMMMd('en_US').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  // Format from string (handles ISO 8601 with timezone)
  static String fromString(String? date, {bool? showTime = false}) {
    if (date == null || date.isEmpty) return 'Not specified';

    try {
      // Parse the date string to DateTime (handles ISO 8601 with Z timezone)
      final dateTime =
          DateTime.parse(date).toLocal(); // Convert to local timezone

      return showTime == true
          ? DateFormat.yMMMMd('en_US').add_jm().format(dateTime)
          : DateFormat.yMMMMd('en_US').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
