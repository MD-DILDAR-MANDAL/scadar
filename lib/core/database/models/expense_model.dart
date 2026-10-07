enum ExpenseCategory {
  housing,
  utilities,
  health,
  subscription,
  shopping,
  travel,
  business,
  other,
}

class ExpenseModel {
  ExpenseModel();

  int id = 0;

  late double amount;

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
