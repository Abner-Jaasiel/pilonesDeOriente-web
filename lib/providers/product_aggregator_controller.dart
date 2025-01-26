import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProductAggregatorController extends ChangeNotifier {
  final List<XFile> _pickedFile = [];

  set pickedFile(List<XFile> value) {
    _pickedFile.clear();
    _pickedFile.addAll(value);
    notifyListeners();
  }

  List<XFile> get pickedFile => _pickedFile;
}
