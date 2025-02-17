class CommentModel {
  final int id;
  final String productId;
  final String userId;
  final String comment;
  final String userNameComment;
  final String? userProfileImage; // Es opcional, puede ser null
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.comment,
    required this.userNameComment,
    this.userProfileImage, // Puede ser null
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      comment: json['comment'],
      userNameComment: json['user_name_comment'] ?? '', // Manejar null
      userProfileImage: json['user_profile_image']
          as String?, // Convertir a String? para que acepte null
      createdAt: DateTime.parse(json['created_at'] ??
          DateTime.now()
              .toIso8601String()), // Default a la fecha actual si no se encuentra
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'comment': comment,
      'user_name_comment': userNameComment,
      'user_profile_image': userProfileImage, // Puede ser null
      'created_at': createdAt.toIso8601String(), // Convertir a formato ISO 8601
    };
  }
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double? locationLatitude;
  final double? locationLongitude;
  final List<String> urlImage;
  final List<String>? url3dObject;
  final int rating;
  final double price;
  final int? stock;
  final String categoryName;
  final int categoryId;
  final String? subcategoryName; // Nuevo campo
  final int? subcategoryId; // Nuevo campo
  final bool onSale;
  final double? discountPrice;
  final String sellerfirebaseUid;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  List<CommentModel> comments;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    this.locationLatitude,
    this.locationLongitude,
    required this.urlImage,
    this.url3dObject,
    required this.rating,
    required this.price,
    required this.stock,
    required this.categoryName,
    required this.categoryId,
    this.subcategoryName, // Inicialización del nuevo campo
    this.subcategoryId, // Inicialización del nuevo campo
    required this.onSale,
    this.discountPrice,
    required this.sellerfirebaseUid,
    this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    required this.comments,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      locationLatitude: json['location_latitude'] != null
          ? double.parse(json['location_latitude'])
          : null,
      locationLongitude: json['location_longitude'] != null
          ? double.parse(json['location_longitude'])
          : null,
      urlImage: List<String>.from(json['urlimage']),
      url3dObject: json['url3dobject'] != null
          ? List<String>.from(json['url3dobject'])
          : null,
      rating: json['rating'],
      price: double.parse(json['price']),
      stock: json['stock'],
      categoryName: json['category_name'],
      categoryId: json['category_id'],
      subcategoryName: json['subcategory_name'], // Asignación del nuevo campo
      subcategoryId: json['subcategory_id'], // Asignación del nuevo campo
      onSale: json['onsale'],
      discountPrice: json['discountprice'] != null
          ? double.parse(json['discountprice'])
          : null,
      sellerfirebaseUid: json['seller_firebase_uid'],
      color: json['color'],
      createdAt: DateTime.parse(json['createdat']),
      updatedAt: DateTime.parse(json['updatedat']),
      tags: List<String>.from(json['tags']),
      comments: List<CommentModel>.from(
        json['comments'].map((comment) => CommentModel.fromJson(comment)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'urlimage': urlImage,
      'url3dobject': url3dObject,
      'rating': rating,
      'price': price,
      'stock': stock,
      'category_name': categoryName,
      'category_id': categoryId,
      'subcategory_name': subcategoryName,
      'subcategory_id': subcategoryId,
      'onsale': onSale,
      'discountprice': discountPrice,
      'seller_firebase_uid': sellerfirebaseUid,
      'color': color,
      'createdat': createdAt.toIso8601String(),
      'updatedat': updatedAt.toIso8601String(),
      'tags': tags,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
