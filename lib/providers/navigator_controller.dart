/*import 'package:flutter/material.dart';

class NavigatorController with ChangeNotifier {
  int _currentIndex = 0;
  late PageController _pageController;

  NavigatorController() {
    _pageController = PageController(initialPage: _currentIndex);
  }

  PageController get pageController => _pageController;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
*/

// NavigatorController.dart
import 'package:flutter/material.dart';

class NavigatorController with ChangeNotifier {
  int _currentIndex = 0;
  late PageController _pageController;

  NavigatorController() {
    _pageController = PageController(initialPage: _currentIndex);
  }

  PageController get pageController => _pageController;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void initializePageController() {
    _pageController = PageController(initialPage: _currentIndex);
    //notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
