// ignore_for_file: unnecessary_overrides

import 'package:vnlunar/src/constants.dart';

import 'solar.dart';
import 'vnlunar_base.dart';

class Lunar extends VNLunar implements Comparable<Lunar> {
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

  late final bool? _leapMonth;
  bool? get leapMonth => _leapMonth;

  /// Create an instance of [Lunar] from [date]. If [date] is null,
  /// automatically constructs a [Lunar] with current date and time
  /// in the local time zone.
  Lunar({
    DateTime? date,
    required bool createdFromSolar,
  }) : this._fromDate(
          date ?? DateTime.now().toLocal(),
          createdFromSolar,
        );

  /// Create an instance of [Lunar] from [Solar].
  Lunar.fromSolar(Solar solar)
      : this(
          date: solar.toDateTime(),
          createdFromSolar: true,
        );

  /// Convert to Solar. leapMonth = false if not specified.
  Solar getSolar() {
    final solar = convertLunar2Solar(_day, _month, _year, _leapMonth ?? false);
    return Solar(DateTime(
      solar[yearIndex],
      solar[monthIndex],
      solar[dayIndex],
    ));
  }

  Lunar._fromDate(DateTime dateTime, bool createdFromSolar) {
    if (!createdFromSolar) {
      _year = dateTime.year;
      _month = dateTime.month;
      _day = dateTime.day;
      _hour = dateTime.hour;
      _minute = dateTime.minute;
      _second = dateTime.second;
      return;
    }

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
        other.second == _second;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  DateTime toDateTime() {
    return DateTime(_year, _month, _day, _hour, _minute, _second);
  }
}
