import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  int _imageIndex = 0;
  int _lengthImages = 0;

  int get lengthImages => _lengthImages;

  set lengthImages(int length) {
    _lengthImages = length;
    //notifyListeners();
  }

  int get imageIndex => _imageIndex;

  set imageIndex(int index) {
    _imageIndex = index;
    notifyListeners();
  }
}
