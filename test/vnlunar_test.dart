import 'package:test/test.dart';
import 'package:vnlunar/vnlunar.dart';

void main() {
  test('get Julian from a date', () {
    // Arrange
    int dd = 20;
    int mm = 8;
    int yy = 2023;

    // Act
    int jd = jdFromDate(dd, mm, yy);

    // Assert
    expect(jd, 2460177);
  });

  test('get Julian from the first supported date', () {
    // Arrange
    int dd = 1;
    int mm = 1;
    int yy = 1900;

    // Act
    int jd = jdFromDate(dd, mm, yy);

    // Assert
    expect(jd, 2415021);
  });

  test('get date from Julian', () {
    // Arrange
    int jd = 2459581;

    // Act
    List<int> ddmmyyyy = jdToDate(jd);

    // Assert
    expect(ddmmyyyy, [1, 1, 2022]);
  });

  test('get Lunar from Solar, no leap', () {
    // Arrange
    int dd = 20;
    int mm = 8;
    int yy = 2023;
    int timeZone = 7;

    // Act
    List<int> lunar = convertSolar2Lunar(dd, mm, yy, timeZone);

    // Assert
    expect(lunar, [5, 7, 2023, 0]);
  });

  test('get Lunar from Solar, leap', () {
    // Arrange
    int dd = 23;
    int mm = 3;
    int yy = 2023;
    int timeZone = 7;

    // Act
    List<int> lunar = convertSolar2Lunar(dd, mm, yy, timeZone);

    // Assert
    expect(lunar, [2, 2, 2023, 1]);
  });

  test('get Solar from Lunar, no leap', () {
    // Arrange
    int dd = 2;
    int mm = 2;
    int yy = 2023;
    int timeZone = 7;

    // Act
    List<int> solar = convertLunar2Solar(dd, mm, yy, false, timeZone);

    // Assert
    expect(solar, [21, 2, 2023]);
  });

  test('get Solar from Lunar, leap', () {
    // Arrange
    int dd = 2;
    int mm = 2;
    int yy = 2023;
    int timeZone = 7;

    // Act
    List<int> solar = convertLunar2Solar(dd, mm, yy, true, timeZone);

    // Assert
    expect(solar, [23, 3, 2023]);
  });

  test('compare Solar with lunar.getSolar', () {
    // Arrange
    DateTime exampleDate = DateTime(1999, 6, 18);
    Lunar lunar = Lunar(createdFromSolar: true, date: exampleDate);
    Solar solar = Solar(exampleDate);
    Solar convertedSolarFromLunar = lunar.getSolar();

    // Act
    bool compare = convertedSolarFromLunar == solar;

    // Assert
    expect(compare, true);
  });

  test('compare Solar with lunar.getSolar', () {
    // Arrange
    DateTime exampleDate = DateTime(1999, 6, 19);
    Lunar lunar = Lunar(createdFromSolar: true, date: exampleDate);
    Solar solar = Solar(DateTime(1999, 6, 18));
    Solar convertedSolarFromLunar = lunar.getSolar();

    // Act
    bool compare = convertedSolarFromLunar == solar;

    // Assert
    expect(compare, false);
  });

  test('initialize Lunar with createdFromSolar = false', () {
    // Arrange
    DateTime exampleDate = DateTime(1999, 6, 18);

    // Act
    Lunar lunar = Lunar(createdFromSolar: false, date: exampleDate);

    // Assert
    expect(lunar.day, exampleDate.day);
    expect(lunar.month, exampleDate.month);
    expect(lunar.year, exampleDate.year);
  });

  test('initialize Lunar with createdFromSolar = true', () {
    // Arrange
    DateTime exampleDate = DateTime(1999, 6, 18);
    DateTime lunarExampleDate = DateTime(1999, 5, 5);

    // Act
    Lunar lunar = Lunar(
      createdFromSolar: true,
      date: exampleDate,
    );
    Lunar lunarExample = Lunar(
      createdFromSolar: false,
      date: lunarExampleDate,
    );

    // Assert
    expect(lunar, lunarExample);
    expect(lunar, lunarExample);
    expect(lunar, lunarExample);
  });

  group('hashCode is consistent with ==', () {
    test('equal Solars have equal hashCode', () {
      // Arrange
      Solar a = Solar(DateTime(2024, 1, 1, 8, 30));
      Solar b = Solar(DateTime(2024, 1, 1, 8, 30));

      // Assert
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect({a, b}.length, 1);
    });

    test('equal Lunars have equal hashCode', () {
      // Arrange
      Lunar a = Lunar(createdFromSolar: true, date: DateTime(2024, 1, 1));
      Lunar b = Lunar(createdFromSolar: true, date: DateTime(2024, 1, 1));

      // Assert
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect({a, b}.length, 1);
    });
  });

  group('Lunar equality respects leapMonth', () {
    test('leap month 2 is not equal to regular month 2', () {
      // Arrange
      // 2023 has a leap month 2: regular 2/2 is 21 Feb, leap 2/2 is 23 Mar.
      Lunar leap = Lunar(createdFromSolar: true, date: DateTime(2023, 3, 23));
      Lunar regular =
          Lunar(createdFromSolar: true, date: DateTime(2023, 2, 21));

      // Assert
      expect(leap.leapMonth, true);
      expect(regular.leapMonth, false);
      expect(leap == regular, false);
    });

    test('unspecified leapMonth is treated as not leap', () {
      // Arrange
      Lunar fromSolar =
          Lunar(createdFromSolar: true, date: DateTime(1999, 6, 18));
      Lunar unspecified =
          Lunar(createdFromSolar: false, date: DateTime(1999, 5, 5));

      // Assert
      expect(unspecified.leapMonth, null);
      expect(fromSolar, unspecified);
      expect(fromSolar.hashCode, unspecified.hashCode);
    });
  });

  test('getSolar keeps hour, minute and second', () {
    // Arrange
    DateTime dateTime = DateTime(1998, 6, 18, 10, 30, 15);
    Lunar lunar = Lunar.fromSolar(Solar(dateTime));

    // Act
    Solar solar = lunar.getSolar();

    // Assert
    expect(solar, Solar(dateTime));
  });

  group('invalid lunar dates', () {
    test('Lunar.date with an existing leap month converts correctly', () {
      // Arrange
      Lunar lunar = Lunar.date(2023, 2, 2, leapMonth: true);

      // Act
      Solar solar = lunar.getSolar();

      // Assert
      expect(solar, Solar(DateTime(2023, 3, 23)));
    });

    test('getSolar throws for a leap month that does not exist', () {
      // Arrange
      // 2023's leap month is 2, not 5.
      Lunar lunar = Lunar.date(2023, 5, 1, leapMonth: true);

      // Assert
      expect(() => lunar.getSolar(), throwsArgumentError);
    });

    test('getSolar throws for a day that does not exist', () {
      // Arrange
      // A lunar month has 29 or 30 days.
      Lunar lunar = Lunar(createdFromSolar: false, date: DateTime(2023, 1, 31));

      // Assert
      expect(() => lunar.getSolar(), throwsArgumentError);
    });

    test('getSolar throws for day 30 in a 29-day month', () {
      // Arrange
      // Lunar month 1 of 2023 starts 22 Jan and month 2 starts 20 Feb,
      // so month 1 has 29 days.
      Lunar lunar = Lunar.date(2023, 1, 30);

      // Assert
      expect(() => lunar.getSolar(), throwsArgumentError);
    });

    test('getSolar throws for a year outside 1800-2199', () {
      // Arrange
      Lunar lunar = Lunar.date(2300, 1, 1);

      // Assert
      expect(() => lunar.getSolar(), throwsArgumentError);
    });

    test('creating from a solar date outside 1800-2199 throws', () {
      expect(
        () => Lunar(createdFromSolar: true, date: DateTime(1799, 12, 31)),
        throwsArgumentError,
      );
      expect(
        () => Lunar(createdFromSolar: true, date: DateTime(2200, 1, 1)),
        throwsArgumentError,
      );
    });

    test('the first and last supported solar dates are accepted', () {
      for (final date in [DateTime(1800, 1, 1), DateTime(2199, 12, 31)]) {
        // Act
        Lunar lunar = Lunar(createdFromSolar: true, date: date);

        // Assert
        expect(lunar.getSolar(), Solar(date));
      }
    });
  });
}
