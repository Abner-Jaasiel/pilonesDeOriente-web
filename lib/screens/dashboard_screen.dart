import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:pilones_de_oriente/models/product_models.dart';
import 'package:pilones_de_oriente/service/firebase_service.dart';
import 'package:pilones_de_oriente/widgets/role_config_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Product> products = [];

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productGerminationPriceController =
      TextEditingController();
  final TextEditingController _typesController = TextEditingController();

  final List<String> _currentTypes = [];

  @override
  void initState() {
    super.initState();
    _loadProductsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        elevation: 4,
      ),
      body: FutureBuilder(
        future: FirebaseService().getCurrentUserRole(),
        builder: (context, snapshot) {
          final String adminRole = dotenv.env['ADMIN_ROLE'] ?? 'admin';
          if (snapshot.data == adminRole) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop) ..._buildDesktopLayout(),
                  if (!isDesktop) ..._buildMobileLayout(),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<Widget> _buildDesktopLayout() {
    ScrollController scrollController = ScrollController();
    return [
      Expanded(
        flex: 2,
        child: ListView(
          children: [
            RoleConfigWidget(scrollController: scrollController),
            const SizedBox(height: 140),
          ],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        flex: 3,
        child: ListView(children: [
          _buildProductsSection(),
          const SizedBox(height: 20),
          _goToScreens(context),
          const SizedBox(height: 140),
        ]),
      ),
    ];
  }

  List<Widget> _buildMobileLayout() {
    ScrollController scrollController = ScrollController();
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProductsSection(),
              const SizedBox(height: 20),
              RoleConfigWidget(scrollController: scrollController),
              const SizedBox(height: 20),
              _goToScreens(context),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _goToScreens(BuildContext context) {
    final List<Map<String, String>> routes = [
      {'path': '/formSent', 'label': 'Form Sent'},
      {'path': '/Orders', 'label': 'Orders'},
      {'path': '/reports', 'label': 'Reports'},
    ];

    return Column(
      children: [
        const SizedBox(height: 30),
        const Text("Pantallas:"),
        const SizedBox(height: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: routes
              .map(
                (route) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    onPressed: () => GoRouter.of(context).push(route['path']!),
                    child: Text(route['label']!),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Gestión de Productos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _productNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Producto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _typesController,
                    decoration: InputDecoration(
                      labelText: 'Tipos (separados por comas)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addTypes,
                      ),
                    ),
                    onSubmitted: (value) => _addTypes(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _currentTypes.map((type) {
                return Chip(
                  label: Text(type),
                  onDeleted: () => _removeType(type),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _productPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Precio Venta',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _productGerminationPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Precio Germinación',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 40),
                  onPressed: _addProduct,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 450,
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 600,
                columns: const [
                  DataColumn2(label: Text('Producto')),
                  DataColumn2(label: Text('Tipos')),
                  DataColumn2(label: Text('')),
                  DataColumn2(label: Text('Precio Venta')),
                  DataColumn2(label: Text('Precio Germinación')),
                  DataColumn2(label: Text('Acciones')),
                ],
                rows: products.map((product) {
                  return DataRow2(
                    cells: [
                      DataCell(Text(product.name)),
                      DataCell(Text(product.types.join(', '))),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editProductTypes(product),
                        ),
                      ),
                      DataCell(
                        TextField(
                          controller: TextEditingController()
                            ..text = product.price.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            product.price = double.tryParse(value) ?? 0.0;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      DataCell(
                        TextField(
                          controller: TextEditingController()
                            ..text = product.germinationPrice.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            product.germinationPrice =
                                double.tryParse(value) ?? 0.0;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeProduct(product),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar Productos'),
              onPressed: _saveProductsToFirebase,
            ),
          ],
        ),
      ),
    );
  }

  void _addTypes() {
    final input = _typesController.text.trim();
    if (input.isNotEmpty) {
      final newTypes = input.split(',').map((type) => type.trim()).toList();
      setState(() {
        _currentTypes.addAll(newTypes);
        _typesController.clear();
      });
    }
  }

  void _removeType(String type) {
    setState(() {
      _currentTypes.remove(type);
    });
  }

  void _addProduct() {
    if (_productNameController.text.isEmpty ||
        _productPriceController.text.isEmpty ||
        _productGerminationPriceController.text.isEmpty ||
        _currentTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son requeridos')),
      );
      return;
    }

    setState(() {
      products.add(Product(
        name: _productNameController.text,
        types: _currentTypes,
        price: double.parse(_productPriceController.text),
        germinationPrice: double.parse(_productGerminationPriceController.text),
      ));
      _clearProductFields();
    });
  }

  void _removeProduct(Product product) {
    setState(() {
      products.remove(product);
    });
  }

  void _clearProductFields() {
    _productNameController.clear();
    _productPriceController.clear();
    _productGerminationPriceController.clear();
    _typesController.clear();
    _currentTypes.clear();
  }

  Future<void> _saveProductsToFirebase() async {
    try {
      final List<Map<String, dynamic>> productList =
          products.map((product) => product.toMap()).toList();

      await _dbRef.child('data/inventory/products').set(productList);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Productos guardados exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar productos: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadProductsFromFirebase() async {
    try {
      final snapshot = await _dbRef.child('data/inventory/products').get();

      if (snapshot.exists) {
        final List<dynamic> productData = snapshot.value as List<dynamic>;
        final List<Product> loadedProducts = productData
            .map((data) => Product.fromMap(Map<String, dynamic>.from(data)))
            .toList();

        setState(() {
          products = loadedProducts;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Productos cargados exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay productos guardados')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: ${e.toString()}')),
      );
    }
  }

  void _editProductTypes(Product product) {
    final TextEditingController editTypesController = TextEditingController();
    List<String> editableTypes = List.from(product.types);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Tipos'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: editTypesController,
                      decoration: InputDecoration(
                        labelText: 'Agregar tipos (separados por comas)',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final input = editTypesController.text.trim();
                            if (input.isNotEmpty) {
                              final newTypes = input
                                  .split(',')
                                  .map((type) => type.trim())
                                  .toList();
                              setStateDialog(() {
                                editableTypes.addAll(newTypes);
                                editTypesController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: editableTypes.map((type) {
                        return Chip(
                          label: Text(type),
                          onDeleted: () {
                            setStateDialog(() {
                              editableTypes.remove(type);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    setState(() {
                      product.types = editableTypes;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
