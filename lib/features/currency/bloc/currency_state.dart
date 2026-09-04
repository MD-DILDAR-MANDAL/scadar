import 'package:equatable/equatable.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final double convertedAmount;
  final List<String> availableCurrencies;
  final String globalCurrency;
  final Map<String, double> ratesMap;

  const CurrencyLoaded({
    required this.convertedAmount,
    required this.availableCurrencies,
    required this.globalCurrency,
    required this.ratesMap,
  });

  @override
  List<Object?> get props => [
        convertedAmount,
        availableCurrencies,
        globalCurrency,
        ratesMap,
      ];
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError(this.message);

  @override
  List<Object?> get props => [message];
}
