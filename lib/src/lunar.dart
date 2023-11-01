import 'package:vnlunar/src/constants.dart';
import 'package:vnlunar/src/solar.dart';
import 'package:vnlunar/src/vnlunar_base.dart';

final class Lunar {
  late final DateTime _rawDateTime;
  DateTime get dateTime => _rawDateTime;

  late final bool _leapMonth;
  bool get leapMonth => _leapMonth;

  int get day => _rawDateTime.day;
  int get month => _rawDateTime.month;
  int get year => _rawDateTime.year;

  Lunar(int year, int month, int day) {
    bool isYearValid = year >= 0;
    bool isMonthValid = month >= 1 && month <= 12;
    bool isDayValid = day >= 0 && day <= _getNumberOfDays(month, year);
    assert(!isYearValid || !isMonthValid || !isDayValid, "Date is not valid");

    // TODO (htrang) : implement isLeapMonth(year, month, day) or only visible for
    // testing since leapMonth information is inconsistence

    _rawDateTime = DateTime(year, month, day);
  }

  Lunar._(DateTime? date, [bool leapMonth = false]) {
    _rawDateTime = date ?? DateTime.now().toLocal();
    _leapMonth = leapMonth;
  }

  static Lunar createFromSolar(DateTime? date) {
    date = date ?? DateTime.now().toLocal();

    final rawLunar = convertSolar2Lunar(date.day, date.month, date.year);
    return Lunar._(
        DateTime(rawLunar[yearIndex], rawLunar[monthIndex], rawLunar[dayIndex],
            date.hour, date.minute, date.second),
        rawLunar.last == 1);
  }
}

extension SolarConvertible on Lunar {
  Solar getSolar() {
    final rawSolar = convertLunar2Solar(
        _rawDateTime.day, _rawDateTime.month, _rawDateTime.year, leapMonth);
    return Solar(rawSolar[yearIndex], rawSolar[monthIndex], rawSolar[dayIndex]);
  }
}

int _getNumberOfDays(int month, int year) {
  bool isYearValid = year >= 0;
  bool isMonthValid = month >= 1 && month <= 12;
  if (!isYearValid || !isMonthValid) return 0;
  switch (month) {
    case 1:
      return 31;
    case 2:
      return year % 4 == 0 && year % 100 == 0 ? 29 : 28;
    case 3:
      return 31;
    case 4:
      return 30;
    case 5:
      return 31;
    case 6:
      return 30;
    case 7:
      return 31;
    case 8:
      return 31;
    case 9:
      return 30;
    case 10:
      return 31;
    case 11:
      return 30;
    case 12:
      return 31;
  }
  return 0;
}
