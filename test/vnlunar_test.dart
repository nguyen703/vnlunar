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
}
