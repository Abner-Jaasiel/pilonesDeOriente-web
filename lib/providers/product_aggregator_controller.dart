import 'package:carkett/widgets/cards/flutter_product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProductAggregatorController extends ChangeNotifier {
  final List<XFile> _pickedFile = [];
  String _categoryName = "";
  String _productId = "";

  set pickedFile(List<XFile> value) {
    _pickedFile.clear();
    _pickedFile.addAll(value);
    notifyListeners();
  }

  void clean() {
    _pickedFile.clear();
    notifyListeners();
  }

  List<XFile> get pickedFile => _pickedFile;

  String get categoryName => _categoryName;
  String get productId => _productId;

  set categoryName(String name) {
    _categoryName = name;
    notifyListeners();
  }

  set productId(String value) {
    _productId = value;
    // notifyListeners();
  }
}
