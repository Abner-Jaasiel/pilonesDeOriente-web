import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends ChangeNotifier {
  double? _locationLat;
  double? _locationLng;
  String? _locationName;

  double? get locationLat => _locationLat;
  double? get locationLng => _locationLng;
  String? get locationName => _locationName;

  void setLocation(LatLng location) {
    _locationLat = location.latitude;
    _locationLng = location.longitude;
    notifyListeners();
  }

  void setLocationName(String? name) {
    _locationName = name;
    notifyListeners();
  }
}
