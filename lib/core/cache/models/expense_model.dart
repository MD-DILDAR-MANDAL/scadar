import 'package:isar_community/isar.dart';

part 'expense_model.g.dart';

enum ExpenseCategory {
  housing,
  utilities,
  health,
  subscription,
  shopping,
  travel,
  business,
  other
}

@collection
class ExpenseModel {
  Id id = Isar.autoIncrement;

  late double amount;

  @enumerated
  late ExpenseCategory category;

  late DateTime date;

  late String description;

  late String currency;
}
