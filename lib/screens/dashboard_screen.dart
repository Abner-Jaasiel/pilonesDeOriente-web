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
  bool _requirePassword = true;

  @override
  void initState() {
    super.initState();
    _loadProductsFromFirebase();
    _loadRequirePassword();
  }

  void _loadRequirePassword() async {
    final ref = _dbRef.child('data/payment_passwords_require');
    final snap = await ref.get();
    if (snap.exists && mounted) {
      setState(() {
        _requirePassword = snap.value == true;
      });
    } else {
      // Si no existe, lo creamos por defecto en true
      await ref.set(true);
      setState(() {
        _requirePassword = true;
      });
    }
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
        child: ListView(
          controller: scrollController,
          children: [
            _buildProductsSection(scrollController: scrollController),
            const SizedBox(height: 20),
            _goToScreens(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        flex: 2,
        child: _buildPasswordPanel(scrollController: scrollController),
      ),
    ];
  }

  List<Widget> _buildMobileLayout() {
    ScrollController scrollController = ScrollController();
    return [
      Expanded(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              _buildProductsSection(scrollController: scrollController),
              const SizedBox(height: 20),
              RoleConfigWidget(scrollController: scrollController),
              const SizedBox(height: 20),
              _goToScreens(context),
              const SizedBox(height: 20),
              _buildPasswordPanel(
                  isMobile: true, scrollController: scrollController),
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
      {'path': '/planillas', 'label': 'Planillas'},
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

  Widget _buildProductsSection({ScrollController? scrollController}) {
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
                      DataCell(
                        SizedBox(
                          width: 120,
                          child: Text(
                            product.types.join(', '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
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
      final newTypes = input
          .split(',')
          .map((type) => type.trim())
          .where((type) => type.isNotEmpty)
          .toList();
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
    // Agregar tipos pendientes antes de validar
    _addTypes();

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
        types: List.from(_currentTypes),
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
                                  .where((type) => type.isNotEmpty)
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
                  onPressed: () => Navigator.of(context).pop(),
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

  // Panel de contraseñas especiales
  Widget _buildPasswordPanel(
      {bool isMobile = false, ScrollController? scrollController}) {
    final DatabaseReference passwordRef =
        _dbRef.child('data/payment_passwords');
    final TextEditingController passwordController = TextEditingController();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Contraseñas de Autorización de Pago',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Nueva contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                  onPressed: () async {
                    final pass = passwordController.text.trim();
                    if (pass.isEmpty) return;
                    final now = DateTime.now().toIso8601String();
                    await passwordRef
                        .push()
                        .set({'password': pass, 'created': now});
                    passwordController.clear();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Contraseñas registradas:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _requirePassword,
                  onChanged: (val) async {
                    setState(() {
                      _requirePassword = val ?? true;
                    });
                    await _dbRef
                        .child('data/payment_passwords_require')
                        .set(_requirePassword);
                  },
                ),
                const Expanded(
                  child: Text(
                    'Solicitar contraseña en cambios en deudas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            isMobile
                ? SizedBox(
                    height: 200,
                    child: StreamBuilder(
                      stream: passwordRef.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData ||
                            snapshot.data?.snapshot.value == null) {
                          return const Text('No hay contraseñas registradas.');
                        }
                        final data = Map<String, dynamic>.from(
                            snapshot.data!.snapshot.value as Map);
                        final entries = data.entries.toList();
                        return ListView.builder(
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final key = entries[index].key;
                            final value =
                                Map<String, dynamic>.from(entries[index].value);
                            final pass = value['password'] ?? '';
                            final created = value['created'] ?? '';
                            return ListTile(
                              title: Text('Contraseña: $pass'),
                              subtitle: Text('Creada: $created'),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await passwordRef.child(key).remove();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: StreamBuilder(
                      stream: passwordRef.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData ||
                            snapshot.data?.snapshot.value == null) {
                          return const Text('No hay contraseñas registradas.');
                        }
                        final data = Map<String, dynamic>.from(
                            snapshot.data!.snapshot.value as Map);
                        final entries = data.entries.toList();
                        return ListView.builder(
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final key = entries[index].key;
                            final value =
                                Map<String, dynamic>.from(entries[index].value);
                            final pass = value['password'] ?? '';
                            final created = value['created'] ?? '';
                            return ListTile(
                              title: Text('Contraseña: $pass'),
                              subtitle: Text('Creada: $created'),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await passwordRef.child(key).remove();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
