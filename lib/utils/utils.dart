import 'dart:convert';

import 'package:carkett/models/user_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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

const String _apiKey = '2bf6df60f4a4438ab4df1492943a718a'; // Tu API Key

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
