class CartItemModel {
  int id;
  String productId;
  String name;
  double price;
  int quantity;
  String imageUrl;
  String? orderId; // Hacer que el orderId sea nullable

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.orderId,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: double.parse(map['price'].toString()),
      quantity: map['quantity'],
      imageUrl: map['imageurl'],
      orderId: map['order_id'],
    );
  }

  static List<CartItemModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => CartItemModel.fromMap(map)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageurl': imageUrl,
      'order_id': orderId, // El orderId ahora puede ser nulo
    };
  }
}
