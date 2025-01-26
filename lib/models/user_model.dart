import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final int id;
  final String firebaseUid;
  final String name;
  final String? description;
  final String? profileImageUrl;
  final double? locationLatitude;
  final double? locationLongitude;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    this.description,
    this.profileImageUrl,
    this.locationLatitude,
    this.locationLongitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firebaseUid: json['firebase_uid'],
      name: json['name'],
      description: json['description'],
      profileImageUrl: json['profile_image_url'],
      locationLatitude: json['location_latitude']?.toDouble(),
      locationLongitude: json['location_longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'name': name,
      'description': description,
      'profile_image_url': profileImageUrl,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
    };
  }
}

Future<void> saveUserToPreferences(UserModel user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userJson = jsonEncode(user.toJson());
  await prefs.setString('user', userJson);
}

Future<void> removeUserFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
}
