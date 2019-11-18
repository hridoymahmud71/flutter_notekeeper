import 'package:intl/intl.dart';

class DateHelper {

   static String stringDateNow() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    return formatted;
  }
}
