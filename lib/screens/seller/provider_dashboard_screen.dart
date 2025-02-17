import 'package:flutter/material.dart';

// Modelo de producto
class Product {
  final String name;
  final String user;
  final String location;
  bool isShipped;

  Product({
    required this.name,
    required this.user,
    required this.location,
    this.isShipped = false,
  });
}

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  _ProviderDashboardScreenState createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  List<Product> products = [
    Product(name: 'Producto A', user: 'Usuario 1', location: 'Ubicación 1'),
    Product(name: 'Producto B', user: 'Usuario 2', location: 'Ubicación 2'),
    Product(name: 'Producto C', user: 'Usuario 3', location: 'Ubicación 3'),
    Product(name: 'Producto D', user: 'Usuario 4', location: 'Ubicación 4'),
  ];

  String filter = '';

  // Filtro de búsqueda
  List<Product> getFilteredProducts() {
    if (filter.isEmpty) {
      return products;
    }
    return products
        .where((product) =>
            product.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  // Método para marcar producto como enviado
  void toggleShipment(Product product) {
    setState(() {
      product.isShipped = !product.isShipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Proveedor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  onFilterChanged: (value) {
                    setState(() {
                      filter = value;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro de productos
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filtrar por nombre',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
          ),

          // Lista de productos
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredProducts().length,
              itemBuilder: (context, index) {
                Product product = getFilteredProducts()[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Enviado a: ${product.location}'),
                  trailing: Icon(
                    product.isShipped ? Icons.check_circle : Icons.circle,
                    color: product.isShipped ? Colors.green : Colors.grey,
                  ),
                  onTap: () {
                    toggleShipment(product);
                  },
                  onLongPress: () {
                    _showOrderDialog(context, product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para mostrar el proceso de pedido
  void _showOrderDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceso de pedido'),
          content: Text(
              '¿Estás seguro de que quieres enviar el producto a ${product.user}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aquí puedes agregar el código para realizar el pedido
                toggleShipment(product);
                Navigator.of(context).pop();
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}

// Delegado para la búsqueda
class ProductSearchDelegate extends SearchDelegate<String> {
  final Function(String) onFilterChanged;

  ProductSearchDelegate({required this.onFilterChanged});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onFilterChanged(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProviderDashboardScreen(),
  ));
}
