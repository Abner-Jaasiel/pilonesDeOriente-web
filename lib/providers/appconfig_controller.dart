import 'package:carkett/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigController with ChangeNotifier {
  String _currency = "USD";
  double _currencyValue = 1.0;
  bool _isSeller = false;

  String get currency => _currency;
  double get currencyValue => _currencyValue;
  bool get isSeller => _isSeller;

  Future<void> loadConfig() async {
    await initLoadCurrency();
  }

  Future<void> initLoadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString('currency') ?? 'USD';
    _currencyValue = prefs.getDouble('currencyValue') ?? 1.0;
    if (_currency != 'USD') {
      _currencyValue = await APIService().getCurrencyValue(_currency);
    }

    // notifyListeners();
  }

  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString('currency') ?? 'USD';
    _currencyValue = prefs.getDouble('currencyValue') ?? 1.0;
    if (_currency != 'USD') {
      _currencyValue = await APIService().getCurrencyValue(_currency);
    }

    notifyListeners();
  }

  set isSeller(bool value) {
    _isSeller = value;
    //notifyListeners();
  }

/*
  void setCurrency(String newCurrency, double newCurrencyValue) {
    _currency = newCurrency;
    _currencyValue = newCurrencyValue;
    notifyListeners();
  }*/
}
