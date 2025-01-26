class CartItemModel {
  int id;
  String productId;
  String name;
  double price;
  int quantity;
  String imageUrl;
  String status;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.status,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: double.parse(map['price'].toString()),
      quantity: map['quantity'],
      imageUrl: map['imageurl'],
      status: map['status'] ?? 'pending',
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
      'status': status,
    };
  }
}
