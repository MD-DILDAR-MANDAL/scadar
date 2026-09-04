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
  ExpenseModel();

  Id id = Isar.autoIncrement;

  late double amount;

  @enumerated
  late ExpenseCategory category;

  late DateTime date;

  late String description;

  late String currency;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category.name,
      'date': date.toIso8601String(),
      'description': description,
      'currency': currency,
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    final model = ExpenseModel()
      ..amount = (json['amount'] as num).toDouble()
      ..category = ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.other,
      )
      ..date = DateTime.parse(json['date'] as String)
      ..description = json['description'] as String? ?? ''
      ..currency = json['currency'] as String? ?? 'USD';
    if (json['id'] != null && json['id'] is int && (json['id'] as int) > 0) {
      model.id = json['id'] as int;
    }
    return model;
  }
}
