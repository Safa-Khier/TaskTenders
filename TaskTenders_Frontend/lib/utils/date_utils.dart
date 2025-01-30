import 'package:intl/intl.dart';

/// Formats a date to a string in the specified format
/// * [date]: The date to format
/// * [format]: The format to use (default is ["MMMM dd, yyyy"])
String getDateInFormat(
    {required DateTime date, String? format = "MMMM dd, yyyy"}) {
  final DateFormat formatter = DateFormat(format);
  return formatter.format(date);
}

/// Checks if the given date is today
/// * [date]: The date to check
/// Returns true if the date is today, false otherwise
bool isToday(DateTime date) {
  final now = DateTime.now();
  return now.day == date.day &&
      now.month == date.month &&
      now.year == date.year;
}

/// Gets the difference in minutes between the given date and now
/// * [date]: The date to check
/// Returns the difference in minutes between the given date and now
int getDifferenceInMinutes(DateTime date) {
  final now = DateTime.now();
  return now.difference(date).inMinutes;
}
