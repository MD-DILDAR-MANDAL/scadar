import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('ExpenseEntry')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text()();
  TextColumn get currency => text()();
}

@DataClassName('IncomeEntry')
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get dateAdded => dateTime()();
}

@DataClassName('BudgetEntry')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get limitAmount => real()();
  TextColumn get categoryName => text().nullable()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  TextColumn get currency => text()();
}

@DataClassName('RecurringTransactionEntry')
class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  BoolColumn get isIncome => boolean()();
  TextColumn get expenseCategoryName => text().nullable()();
  TextColumn get description => text()();
  TextColumn get currency => text()();
  TextColumn get interval => text()();
  DateTimeColumn get nextExecutionDate => dateTime()();
  BoolColumn get isActive => boolean()();
}

@DataClassName('ExchangeRateCacheEntry')
class ExchangeRateCaches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get baseCurrency => text().unique()();
  TextColumn get ratesJson => text()();
  DateTimeColumn get lastUpdated => dateTime()();
}

@DriftDatabase(tables: [Expenses, Incomes, Budgets, RecurringTransactions, ExchangeRateCaches])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'scadar.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}

