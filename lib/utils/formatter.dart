import 'package:intl/intl.dart';

String formatNumber(num number) {
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(number);
}
