## 1.2.0
- Add `Lunar.date(year, month, day, {leapMonth})` to create a lunar date directly, including leap months
- `Lunar.getSolar()` now throws `ArgumentError` for lunar dates that don't exist (e.g. a leap month the year doesn't have, or day 30 of a 29-day month) instead of returning a wrong date
- Creating a `Lunar` from a solar date, or converting one back, throws `ArgumentError` for years outside the supported 1800 to 2199
- Fix `Solar` and `Lunar` `hashCode` so equal objects work correctly in `Set` and `Map`
- Fix `Lunar ==` ignoring `leapMonth`: a leap month and the regular month with the same number are no longer equal
- Fix `Lunar.getSolar()` dropping hour, minute and second
- Update dev dependencies (`lints`, `test`) while keeping Dart 3.0 support
- Fix `convertLunar2Solar` example in README (`leap` is a `bool`)

## 1.1.1
- Fix late init error

## 1.1.0
- Add Solar, Lunar classes
- Use bool instead of int for lunarLeap
- Set default timezone to 7 (GMT+7)
- Fix a bug in jdToDate function that sometimes leads to wrong calculation

## 1.0.2
- Refactor with minor changes

## 1.0.1
- Update SDK constraints
- Add documents with dartdoc

## 1.0.0
- Initial version.