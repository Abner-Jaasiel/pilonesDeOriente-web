class ProfileModel {
  final int id;
  final int userId;
  final String legalName;
  final String locationDescription;
  final String cardNumber;
  final String identityNumber;
  final double locationLatitude;
  final double locationLongitude;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.legalName,
    required this.locationDescription,
    required this.cardNumber,
    required this.identityNumber,
    required this.locationLatitude,
    required this.locationLongitude,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      legalName: json['legal_name'],
      locationDescription: json['location_description'],
      cardNumber: json['card_number'],
      identityNumber: json['identity_number'],
      // Convierte de String a double si es necesario
      locationLatitude: (json['location_latitude'] != null)
          ? double.tryParse(json['location_latitude'].toString()) ?? 0.0
          : 0.0,
      locationLongitude: (json['location_longitude'] != null)
          ? double.tryParse(json['location_longitude'].toString()) ?? 0.0
          : 0.0,
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
    };
  }
}



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