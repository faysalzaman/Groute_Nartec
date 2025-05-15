import 'package:intl/intl.dart';

class AppDateFormatter {
  // from date
  static String formatDate(DateTime date, {bool? showTime = false}) {
    return showTime == true
        ? DateFormat.yMMMMd('en_US').add_Hms().format(date)
        : DateFormat.yMMMMd('en_US').format(date);
  }

  // from string
  static String formatString(String date, {bool? showTime = false}) {
    return showTime == true
        ? DateFormat.yMMMMd('en_US').add_Hms().format(DateTime.parse(date))
        : DateFormat.yMMMMd('en_US').format(DateTime.parse(date));
  }
}
