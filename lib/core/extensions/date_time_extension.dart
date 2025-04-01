import 'package:intl/intl.dart';



extension DateTimeFormate on DateTime {
  String get customFormate => DateFormat("EEE, MMM d, ''yy").format(this);
}
