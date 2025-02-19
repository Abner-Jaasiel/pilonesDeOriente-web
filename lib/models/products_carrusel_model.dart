/*class ProductCarruselModel {
  final String id;
  final String name;
  final double price;
  final double? locationLatitude;
  final double? locationLongitude;
  final String urlImage;
  final int? categoryId;
  final String? categoryName;
  final String? subcategoryName;
  final int? parentCategoryId; // Nuevo campo
  final List<String> tags;
  final int rating;
  final bool onSale;
  final DateTime createdAt;
  final String sellerFirebaseUid;

  ProductCarruselModel({
    required this.id,
    required this.name,
    required this.price,
    this.locationLatitude,
    this.locationLongitude,
    required this.urlImage,
    this.categoryId,
    this.categoryName,
    this.subcategoryName,
    this.parentCategoryId, // Inicialización
    required this.tags,
    required this.rating,
    required this.onSale,
    required this.createdAt,
    required this.sellerFirebaseUid,
  });

  factory ProductCarruselModel.fromJson(Map<String, dynamic> json) {
    return ProductCarruselModel(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
      locationLatitude: json['location_latitude'] != null
          ? double.parse(json['location_latitude'])
          : null,
      locationLongitude: json['location_longitude'] != null
          ? double.parse(json['location_longitude'])
          : null,
      urlImage: json['urlimage'],
      categoryId:
          json['category_id'] != null ? json['category_id'] as int : null,
      categoryName: json['category_name'],
      subcategoryName: json['subcategory_name'],
      parentCategoryId: json['parent_category_id'] != null
          ? json['parent_category_id'] as int
          : null, // Conversión desde el JSON
      tags: List<String>.from(json['tags']),
      rating: json['rating'],
      onSale: json['onsale'],
      createdAt: DateTime.parse(json['createdat']),
      sellerFirebaseUid: json['seller_firebase_uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'urlimage': urlImage,
      'category_id': categoryId,
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'parent_category_id': parentCategoryId, // Agregado en toJson
      'tags': tags,
      'rating': rating,
      'onsale': onSale,
      'createdat': createdAt.toIso8601String(),
      'seller_firebase_uid': sellerFirebaseUid,
    };
  }
}
*/

class ProductCarruselModel {
  final String id;
  final String name;
  final double price;
  final double? locationLatitude;
  final double? locationLongitude;
  final String urlImage;
  final int? categoryId;
  final String? categoryName;
  final String? subcategoryName;
  final int? parentCategoryId;
  final List<String> tags;
  final int rating;
  final bool onSale;
  final DateTime createdAt;
  final String sellerFirebaseUid;

  ProductCarruselModel({
    required this.id,
    required this.name,
    required this.price,
    this.locationLatitude,
    this.locationLongitude,
    required this.urlImage,
    this.categoryId,
    this.categoryName,
    this.subcategoryName,
    this.parentCategoryId,
    required this.tags,
    required this.rating,
    required this.onSale,
    required this.createdAt,
    required this.sellerFirebaseUid,
  });

  factory ProductCarruselModel.fromJson(Map<String, dynamic> json) {
    try {
      return ProductCarruselModel(
        id: json['id'] ?? '', // Prevenir null
        name: json['name'] ?? '',
        price: json['price'] != null
            ? double.parse(json['price'].toString())
            : 0.0,
        locationLatitude: json['location_latitude'] != null
            ? double.tryParse(json['location_latitude'].toString())
            : null,
        locationLongitude: json['location_longitude'] != null
            ? double.tryParse(json['location_longitude'].toString())
            : null,
        urlImage: json['urlimage'] ?? '', // Prevenir null
        categoryId:
            json['category_id'] != null ? json['category_id'] as int : null,
        categoryName: json['category_name'],
        subcategoryName: json['subcategory_name'],
        parentCategoryId: json['parent_category_id'] != null
            ? json['parent_category_id'] as int
            : null,
        tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
        rating: json['rating'] ?? 0, // Prevenir null
        onSale: json['onsale'] ?? false, // Prevenir null
        createdAt: json['createdat'] != null
            ? DateTime.tryParse(json['createdat']) ?? DateTime.now()
            : DateTime.now(),
        sellerFirebaseUid: json['seller_firebase_uid'] ?? '',
      );
    } catch (e) {
      // Si ocurre un error, retornamos un modelo con valores por defecto
      return ProductCarruselModel(
        id: '',
        name: '',
        price: 0.0,
        urlImage: '',
        tags: [],
        rating: 0,
        onSale: false,
        createdAt: DateTime.now(),
        sellerFirebaseUid: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'urlimage': urlImage,
      'category_id': categoryId,
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'parent_category_id': parentCategoryId,
      'tags': tags,
      'rating': rating,
      'onsale': onSale,
      'createdat': createdAt.toIso8601String(),
      'seller_firebase_uid': sellerFirebaseUid,
    };
  }
}
