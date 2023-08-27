// ignore_for_file: unnecessary_overrides

import 'package:vnlunar/src/constants.dart';
import 'package:vnlunar/src/vnlunar_base.dart';

import 'solar.dart';

class Lunar implements Comparable<Lunar> {
  late final int _year;
  int get year => _year;

  late final int _month;
  int get month => _month;

  late final int _day;
  int get day => _day;

  late final int _hour;
  int get hour => _hour;

  late final int _minute;
  int get minute => _minute;

  late final int _second;
  int get second => _second;

  late final bool _leapMonth;
  bool get leapMonth => _leapMonth;

  /// Create an instance of [Lunar] from [dateTime]. If [dateTime] is null,
  /// automatically constructs a [Lunar] with current date and time
  /// in the local time zone.
  Lunar([DateTime? dateTime])
      : this._fromDate(dateTime ?? DateTime.now().toLocal());

  /// Create an instance of [Lunar] from [Solar].
  Lunar.fromSolar(Solar solar) : this(solar.toDateTime());

  /// Convert to Solar.
  Solar getSolar() {
    final solar = convertLunar2Solar(_day, _month, _year, _leapMonth);
    return Solar(DateTime(
      solar[yearIndex],
      solar[monthIndex],
      solar[dayIndex],
    ));
  }

  Lunar._fromDate(DateTime dateTime) {
    final lunar =
        convertSolar2Lunar(dateTime.day, dateTime.month, dateTime.year);
    _year = lunar[yearIndex];
    _month = lunar[monthIndex];
    _day = lunar[dayIndex];
    _leapMonth = (lunar.last == 1);
    _hour = dateTime.hour;
    _minute = dateTime.minute;
    _second = dateTime.second;
  }

  @override
  int compareTo(Lunar other) {
    if (this == other) return 0;
    return getSolar().compareTo(other.getSolar());
  }

  @override
  bool operator ==(other) {
    return other is Lunar &&
        other.year == _year &&
        other.month == _month &&
        other.day == _day &&
        other.hour == _hour &&
        other.minute == _minute &&
        other.second == _second &&
        other.leapMonth == _leapMonth;
  }

  @override
  int get hashCode => super.hashCode;
}
