/*class OrderUserModel {
  final String orderId;
  final String productId;
  final String productName;
  final double price;
  final String orderStatus;
  final String orderDate;
  final String productImages;

  OrderUserModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.orderStatus,
    required this.orderDate,
    required this.productImages,
  });

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      orderId: json['order_id'].toString(),
      productId: json['product_id'].toString(),
      productName: json['product_name'],
      price: json['product_price'].toDouble(),
      orderStatus: json['order_status'],
      orderDate: json['order_date'],
      productImages: json['product_images'],
    );
  }
}*/

class OrderUserModel {
  final String orderId;
  final String productId;
  final String productName;
  final double price;
  final String orderStatus;
  final String orderDate;
  final String productImages;

  OrderUserModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.orderStatus,
    required this.orderDate,
    required this.productImages,
  });

  // Deserialización con control de errores
  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderUserModel(
        orderId: json['order_id'].toString(),
        productId: json['product_id'].toString(),
        productName: json['product_name'] ?? '', // Default empty string if null
        price: (json['product_price'] as num?)?.toDouble() ??
            0.0, // Default to 0.0 if null or invalid
        orderStatus: json['order_status'] ?? '', // Default empty string if null
        orderDate: json['order_date'] ?? '', // Default empty string if null
        productImages:
            json['product_images'] ?? '', // Default empty string if null
      );
    } catch (e) {
      print('Error deserializando OrderUserModel: $e');
      // En caso de error, puedes devolver un modelo con valores predeterminados
      return OrderUserModel(
        orderId: '',
        productId: '',
        productName: '',
        price: 0.0,
        orderStatus: '',
        orderDate: '',
        productImages: '',
      );
    }
  }
}
