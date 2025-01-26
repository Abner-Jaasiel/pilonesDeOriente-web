import 'package:flutter/material.dart';

class SearchFilterController extends ChangeNotifier {
  List<String> _tags = [];
  String _categoryName = '';
  int _categoryId = 0;
  String _seller = '';
  String _name = '';

  List<String> get tags => _tags;
  String get categoryName => _categoryName;
  int get categoryId => _categoryId;
  String get seller => _seller;
  String get name => _name;

  set tags(List<String> newTags) {
    _tags = newTags;
    notifyListeners();
  }

  set categoryName(String newCategoryName) {
    _categoryName = newCategoryName;
    notifyListeners();
  }

  set categoryId(int newCategoryId) {
    _categoryId = newCategoryId;
    notifyListeners();
  }

  set seller(String newSeller) {
    _seller = newSeller;
    notifyListeners();
  }

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void clearCategory() {
    _categoryName = '';
    _categoryId = 0;
    notifyListeners();
  }
}
