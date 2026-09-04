import 'package:isar_community/isar.dart';

part 'exchange_rate_cache_model.g.dart';

@collection
class ExchangeRateCacheModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String baseCurrency;

  late String ratesJson;

  late DateTime lastUpdated;
}
