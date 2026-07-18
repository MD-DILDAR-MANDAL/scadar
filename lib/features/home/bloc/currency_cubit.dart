import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scadar/core/repository/currency_repository.dart';
import 'package:scadar/core/repository/settings_repository.dart';

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
  List<Object?> get props => [convertedAmount, availableCurrencies, globalCurrency, ratesMap];
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError(this.message);

  @override
  List<Object?> get props => [message];
}

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _currencyRepository;
  final SettingsRepository _settingsRepository;
  
  List<String> _availableCurrencies = [];
  String _globalCurrency = 'USD';
  Map<String, double> _ratesMap = {};

  CurrencyCubit({
    required CurrencyRepository currencyRepository,
    required SettingsRepository settingsRepository,
  })  : _currencyRepository = currencyRepository,
        _settingsRepository = settingsRepository,
        super(CurrencyInitial());

  Future<void> initGlobalCurrency() async {
    emit(CurrencyLoading());
    try {
      _globalCurrency = await _settingsRepository.getGlobalCurrency();
      _availableCurrencies = await _currencyRepository.getAvailableCurrencies();
      _ratesMap = await _currencyRepository.fetchRatesForBase(_globalCurrency);
      
      emit(CurrencyLoaded(
        convertedAmount: 0,
        availableCurrencies: _availableCurrencies,
        globalCurrency: _globalCurrency,
        ratesMap: _ratesMap,
      ));
    } catch (e) {
      emit(const CurrencyError('Failed to initialize global currency'));
    }
  }

  Future<void> setGlobalCurrency(String currency) async {
    emit(CurrencyLoading());
    try {
      await _settingsRepository.saveGlobalCurrency(currency);
      _globalCurrency = currency;
      _ratesMap = await _currencyRepository.fetchRatesForBase(_globalCurrency);
      
      emit(CurrencyLoaded(
        convertedAmount: 0,
        availableCurrencies: _availableCurrencies,
        globalCurrency: _globalCurrency,
        ratesMap: _ratesMap,
      ));
    } catch (e) {
      emit(const CurrencyError('Failed to set global currency'));
    }
  }

  Future<void> fetchAvailableCurrencies() async {
    try {
      if (_availableCurrencies.isEmpty) {
        _availableCurrencies = await _currencyRepository.getAvailableCurrencies();
      }
      if (state is CurrencyLoaded) {
        final st = state as CurrencyLoaded;
        emit(CurrencyLoaded(
          convertedAmount: st.convertedAmount,
          availableCurrencies: _availableCurrencies,
          globalCurrency: _globalCurrency,
          ratesMap: _ratesMap,
        ));
      }
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
      emit(CurrencyLoaded(
        convertedAmount: result,
        availableCurrencies: _availableCurrencies,
        globalCurrency: _globalCurrency,
        ratesMap: _ratesMap,
      ));
    } catch (e) {
      emit(CurrencyError('Conversion failed: $e'));
    }
  }
}
