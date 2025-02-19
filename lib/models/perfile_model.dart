/*class ProfileModel {
  final int id;
  final int userId;
  final String legalName;
  final String locationDescription;
  final String cardNumber;
  final String identityNumber;
  final double locationLatitude;
  final double locationLongitude;
  final String phoneNumber;
  final bool isDefault;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.legalName,
    required this.locationDescription,
    required this.cardNumber,
    required this.identityNumber,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.phoneNumber,
    required this.isDefault,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      legalName: json['legal_name'],
      locationDescription: json['location_description'],
      cardNumber: json['card_number'],
      identityNumber: json['identity_number'],
      locationLatitude: (json['location_latitude'] != null)
          ? double.tryParse(json['location_latitude'].toString()) ?? 0.0
          : 0.0,
      locationLongitude: (json['location_longitude'] != null)
          ? double.tryParse(json['location_longitude'].toString()) ?? 0.0
          : 0.0,
      phoneNumber: json['phone_number'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'legal_name': legalName,
      'location_description': locationDescription,
      'card_number': cardNumber,
      'identity_number': identityNumber,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'phone_number': phoneNumber,
      'is_default': isDefault,
    };
  }
}*/

/*
class LocationCoordinates {
  final double lat;
  final double long;

  LocationCoordinates({required this.lat, required this.long});

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) {
    return LocationCoordinates(
      lat: json['x'].toDouble(),
      long: json['y'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': lat,
      'y': long,
    };
  }
}
*/

class ProfileModel {
  final int id;
  final int userId;
  final String legalName;
  final String locationDescription;
  final String cardNumber;
  final String identityNumber;
  final double locationLatitude;
  final double locationLongitude;
  final String phoneNumber;
  final bool isDefault;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.legalName,
    required this.locationDescription,
    required this.cardNumber,
    required this.identityNumber,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.phoneNumber,
    required this.isDefault,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    try {
      return ProfileModel(
        id: json['id'] ?? 0, // Default to 0 if null
        userId: json['user_id'] ?? 0, // Default to 0 if null
        legalName: json['legal_name'] ?? '', // Default empty string if null
        locationDescription:
            json['location_description'] ?? '', // Default empty string if null
        cardNumber: json['card_number'] ?? '', // Default empty string if null
        identityNumber:
            json['identity_number'] ?? '', // Default empty string if null
        locationLatitude: (json['location_latitude'] != null)
            ? double.tryParse(json['location_latitude'].toString()) ?? 0.0
            : 0.0, // Default to 0.0 if parsing fails
        locationLongitude: (json['location_longitude'] != null)
            ? double.tryParse(json['location_longitude'].toString()) ?? 0.0
            : 0.0, // Default to 0.0 if parsing fails
        phoneNumber: json['phone_number'] ?? '', // Default empty string if null
        isDefault: json['is_default'] ?? false, // Default to false if null
      );
    } catch (e) {
      print('Error deserializando ProfileModel: $e');
      // En caso de error, devolver un modelo con valores predeterminados
      return ProfileModel(
        id: 0,
        userId: 0,
        legalName: '',
        locationDescription: '',
        cardNumber: '',
        identityNumber: '',
        locationLatitude: 0.0,
        locationLongitude: 0.0,
        phoneNumber: '',
        isDefault: false,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'legal_name': legalName,
      'location_description': locationDescription,
      'card_number': cardNumber,
      'identity_number': identityNumber,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'phone_number': phoneNumber,
      'is_default': isDefault,
    };
  }
}
