/*class OrderSellerModel {
  final int cartItemId;
  final String buyerFirebaseUid;
  final int productId;
  final int quantity;
  final DateTime addedAt;
  final int orderId;
  final List<String> urlImage;
  final double price;
  final double discountPrice;
  final String sellerFirebaseUid;
  final DateTime productCreatedAt;
  final DateTime productUpdatedAt;
  final List<String> tags;
  final int categoryId;
  final double totalPrice;
  final String status;
  final String legalName;
  final String identityNumber;
  final double? locationLatitude;
  final double? locationLongitude;
  final String phoneNumber;

  OrderSellerModel({
    required this.cartItemId,
    required this.buyerFirebaseUid,
    required this.productId,
    required this.quantity,
    required this.addedAt,
    required this.orderId,
    required this.urlImage,
    required this.price,
    required this.discountPrice,
    required this.sellerFirebaseUid,
    required this.productCreatedAt,
    required this.productUpdatedAt,
    required this.tags,
    required this.categoryId,
    required this.totalPrice,
    required this.status,
    required this.legalName,
    required this.identityNumber,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.phoneNumber,
  });

  factory OrderSellerModel.fromJson(Map<String, dynamic> json) {
    return OrderSellerModel(
      cartItemId: json['cart_item_id'] is int
          ? json['cart_item_id']
          : int.tryParse(json['cart_item_id'].toString()) ?? 0,
      buyerFirebaseUid: json['buyer_firebase_uid'],
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id'].toString()) ?? 0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
      addedAt: DateTime.parse(json['added_at']),
      orderId: json['order_id'] is int
          ? json['order_id']
          : int.tryParse(json['order_id'].toString()) ?? 0,
      urlImage: List<String>.from(json['urlimage']),
      price: double.parse(json['price']),
      discountPrice: json['discountprice'] is String
          ? double.parse(json['discountprice'] ?? '0')
          : json['discountprice'] is int
              ? json['discountprice'].toDouble()
              : 0.0,

      sellerFirebaseUid: json['seller_firebase_uid'],
      productCreatedAt: DateTime.parse(json['product_created_at']),
      productUpdatedAt: DateTime.parse(json['product_updated_at']),
      tags: (json['tags'] is List)
          ? List<String>.from(json['tags'])
          : [], // Asegura que sea una lista de String
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id'].toString()) ?? 0,
      totalPrice: (json['total_price'] is String &&
              json['total_price'] != 'NaN')
          ? double.parse(json['total_price'])
          : (json['total_price'] is num ? json['total_price'].toDouble() : 0.0),

      status: json['status'],
      legalName: json['legal_name'],
      identityNumber: json['identity_number'],

      locationLatitude: json['location_latitude'] != null
          ? double.parse(json['location_latitude'])
          : null,
      locationLongitude: json['location_longitude'] != null
          ? double.parse(json['location_longitude'])
          : null,

      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'buyer_firebase_uid': buyerFirebaseUid,
      'product_id': productId,
      'quantity': quantity,
      'added_at': addedAt.toIso8601String(),
      'order_id': orderId,
      'urlimage': urlImage,
      'price': price,
      'discountprice': discountPrice,
      'seller_firebase_uid': sellerFirebaseUid,
      'product_created_at': productCreatedAt.toIso8601String(),
      'product_updated_at': productUpdatedAt.toIso8601String(),
      'tags': tags,
      'category_id': categoryId,
      'total_price': totalPrice,
      'status': status,
      'legal_name': legalName,
      'identity_number': identityNumber,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'phone_number': phoneNumber,
    };
  }
}*/

class OrderSellerModel {
  final int cartItemId;
  final String buyerFirebaseUid;
  final int productId;
  final int quantity;
  final DateTime addedAt;
  final int orderId;
  final List<String> urlImage;
  final double price;
  final double discountPrice;
  final String sellerFirebaseUid;
  final DateTime productCreatedAt;
  final DateTime productUpdatedAt;
  final List<String> tags;
  final int categoryId;
  final double totalPrice;
  final String status;
  final String legalName;
  final String identityNumber;
  final double? locationLatitude;
  final double? locationLongitude;
  final String phoneNumber;

  OrderSellerModel({
    required this.cartItemId,
    required this.buyerFirebaseUid,
    required this.productId,
    required this.quantity,
    required this.addedAt,
    required this.orderId,
    required this.urlImage,
    required this.price,
    required this.discountPrice,
    required this.sellerFirebaseUid,
    required this.productCreatedAt,
    required this.productUpdatedAt,
    required this.tags,
    required this.categoryId,
    required this.totalPrice,
    required this.status,
    required this.legalName,
    required this.identityNumber,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.phoneNumber,
  });

  factory OrderSellerModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderSellerModel(
        cartItemId: _parseInt(json['cart_item_id']),
        buyerFirebaseUid: json['buyer_firebase_uid'] ?? '',
        productId: _parseInt(json['product_id']),
        quantity: _parseInt(json['quantity']),
        addedAt: DateTime.tryParse(json['added_at'] ?? '') ?? DateTime.now(),
        orderId: _parseInt(json['order_id']),
        urlImage:
            json['urlimage'] is List ? List<String>.from(json['urlimage']) : [],
        price: _parseDouble(json['price']),
        discountPrice: _parseDiscountPrice(json['discountprice']),
        sellerFirebaseUid: json['seller_firebase_uid'] ?? '',
        productCreatedAt: DateTime.tryParse(json['product_created_at'] ?? '') ??
            DateTime.now(),
        productUpdatedAt: DateTime.tryParse(json['product_updated_at'] ?? '') ??
            DateTime.now(),
        tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
        categoryId: _parseInt(json['category_id']),
        totalPrice: _parseDouble(json['total_price']),
        status: json['status'] ?? '',
        legalName: json['legal_name'] ?? '',
        identityNumber: json['identity_number'] ?? '',
        locationLatitude: _parseDouble(json['location_latitude']),
        locationLongitude: _parseDouble(json['location_longitude']),
        phoneNumber: json['phone_number'] ?? '',
      );
    } catch (e) {
      print('Error parsing OrderSellerModel: $e');
      rethrow; // Opcionalmente, podemos lanzar la excepción nuevamente o devolver valores predeterminados.
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'buyer_firebase_uid': buyerFirebaseUid,
      'product_id': productId,
      'quantity': quantity,
      'added_at': addedAt.toIso8601String(),
      'order_id': orderId,
      'urlimage': urlImage,
      'price': price,
      'discountprice': discountPrice,
      'seller_firebase_uid': sellerFirebaseUid,
      'product_created_at': productCreatedAt.toIso8601String(),
      'product_updated_at': productUpdatedAt.toIso8601String(),
      'tags': tags,
      'category_id': categoryId,
      'total_price': totalPrice,
      'status': status,
      'legal_name': legalName,
      'identity_number': identityNumber,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'phone_number': phoneNumber,
    };
  }

  // Métodos de ayuda para manejar conversiones y control de errores
  static int _parseInt(dynamic value) {
    try {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    } catch (e) {
      print('Error parsing int: $e');
      return 0;
    }
  }

  static double _parseDouble(dynamic value) {
    try {
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    } catch (e) {
      print('Error parsing double: $e');
      return 0.0;
    }
  }

  static double _parseDiscountPrice(dynamic value) {
    try {
      if (value is String) return double.tryParse(value) ?? 0.0;
      if (value is int) return value.toDouble();
      return 0.0;
    } catch (e) {
      print('Error parsing discount price: $e');
      return 0.0;
    }
  }
}
