// ignore_for_file: unnecessary_overrides

import 'lunar.dart';

/// An instant in time, similar to [DateTime] object, having functions
/// that helps interacting with [Lunar] much more easier.
class Solar implements Comparable<Solar> {
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

  /// Create an instance of [Solar] from [dateTime]. If [dateTime] is null,
  /// automatically constructs a [Solar] with current date and time
  /// in the local time zone.
  Solar([DateTime? dateTime])
      : this._fromDate(dateTime ?? DateTime.now().toLocal());

  Solar._fromDate(DateTime dateTime) {
    _year = dateTime.year;
    _month = dateTime.month;
    _day = dateTime.day;
    _hour = dateTime.hour;
    _minute = dateTime.minute;
    _second = dateTime.second;
  }

  DateTime toDateTime() {
    return DateTime(
      _year,
      _month,
      _day,
      _hour,
      _minute,
      _second,
    );
  }

  @override
  int compareTo(Solar other) {
    if (this == other) return 0;
    return toDateTime().compareTo(other.toDateTime());
  }

  @override
  bool operator ==(other) {
    return other is Solar &&
        other.year == _year &&
        other.month == _month &&
        other.day == _day &&
        other.hour == _hour &&
        other.minute == _minute &&
        other.second == _second;
  }

  @override
  int get hashCode => super.hashCode;
}
