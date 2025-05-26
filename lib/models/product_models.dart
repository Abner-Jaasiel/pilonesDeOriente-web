class Product {
  String name;
  List<String> types; // Lista de tipos específicos
  double price; // Precio Venta
  double germinationPrice; // Precio Germinación

  Product({
    required this.name,
    required this.types, // Lista de tipos
    required this.price,
    required this.germinationPrice,
  });

  //! Convierte un Product a un Map (para enviar a Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'types': types, // Guarda la lista de tipos
      'price': price,
      'germinationPrice': germinationPrice,
    };
  }

  //! Convierte un Map a un Product (para cargar desde Firebase)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '', // Valor por defecto si 'name' es null
      types: List<String>.from(
          map['types'] ?? ['General']), // Valor por defecto si 'types' es null
      price: map['price']?.toDouble() ??
          0.0, // Valor por defecto si 'price' es null
      germinationPrice: map['germinationPrice']?.toDouble() ??
          0.0, // Valor por defecto si 'germinationPrice' es null
    );
  }

  //! Sobrescribe el método toString para facilitar la depuración
  @override
  String toString() {
    return 'Product(name: $name, types: $types, price: $price, germinationPrice: $germinationPrice)';
  }
}
