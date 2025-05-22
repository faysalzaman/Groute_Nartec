import 'package:intl/intl.dart';

class AppDateFormatter {
  // from date
  static String fromDate(DateTime date, {bool? showTime = false}) {
    return showTime == true
        ? DateFormat.yMMMMd('en_US').add_jm().format(
          date,
        ) // Using add_jm() for AM/PM format
        : DateFormat.yMMMMd('en_US').format(date);
  }

  // from string
  static String fromString(String date, {bool? showTime = false}) {
    return showTime == true
        ? DateFormat.yMMMMd('en_US').add_jm().format(
          DateTime.parse(date),
        ) // Using add_jm() for AM/PM format
        : DateFormat.yMMMMd('en_US').format(DateTime.parse(date));
  }
}
