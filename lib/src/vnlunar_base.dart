import 'dart:math';

import 'constants.dart';

const double _juliusDaysIn1900 = 2415021.076998695;
const double _newMoonCycle = 29.530588853;

abstract class VNLunar {
  /// Returns DateTime format. If the current object is using Lunar system,
  /// returns its properties with DateTime format. [Lunar] can use `toSolar` then
  /// `toDateTime`, which is the same.
  DateTime toDateTime();
}

/// Compute the (integral) Julian day number of day dd/mm/yyyy, i.e., the number
/// of days between 1/1/4713 BC (Julian calendar) and dd/mm/yyyy.
/// Formula from http://www.tondering.dk/claus/calendar.html
int jdFromDate(int dd, int mm, int yy) {
  int a, y, m, jd;
  a = ((14 - mm) / 12).floor();
  y = yy + 4800 - a;
  m = mm + 12 * a - 3;
  jd = dd +
      ((153 * m + 2) / 5).floor() +
      daysInYear * y +
      (y / 4).floor() -
      (y / 100).floor() +
      (y / 400).floor() -
      32045;
  if (jd < 2299161) {
    jd = dd +
        ((153 * m + 2) / 5).floor() +
        daysInYear * y +
        (y / 4).floor() -
        32083;
  }
  return jd;
}

/// Convert a Julian day number to day/month/year. Parameter jd is an integer.
List<int> jdToDate(int jd) {
  int a, b, c, d, e, m, day, month, year;
  if (jd > 2299160) {
    a = jd + 32044;
    b = ((4 * a + 3) / 146097).floor();
    c = a - ((b * 146097) / 4).floor();
  } else {
    b = 0;
    c = jd + 32082;
  }
  d = ((4 * c + 3) / 1461).floor();
  e = c - ((1461 * d) / 4).floor();
  m = ((5 * e + 2) / 153).floor();
  day = e - ((153 * m + 2) / 5).floor() + 1;
  month = m + 3 - 12 * (m / 10).floor();
  year = b * 100 + d - 4800 + (m / 10).floor();
  return [day, month, year];
}

/// Compute the time of the k-th new moon after the new moon of 1/1/1900 13:52 UCT
/// (measured as the number of days since 1/1/4713 BC noon UCT, e.g., 2451545.125 is 1/1/2000 15:00 UTC).
/// Returns a floating number, e.g., 2415079.9758617813 for k=2 or 2414961.935157746 for k=-2
/// Algorithm from: "Astronomical Algorithms" by Jean Meeus, 1998.
double newMoon(int k) {
  double T, t2, t3, dr, jd1, M, mpr, F, c1, delta, jdNew;
  T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
  t2 = T * T;
  t3 = t2 * T;
  dr = pi / 180;
  jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
  jd1 = jd1 +
      0.00033 *
          sin((166.56 + 132.87 * T - 0.009173 * t2) * dr); // Mean new moon
  M = 359.2242 +
      29.10535608 * k -
      0.0000333 * t2 -
      0.00000347 * t3; // Sun's mean anomaly
  mpr = 306.0253 +
      385.81691806 * k +
      0.0107306 * t2 +
      0.00001236 * t3; // Moon's mean anomaly
  F = 21.2964 +
      390.67050646 * k -
      0.0016528 * t2 -
      0.00000239 * t3; // Moon's argument of latitude
  c1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
  c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr);
  c1 = c1 - 0.0004 * sin(dr * 3 * mpr);
  c1 = c1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + mpr));
  c1 = c1 - 0.0074 * sin(dr * (M - mpr)) + 0.0004 * sin(dr * (2 * F + M));
  c1 = c1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + mpr));
  c1 = c1 + 0.0010 * sin(dr * (2 * F - mpr)) + 0.0005 * sin(dr * (2 * mpr + M));
  if (T < -11) {
    delta = 0.001 +
        0.000839 * T +
        0.0002261 * t2 -
        0.00000845 * t3 -
        0.000000081 * T * t3;
  } else {
    delta = -0.000278 + 0.000265 * T + 0.000262 * t2;
  }
  jdNew = jd1 + c1 - delta;
  return jdNew;
}

/// Compute the longitude of the sun at any time.
/// Parameter: floating number jdn, the number of days since 1/1/4713 BC noon
/// Algorithm from: "Astronomical Algorithms" by Jean Meeus, 1998.
double sunLongitude(double jdn) {
  double T, t2, dr, M, l0, dl, L;
  T = (jdn - 2451545.0) /
      36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
  t2 = T * T;
  dr = pi / 180; // degree to radian
  M = 357.52910 +
      35999.05030 * T -
      0.0001559 * t2 -
      0.00000048 * T * t2; // mean anomaly, degree
  l0 = 280.46645 + 36000.76983 * T + 0.0003032 * t2; // mean longitude, degree
  dl = (1.914600 - 0.004817 * T - 0.000014 * t2) * sin(dr * M);
  dl = dl +
      (0.019993 - 0.000101 * T) * sin(dr * 2 * M) +
      0.000290 * sin(dr * 3 * M);
  L = l0 + dl; // true longitude, degree
  L = L * dr;
  L = L - pi * 2 * (L / (pi * 2)).floor(); // Normalize to (0, 2*PI)
  return L;
}

/// Compute sun position at midnight of the day with the given Julian day number.
/// The time zone if the time difference between local time and UTC: 7.0 for UTC+7:00.
/// The function returns a number between 0 and 11.
/// From the day after March equinox and the 1st major term after March equinox, 0 is returned.
/// After that, return 1, 2, 3 ...
int getSunLongitude(int dayNumber, [int timeZone = vnTimezone]) {
  return (sunLongitude(dayNumber - 0.5 - timeZone / 24) / pi * 6).floor();
}

/// Compute the day of the k-th new moon in the given time zone.
/// The time zone if the time difference between local time and UTC: 7.0 for UTC+7:00.
int getNewMoonDay(int k, int timeZone) {
  return (newMoon(k) + 0.5 + timeZone / 24).floor();
}

/// Find the day that starts the luner month 11 of the given year for the given time zone.
int getLunarMonth11(int yy, [int timeZone = vnTimezone]) {
  int k, nm, sunLong;
  double off;
  off = jdFromDate(31, 12, yy) - 2415021;
  k = (off / _newMoonCycle).floor();
  nm = getNewMoonDay(k, timeZone);
  sunLong = getSunLongitude(nm, timeZone);
  if (sunLong >= 9) {
    nm = getNewMoonDay(k - 1, timeZone);
  }
  return nm;
}

/// Find the index of the leap month after the month starting on the day a11.
int getLeapMonthOffset(int a11, [int timeZone = vnTimezone]) {
  int k, last, arc, i;
  k = ((a11 - _juliusDaysIn1900) / _newMoonCycle + 0.5).floor();
  last = 0;
  i = 1; // We start with the month following lunar month 11
  arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
  do {
    last = arc;
    i++;
    arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
  } while (arc != last && i < 14);
  return i - 1;
}

/// Convert solar date dd/mm/yyyy to the corresponding lunar date.
List<int> convertSolar2Lunar(
  int dd,
  int mm,
  int yy, [
  int timeZone = vnTimezone,
]) {
  int k,
      dayNumber,
      monthStart,
      a11,
      b11,
      lunarDay,
      lunarMonth,
      lunarYear,
      lunarLeap;
  dayNumber = jdFromDate(dd, mm, yy);
  k = (dayNumber - _juliusDaysIn1900) ~/ _newMoonCycle;
  monthStart = getNewMoonDay(k + 1, timeZone);
  if (monthStart > dayNumber) {
    monthStart = getNewMoonDay(k, timeZone);
  }
  a11 = getLunarMonth11(yy, timeZone);
  b11 = a11;
  if (a11 >= monthStart) {
    lunarYear = yy;
    a11 = getLunarMonth11(yy - 1, timeZone);
  } else {
    lunarYear = yy + 1;
    b11 = getLunarMonth11(yy + 1, timeZone);
  }
  lunarDay = dayNumber - monthStart + 1;
  int diff = (monthStart - a11) ~/ 29;
  lunarLeap = 0;
  lunarMonth = diff + 11;
  if (b11 - a11 > daysInYear) {
    int leapMonthDiff = getLeapMonthOffset(a11, timeZone);
    if (diff >= leapMonthDiff) {
      lunarMonth = diff + 10;
      if (diff == leapMonthDiff) {
        lunarLeap = 1;
      }
    }
  }
  if (lunarMonth > 12) {
    lunarMonth = lunarMonth - 12;
  }
  if (lunarMonth >= 11 && diff < 4) {
    lunarYear -= 1;
  }
  return [lunarDay, lunarMonth, lunarYear, lunarLeap];
}

/// Convert lunar date to the corresponding solar date.
List<int> convertLunar2Solar(
  int lunarDay,
  int lunarMonth,
  int lunarYear,
  bool lunarLeap, [
  int timeZone = vnTimezone,
]) {
  int k, a11, b11, off, leapOff, leapMonth, monthStart;
  if (lunarMonth < 11) {
    a11 = getLunarMonth11(lunarYear - 1, timeZone);
    b11 = getLunarMonth11(lunarYear, timeZone);
  } else {
    a11 = getLunarMonth11(lunarYear, timeZone);
    b11 = getLunarMonth11(lunarYear + 1, timeZone);
  }
  k = (0.5 + (a11 - _juliusDaysIn1900) / _newMoonCycle).floor();
  off = lunarMonth - 11;
  if (off < 0) {
    off += 12;
  }
  if (b11 - a11 > daysInYear) {
    leapOff = getLeapMonthOffset(a11, timeZone);
    leapMonth = leapOff - 2;
    if (leapMonth < 0) {
      leapMonth += 12;
    }
    if (lunarLeap && (lunarMonth != leapMonth)) {
      return [0, 0, 0];
    } else if (lunarLeap || (off >= leapOff)) {
      off += 1;
    }
  }
  monthStart = getNewMoonDay(k + off, timeZone);
  return jdToDate(monthStart + lunarDay - 1);
}
