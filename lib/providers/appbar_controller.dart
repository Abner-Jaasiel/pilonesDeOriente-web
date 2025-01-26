import 'package:flutter/material.dart';

class AppbarController extends ChangeNotifier {
  bool _withButtons = true;

  bool get withButtons => _withButtons;

  set withButtons(bool value) {
    _withButtons = value;
    notifyListeners();
  }
}
