class CartItemModel {
  int id;
  String productId;
  String name;
  double price;
  int quantity;
  String imageUrl;
  String? orderId;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.orderId,
  });

  // Factory constructor para crear un CartItemModel desde un Map con validaciones
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    try {
      if (map['id'] == null ||
          map['product_id'] == null ||
          map['name'] == null) {
        throw ArgumentError('Faltan campos obligatorios en el mapa');
      }

      return CartItemModel(
        id: map['id'],
        productId: map['product_id'],
        name: map['name'],
        price: _parsePrice(map['price']),
        quantity: map['quantity'] ?? 0, // Proteger contra valores nulos
        imageUrl: map['imageurl'] ??
            '', // Valor predeterminado si la URL de imagen está vacía
        orderId: map['order_id'],
      );
    } catch (e) {
      print("Error al convertir Map a CartItemModel: $e");
      rethrow; // Vuelve a lanzar la excepción para que se maneje a un nivel superior
    }
  }

  // Método auxiliar para convertir el precio y manejar errores de conversión
  static double _parsePrice(dynamic price) {
    try {
      if (price is String) {
        return double.tryParse(price) ??
            0.0; // Protege contra errores de parseo
      }
      return price?.toDouble() ?? 0.0;
    } catch (e) {
      print("Error al parsear el precio: $e");
      return 0.0; // Valor por defecto si no se puede parsear el precio
    }
  }

  // Función que convierte una lista de mapas en una lista de CartItemModel con manejo de errores
  static List<CartItemModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) {
      try {
        return CartItemModel.fromMap(map);
      } catch (e) {
        print("Error al convertir el mapa en un CartItemModel: $e");
        return CartItemModel(
          id: 0,
          productId: '',
          name: 'Desconocido',
          price: 0.0,
          quantity: 0,
          imageUrl: '',
        ); // Devuelve un modelo vacío si ocurre un error
      }
    }).toList();
  }

  // Método para convertir el modelo en un mapa con validaciones
  Map<String, dynamic> toMap() {
    try {
      if (name.isEmpty || productId.isEmpty) {
        throw ArgumentError(
            'Los campos nombre y productId no pueden estar vacíos');
      }

      return {
        'id': id,
        'product_id': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'imageurl': imageUrl,
        'order_id': orderId,
      };
    } catch (e) {
      print("Error al convertir CartItemModel a Map: $e");
      return {}; // Devuelve un mapa vacío en caso de error
    }
  }

  // Propiedad de validación para asegurar que los datos del modelo sean correctos
  bool get isValid {
    return id > 0 &&
        productId.isNotEmpty &&
        name.isNotEmpty &&
        price > 0.0 &&
        quantity > 0;
  }
}
