/*import 'dart:convert';
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
    print(json);
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
*/
/*
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
  final String? legalName;
  final String? idImageUrl;
  final String? identityNumber;
  final String? phoneNumber;
  final String? seller;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    this.description,
    this.profileImageUrl,
    this.locationLatitude,
    this.locationLongitude,
    this.legalName,
    this.idImageUrl,
    this.identityNumber,
    this.phoneNumber,
    this.seller,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firebaseUid: json['firebase_uid'],
      name: json['name'],
      description: json['description'],
      profileImageUrl: json['profile_image_url'],
      locationLatitude: json['location_latitude'] != null
          ? double.tryParse(json['location_latitude'].toString())
          : null,
      locationLongitude: json['location_longitude'] != null
          ? double.tryParse(json['location_longitude'].toString())
          : null,
      legalName: json['legal_name'],
      idImageUrl: json['id_image_url'],
      identityNumber: json['identity_number'],
      phoneNumber: json['phone_number'],
      seller: json['seller'],
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
      'legal_name': legalName,
      'id_image_url': idImageUrl,
      'identity_number': identityNumber,
      'phone_number': phoneNumber,
      'seller': seller,
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
}*/

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
  final String? legalName;
  final String? idImageUrl;
  final String? identityNumber;
  final String? phoneNumber;
  final String? seller;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    this.description,
    this.profileImageUrl,
    this.locationLatitude,
    this.locationLongitude,
    this.legalName,
    this.idImageUrl,
    this.identityNumber,
    this.phoneNumber,
    this.seller,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['id'],
        firebaseUid: json['firebase_uid'],
        name: json['name'],
        description: json['description'],
        profileImageUrl: json['profile_image_url'],
        locationLatitude: json['location_latitude'] != null
            ? double.tryParse(json['location_latitude'].toString())
            : null,
        locationLongitude: json['location_longitude'] != null
            ? double.tryParse(json['location_longitude'].toString())
            : null,
        legalName: json['legal_name'],
        idImageUrl: json['id_image_url'],
        identityNumber: json['identity_number'],
        phoneNumber: json['phone_number'],
        seller: json['seller'],
      );
    } catch (e) {
      // Si ocurre un error, retorna un objeto UserModel vacío
      return UserModel(
        id: 0,
        firebaseUid: '',
        name: '',
        description: null,
        profileImageUrl: null,
        locationLatitude: null,
        locationLongitude: null,
        legalName: null,
        idImageUrl: null,
        identityNumber: null,
        phoneNumber: null,
        seller: null,
      );
    }
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
      'legal_name': legalName,
      'id_image_url': idImageUrl,
      'identity_number': identityNumber,
      'phone_number': phoneNumber,
      'seller': seller,
    };
  }
}

Future<void> saveUserToPreferences(UserModel user) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  } catch (e) {
    // Si ocurre un error al guardar en las preferencias, se puede registrar o manejar el error
    print("Error al guardar el usuario: $e");
  }
}

Future<void> removeUserFromPreferences() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  } catch (e) {
    // Si ocurre un error al eliminar de las preferencias, se puede registrar o manejar el error
    print("Error al eliminar el usuario de las preferencias: $e");
  }
}
