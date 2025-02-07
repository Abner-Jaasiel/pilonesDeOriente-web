import 'dart:convert';

import 'dart:typed_data';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'package:carkett/models/user_model.dart';
import 'package:carkett/providers/appconfig_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

List<Icon> ratinginfo(int rating) {
  List<Icon> starRatingIcon = [];

  for (var i = 0; i < rating; i++) {
    starRatingIcon.add(const Icon(Icons.star));
  }
  if (rating < 5) {
    for (var i = 0; i < (5 - rating); i++) {
      starRatingIcon.add(const Icon(Icons.star_border));
    }
  }
  return starRatingIcon;
}

Future<UserModel?> getUserData(String firebaseUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user');

  if (userJson != null) {
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserModel.fromJson(userMap);
  } else {
    Map<String, dynamic> userFromApi =
        await APIService().getUserWithFirebaseId(firebaseUid);

    UserModel userModel = UserModel.fromJson(userFromApi);

    await prefs.setString('user', jsonEncode(userModel.toJson()));

    return userModel;
  }
}

Future<UserModel?> loadUserFromPreferences(String firebaseUid,
    {bool loadFromServer = false}) async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  String? userJson = loadFromServer == false ? prefs.getString('user') : null;

  if (userJson != null && loadFromServer == false) {
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserModel.fromJson(userMap);
  } else {
    try {
      Map<String, dynamic> userData =
          await APIService().getUserWithFirebaseId(firebaseUid);

      UserModel user = UserModel.fromJson(userData);

      await prefs.setString('user', jsonEncode(user.toJson()));

      return user;
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }
}

Future<UserModel?> loadExternalUser(
  String firebaseUid,
) async {
  try {
    Map<String, dynamic> userData =
        await APIService().getUserWithFirebaseId(firebaseUid);

    UserModel user = UserModel.fromJson(userData);
    return user;
  } catch (error) {
    print('Error: $error');
    return null;
  }
}

Future<void> updateUserInPreferences(UserModel data,
    {required String update, required dynamic valueUpdate}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? userJson = prefs.getString('user');

  Map<String, dynamic> mapData;

  if (userJson != null) {
    mapData = jsonDecode(userJson);
  } else {
    mapData = {
      "id": data.id,
      "firebase_uid": data.firebaseUid,
      "name": data.name,
      "description": data.description,
      "profile_image_url": data.profileImageUrl,
      "location_latitude": data.locationLatitude,
      "location_longitude": data.locationLongitude,
    };
  }

  switch (update) {
    case "name":
      mapData["name"] = valueUpdate;
      break;
    case "description":
      mapData["description"] = valueUpdate;
      break;
    case "profile_image_url":
      mapData["profile_image_url"] = valueUpdate;
      break;
    case "location_latitude":
      mapData["location_latitude"] = valueUpdate;
      break;
    case "location_longitude":
      mapData["location_longitude"] = valueUpdate;
      break;
    default:
      break;
  }

  String updatedUserJson = jsonEncode(mapData);
  await prefs.setString('user', updatedUserJson);
}

const String _apiKey = '2bf6df60f4a4438ab4df1492943a718a';

Future<String?> getLocationName(LatLng location) async {
  final url =
      'https://api.opencagedata.com/geocode/v1/json?q=${location.latitude}+${location.longitude}&key=$_apiKey';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']?.first['formatted'];
    } else {
      return "Error retrieving location name. Code: ${response.statusCode}";
    }
  } catch (e) {
    return "Error retrieving location name: $e";
  }
}
/*
double convertAmountToCurrency(double amount, BuildContext context) {
  final currencyValue =
      Provider.of<AppConfigController>(context, listen: false).currencyValue;
  final currency =
      Provider.of<AppConfigController>(context, listen: false).currency;

  if (currency == 'USD') {
    return amount;
  } else {
    return amount * currencyValue;
  }
}*/

String getFormattedCurrency(double amount, BuildContext context) {
  final currencyValue =
      Provider.of<AppConfigController>(context, listen: false).currencyValue;
  final currency =
      Provider.of<AppConfigController>(context, listen: false).currency;

  double convertedAmount =
      (currency == 'USD') ? amount : amount * currencyValue;

  final formatter = NumberFormat('#,##0', 'en_US');
  String formattedAmount = formatter.format(convertedAmount);

  return '$currency $formattedAmount';
}

class ImageValidation {
  static Future<String> validateImage(XFile imageFile) async {
    File file = File(imageFile.path);
    List<int> bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

    if (image == null) {
      return "Error al procesar la imagen";
    }

    if (image.width < 800 || image.height < 600) {
      return "La imagen es demasiado pequeña. Se requiere una resolución mayor.";
    }

    double sharpness = _calculateSharpness(image);
    if (sharpness < 36.0) {
      return "La imagen está borrosa. Intente cargar una imagen más clara.";
    }

    return "La imagen es válida";
  }

  static double _calculateSharpness(img.Image image) {
    double laplacian = 0.0;

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        img.Pixel pixel = image.getPixel(x, y);
        img.Pixel pixelRight = image.getPixel(x + 1, y);
        img.Pixel pixelBottom = image.getPixel(x, y + 1);

        int diffRight = _getLuminance(pixelRight) - _getLuminance(pixel);
        int diffBottom = _getLuminance(pixelBottom) - _getLuminance(pixel);

        laplacian += diffRight * diffRight + diffBottom * diffBottom;
      }
    }

    return laplacian / (image.width * image.height);
  }

  static int _getLuminance(img.Pixel pixel) {
    int r = pixel.r.toInt();
    int g = pixel.g.toInt();
    int b = pixel.b.toInt();
    return (0.299 * r + 0.587 * g + 0.114 * b).round();
  }
}

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("⚠️ El GPS está desactivado.");
        return null;
      }

      // 2️⃣ Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint("❌ Permiso de ubicación denegado.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint("⛔ Permiso de ubicación bloqueado permanentemente.");
        return null;
      }

      // 3️⃣ Obtener la ubicación con manejo de errores
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint(
          "📍 Latitud: ${position.latitude}, Longitud: ${position.longitude}");
      return position;
    } catch (e) {
      debugPrint("🚨 Error al obtener ubicación: $e");
      return null;
    }
  }
}
