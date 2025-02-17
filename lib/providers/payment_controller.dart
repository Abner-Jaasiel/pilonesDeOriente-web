/*import 'package:carkett/models/perfile_model.dart';
import 'package:flutter/material.dart';

class PaymentController with ChangeNotifier {
  double _amountToPay = 0.0;
  double _subtotal = 0.0;
  double _shipping = 0.0;

  String _legalName = '';
  String _location = '';
  int _userId = 0;
  String _locationDescription = '';
  String _provider = '';
  String _identityId = '';
  String _cardNumber = '';
  LocationCoordinates _coordinates = LocationCoordinates(lat: 0.0, long: 0.0);

  final List<String> _productIds = [];

  double get amountToPay => _amountToPay;
  double get subtotal => _subtotal;
  double get shipping => _shipping;
  String get legalName => _legalName;
  String get location => _location;
  int get userId => _userId;
  String get locationDescription => _locationDescription;
  String get provider => _provider;
  String get identityId => _identityId;
  String get cardNumber => _cardNumber;
  LocationCoordinates get coordinates => _coordinates;
  List<String> get productIds => _productIds;

  void setAmount(double amount) {
    _amountToPay = amount;
    notifyListeners();
  }

  void setSubtotal(double subtotal) {
    _subtotal = subtotal;
    _updateAmountToPay();
  }

  void setShipping(double shipping) {
    _shipping = shipping;
    _updateAmountToPay();
    notifyListeners();
  }

  set legalName(String legalName) {
    _legalName = legalName;
    notifyListeners();
  }

  set location(String location) {
    _location = location;
    notifyListeners();
  }

  set userId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  set locationDescription(String locationDescription) {
    _locationDescription = locationDescription;
    notifyListeners();
  }

  void setProvider(String provider) {
    _provider = provider;
    notifyListeners();
  }

  set identityId(String identityId) {
    _identityId = identityId;
    notifyListeners();
  }

  set cardNumber(String cardNumber) {
    _cardNumber = cardNumber;
    notifyListeners();
  }

  set coordinates(LocationCoordinates coordinates) {
    _coordinates = coordinates;
    notifyListeners();
  }

  void addProductId(String productId) {
    _productIds.add(productId);
    //notifyListeners();
  }

  void removeProductId(String productId) {
    _productIds.remove(productId);
    notifyListeners();
  }

  void _updateAmountToPay() {
    _amountToPay = _subtotal + _shipping;
  }
}*/

import 'package:flutter/material.dart';

class PaymentController with ChangeNotifier {
  double _amountToPay = 0.0;
  double _subtotal = 0.0;
  double _shipping = 0.0;

  String _legalName = '';
  String _location = '';
  int _userId = 0;
  String _locationDescription = '';
  String _provider = '';
  String _identityId = '';
  String _cardNumber = '';
  double _latitude = 0.0;
  double _longitude = 0.0;

  int _profileId = 0;

  final List<String> _productIds = [];

  double get amountToPay => _amountToPay;
  double get subtotal => _subtotal;
  double get shipping => _shipping;
  String get legalName => _legalName;
  String get location => _location;
  int get userId => _userId;
  String get locationDescription => _locationDescription;
  String get provider => _provider;
  String get identityId => _identityId;
  String get cardNumber => _cardNumber;
  double get latitude => _latitude;
  double get longitude => _longitude;
  List<String> get productIds => _productIds;
  int get profileId => _profileId;

  set profileId(int value) {
    _profileId = value;
    notifyListeners();
  }

  void setAmount(double amount) {
    _amountToPay = amount;
    notifyListeners();
  }

  void setSubtotal(double subtotal) {
    _subtotal = subtotal;
    _updateAmountToPay();
  }

  void setShipping(double shipping) {
    _shipping = shipping;
    _updateAmountToPay();
    notifyListeners();
  }

  set legalName(String legalName) {
    _legalName = legalName;
    notifyListeners();
  }

  set location(String location) {
    _location = location;
    notifyListeners();
  }

  set userId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  set locationDescription(String locationDescription) {
    _locationDescription = locationDescription;
    notifyListeners();
  }

  void setProvider(String provider) {
    _provider = provider;
    notifyListeners();
  }

  set identityId(String identityId) {
    _identityId = identityId;
    notifyListeners();
  }

  set cardNumber(String cardNumber) {
    _cardNumber = cardNumber;
    notifyListeners();
  }

  // Cambiado para ser un método en lugar de un setter
  void updateCoordinates(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }

  void productIdsClear() {
    _productIds.clear();
  }

  void addProductId(String productId) {
    _productIds.add(productId);
    notifyListeners();
  }

  void removeProductId(String productId) {
    _productIds.remove(productId);
    notifyListeners();
  }

  void _updateAmountToPay() {
    _amountToPay = _subtotal + _shipping;
  }
}
