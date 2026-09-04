import 'package:isar_community/isar.dart';

part 'income_model.g.dart';

@collection
class IncomeModel {
  IncomeModel();

  Id id = Isar.autoIncrement;

  late double amount;

  late int month; // 1-12

  late int year;

  late String currency;

  late DateTime dateAdded;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'month': month,
      'year': year,
      'currency': currency,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    final model = IncomeModel()
      ..amount = (json['amount'] as num).toDouble()
      ..month = json['month'] as int
      ..year = json['year'] as int
      ..currency = json['currency'] as String? ?? 'USD'
      ..dateAdded = json['dateAdded'] != null
          ? DateTime.parse(json['dateAdded'] as String)
          : DateTime(json['year'] as int, json['month'] as int, 1);
    if (json['id'] != null && json['id'] is int && (json['id'] as int) > 0) {
      model.id = json['id'] as int;
    }
    return model;
  }
}
