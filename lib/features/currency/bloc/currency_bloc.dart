import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scadar/core/repositories/currency_repository.dart';
import 'package:scadar/core/repositories/settings_repository.dart';
import 'package:scadar/features/currency/bloc/currency_event.dart';
import 'package:scadar/features/currency/bloc/currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _currencyRepository;
  final SettingsRepository _settingsRepository;

  List<String> _availableCurrencies = [];
  String _globalCurrency = 'USD';
  Map<String, double> _ratesMap = {};

  CurrencyBloc({
    required CurrencyRepository currencyRepository,
    required SettingsRepository settingsRepository,
  })  : _currencyRepository = currencyRepository,
        _settingsRepository = settingsRepository,
        super(CurrencyInitial()) {
    on<InitGlobalCurrencyEvent>(_onInitGlobalCurrency);
    on<SetGlobalCurrencyEvent>(_onSetGlobalCurrency);
    on<FetchAvailableCurrenciesEvent>(_onFetchAvailableCurrencies);
    on<ConvertCurrencyEvent>(_onConvertCurrency);
  }

  Future<void> _onInitGlobalCurrency(
    InitGlobalCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) async {
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

  Future<void> _onSetGlobalCurrency(
    SetGlobalCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    try {
      await _settingsRepository.saveGlobalCurrency(event.currency);
      _globalCurrency = event.currency;
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

  Future<void> _onFetchAvailableCurrencies(
    FetchAvailableCurrenciesEvent event,
    Emitter<CurrencyState> emit,
  ) async {
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

  Future<void> _onConvertCurrency(
    ConvertCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    try {
      if (_availableCurrencies.isEmpty) {
        _availableCurrencies = await _currencyRepository.getAvailableCurrencies();
      }

      final result = await _currencyRepository.convert(
        amount: event.amount,
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
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
