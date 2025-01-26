import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends ChangeNotifier {
  LanguageController(this.languageCode);

  String? languageCode;
  late Locale _locale = Locale(languageCode ?? 'en');

  Locale get locale => _locale;

  void updateLocale(Locale newLocale) async {
    _locale = newLocale;
    SharedPreferences setLanguage = await SharedPreferences.getInstance();
    setLanguage.setString('language', newLocale.languageCode);
    notifyListeners();
  }
}
