import 'package:vnlunar/vnlunar.dart';

void main() {
  final lunar = Lunar(createdFromSolar: true, date: DateTime(1998, 6, 18));
  final solar = Solar(DateTime(1998, 6, 18));
  final convertedSolarFromLunar = lunar.getSolar();

  print(solar == convertedSolarFromLunar); // true
}
