import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime getYear1970() {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? convertStringToDateTime(String? json) {
    if (json == null || json.isEmpty) return null;
    return DateTime.parse(json);
  }

  static String getDateFromMilliseconds(int mill) {
    return DateFormat('MM/dd/yyyy').format(DateTime.fromMillisecondsSinceEpoch(mill));
  }

  static String getStringFromDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  static int getAgeFromMilliseconds(int? mill) {
    if (mill == null) return 0;
    return AgeCalculator.age(DateTime.fromMillisecondsSinceEpoch(mill)).years;
  }
}
