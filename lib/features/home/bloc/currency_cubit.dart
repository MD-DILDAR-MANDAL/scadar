import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scadar/core/repository/currency_repository.dart';

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
  
  const CurrencyLoaded(this.convertedAmount, this.availableCurrencies);

  @override
  List<Object?> get props => [convertedAmount, availableCurrencies];
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError(this.message);

  @override
  List<Object?> get props => [message];
}

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _currencyRepository;
  List<String> _availableCurrencies = [];

  CurrencyCubit({required CurrencyRepository currencyRepository})
      : _currencyRepository = currencyRepository,
        super(CurrencyInitial());

  Future<void> fetchAvailableCurrencies() async {
    try {
      if (_availableCurrencies.isEmpty) {
        _availableCurrencies = await _currencyRepository.getAvailableCurrencies();
      }
      emit(CurrencyLoaded(0, _availableCurrencies));
    } catch (e) {
      emit(const CurrencyError('Failed to load currencies'));
    }
  }

  Future<void> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    emit(CurrencyLoading());
    try {
      if (_availableCurrencies.isEmpty) {
        _availableCurrencies = await _currencyRepository.getAvailableCurrencies();
      }
      
      final result = await _currencyRepository.convert(
        amount: amount,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );
      emit(CurrencyLoaded(result, _availableCurrencies));
    } catch (e) {
      emit(CurrencyError('Conversion failed: $e'));
    }
  }
}
