import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object?> get props => [];
}

class InitGlobalCurrencyEvent extends CurrencyEvent {
  const InitGlobalCurrencyEvent();
}

class SetGlobalCurrencyEvent extends CurrencyEvent {
  final String currency;

  const SetGlobalCurrencyEvent(this.currency);

  @override
  List<Object?> get props => [currency];
}

class FetchAvailableCurrenciesEvent extends CurrencyEvent {
  const FetchAvailableCurrenciesEvent();
}

class ConvertCurrencyEvent extends CurrencyEvent {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  const ConvertCurrencyEvent({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  List<Object?> get props => [amount, fromCurrency, toCurrency];
}
