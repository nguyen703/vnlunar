This package provides functions to convert between the solar and lunar calendars, 
with a focus on the Vietnamese lunar calendar system. The lunar calendar depends on the time zone,
longitude, and latitude, so it is recommended to use this package only for 
the Vietnamese lunar calendar.<br><br>

All the functions are converted from Javascript to Dart. The original is from [PhD. Ho Ngoc Duc](https://www.informatik.uni-leipzig.de/~duc/amlich/calrules.html).
Thanks to him for inspiring me to create this package in Dart.

## Features

- Convert Solar date to Lunar date and vice versa (supported from 1800 to 2199).
- Convert Solar date to Julian days.

## Usage

- From version 1.1.0, the package supports Classes instead of Lists for easier access. `Lunar` and `Solar` provide methods to interact with each other, or converted to DateTime object.
```dart
  final solar = Solar(1998, 6, 18);
  final lunar = Lunar.createFromSolar(solar);
  final convertedSolarFromLunar = lunar.getSolar();
  
  // solar == convertedSolarFromLunar -> true
```

- The `convertSolar2Lunar` function returns a List by order: [lunarDay, lunarMonth, lunarYear, leap], where `leap` indicates whether the lunarMonth is a leap or not.
```dart
int dd = 23;
int mm = 3;
int yy = 2023;
int timeZone = 7; 

List<int> lunar = convertSolar2Lunar(dd, mm, yy, timeZone); // lunar = [2, 2, 2023, 1] - leap
```
- The `convertLunar2Solar`function returns a List by order [solarDay, solarMonth, solarYear]. Note that it takes the `leap` parameter, where leap = 1 if the lunarMonth is leap, 0 if it is not leap.
```dart
int dd = 2;
int mm = 2;
int yy = 2023;
int leap = 1;
int timeZone = 7;

List<int> solar = convertLunar2Solar(dd, mm, yy, leap, timeZone); // solar = [23, 3, 2023]
```

## Additional information
I recommend reading the original research from [PhD. Ho Ngoc Duc](https://www.informatik.uni-leipzig.de/~duc/amlich/calrules.html) to know more about the calculation.<br>
