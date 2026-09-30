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

  /// Create an instance of [Lunar] from lunar [year], [month] and [day].
  /// Set [leapMonth] to true for a date in the leap month of the year.
  /// The date is not validated until it is converted with [getSolar].
  Lunar.date(
    int year,
    int month,
    int day, {
    bool leapMonth = false,
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) {
    _year = year;
    _month = month;
    _day = day;
    _leapMonth = leapMonth;
    _hour = hour;
    _minute = minute;
    _second = second;
  }

  /// Convert to Solar. leapMonth = false if not specified.
  ///
  /// Throws an [ArgumentError] if this lunar date does not exist (e.g. a leap
  /// month the year doesn't have, or day 30 of a 29-day month), or if the
  /// solar date is outside the supported years 1800 to 2199.
  Solar getSolar() {
    final leap = _leapMonth ?? false;
    final solar = convertLunar2Solar(_day, _month, _year, leap);
    final invalid = ArgumentError(
      'Invalid lunar date: $_day/$_month/$_year${leap ? ' (leap)' : ''}',
    );
    if (solar[yearIndex] == 0) throw invalid;

    _checkSupportedYear(solar[yearIndex]);
    // A valid lunar date converts back to itself.
    final roundTrip = convertSolar2Lunar(
      solar[dayIndex],
      solar[monthIndex],
      solar[yearIndex],
    );
    if (roundTrip[dayIndex] != _day ||
        roundTrip[monthIndex] != _month ||
        roundTrip[yearIndex] != _year ||
        (roundTrip.last == 1) != leap) {
      throw invalid;
    }
    return Solar(DateTime(
      solar[yearIndex],
      solar[monthIndex],
      solar[dayIndex],
      _hour,
      _minute,
      _second,
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
      _leapMonth = null;
      return;
    }

    _checkSupportedYear(dateTime.year);
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

  static void _checkSupportedYear(int solarYear) {
    if (solarYear < minSupportedYear || solarYear > maxSupportedYear) {
      throw ArgumentError.value(
        solarYear,
        'year',
        'Only solar years $minSupportedYear to $maxSupportedYear are supported',
      );
    }
  }

  /// Throws an [ArgumentError] if either date is invalid, see [getSolar].
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
        (other.leapMonth ?? false) == (_leapMonth ?? false);
  }

  @override
  int get hashCode => Object.hash(
      _year, _month, _day, _hour, _minute, _second, _leapMonth ?? false);

  @override
  DateTime toDateTime() {
    return DateTime(_year, _month, _day, _hour, _minute, _second);
  }
}
