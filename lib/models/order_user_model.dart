class OrderUserModel {
  final String orderId;
  final String productId;
  final String productName;
  final double price; // Precio individual del producto
  final String orderStatus; // Estado de la orden
  final String orderDate;
  final String productImages;

  OrderUserModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price, // Usamos el precio del producto
    required this.orderStatus, // Añadimos el status de la orden
    required this.orderDate,
    required this.productImages,
  });

  // Función para mapear el JSON del backend al modelo
  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      orderId: json['order_id'].toString(),
      productId: json['product_id'].toString(),
      productName: json['product_name'],
      price:
          json['product_price'].toDouble(), // Mapeamos el precio del producto
      orderStatus: json['order_status'], // Mapeamos el status
      orderDate: json['order_date'],
      productImages: json['product_images'],
    );
  }
}
