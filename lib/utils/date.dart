import 'package:intl/intl.dart';

/// Parses a date to a human readable string.
///
/// Example
/// ```
/// const text = _buildDateString('2022-06-29T18:03:32.083Z');
/// text => 'June 26, 2022 6:03 PM'
/// ```
String parseDateString(String value) {
  final date = DateFormat.yMMMMd('en_US');
  final hour = DateFormat.jm();
  return '${date.format(DateTime.parse(value))} ${hour.format(DateTime.parse(value))}';
}
