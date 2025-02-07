import 'package:flutter/material.dart';

class RegisterDataController with ChangeNotifier {
  String _name = '';
  DateTime _birthDate = DateTime.now();
  String _selectedGender = 'Male';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _termsConditions = false;
  bool _delAccount = false;

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  DateTime get birthDate => _birthDate;
  set birthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  String get selectedGender => _selectedGender;
  set selectedGender(String value) {
    _selectedGender = value;
    notifyListeners();
  }

  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get confirmPassword => _confirmPassword;
  set confirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  bool get termsConditions => _termsConditions;
  set termsConditions(bool value) {
    _termsConditions = value;
    notifyListeners();
  }

  bool get isPasswordMatching => _password == _confirmPassword;
  bool get delAccount => _delAccount;
  set delAccount(bool value) {
    _delAccount = value;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
