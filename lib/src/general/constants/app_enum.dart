import 'package:equatable/equatable.dart';

enum OAuthEnum {
  facebook,
  google,
  apple;

  String get name {
    switch (this) {
      case OAuthEnum.apple:
        return 'apple';
      case OAuthEnum.facebook:
        return 'facebook';
      case OAuthEnum.google:
        return 'google';
      default:
        return '';
    }
  }
}

enum AppEnvironment{
  DEVELOPMENT('DEVELOPMENT ENVIRONMENT'),
  PRODUCTION('PRODUCTION ENVIRONMENT');
  const AppEnvironment(this.name);
  final String name;
}

class AutoDeleteTime {
  final int id;
  final String name;
  final int inSeconds;

  const AutoDeleteTime(
      this.id,
      this.name,
      this.inSeconds,
      );

  static const never = AutoDeleteTime(
    0,
    'Không bao giờ',
    0,
  );
  static const one_day = AutoDeleteTime(
    1,
    '1 Ngày',
    86400,
  );
  static const seven_day = AutoDeleteTime(
    2,
    '7 Ngày',
    604800,
  );
  static const thirty_day = AutoDeleteTime(
    3,
    '30 Ngày',
    2592000,
  );

  static const values = [
    never,
    one_day,
    seven_day,
    thirty_day,
  ];

  @override
  String toString() => name;
}

class DayOfWeek extends Equatable {
  final String day;
  final int id;

  const DayOfWeek(
      this.id,
      this.day,
      );

  static const mon = DayOfWeek(kMinId, 'T2');
  static const tue = DayOfWeek(kMinId + 1, 'T3');
  static const wed = DayOfWeek(kMinId + 3, 'T4');
  static const thu = DayOfWeek(kMinId + 4, 'T5');
  static const fri = DayOfWeek(kMinId + 5, 'T6');
  static const sat = DayOfWeek(kMinId + 6, 'T7');
  static const sun = DayOfWeek(kMinId + 7, 'CN');

  static const kMinId = 0;

  static const values = [
    mon,
    tue,
    wed,
    thu,
    fri,
    sat,
    sun,
  ];

  @override
  List<Object?> get props => [id];

  @override
  String toString() => day;

  /// index = dateTime.weekday
  ///
  /// monday: index = 1
  ///
  /// tuesday: index = 2
  ///
  /// ...
  static DayOfWeek fromFlutterWeekdayIndex(int index) => values[index - 1];
}


