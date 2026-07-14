import 'package:isar_community/isar.dart';

part 'income_model.g.dart';

@collection
class IncomeModel {
  Id id = Isar.autoIncrement;

  late double amount;

  late int month; // 1-12

  late int year;

  late String currency;

  late DateTime dateAdded;
}
