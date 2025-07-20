import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pilones_de_oriente/models/product_models.dart';
import 'package:pilones_de_oriente/service/firebase_service.dart';
import 'package:pilones_de_oriente/service/receipt_printer.dart';

class FormSentScreen extends StatefulWidget {
  const FormSentScreen({super.key});

  @override
  _FormSentScreenState createState() => _FormSentScreenState();
}

class _FormSentScreenState extends State<FormSentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _vendedorController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _siembraController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _sociosController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _manualPriceController = TextEditingController();
  final _bancoController = TextEditingController();
  final _montoRecibidoController = TextEditingController();
  String _cultivoSeleccionado = '';
  String _tipoSeleccionado = '';
  String _tipoGerminacionVenta = 'Germinacion';
  String _metodoPagoSeleccionado = 'Efectivo';
  bool _manualPriceUsed = false;
  bool _esCredito = false;
  double? _manualPrice;
  List<Product> _products = [];
  double _totalPrice = 0;
  final FirebaseService _firebaseService = FirebaseService();

  // Función para parsear números con comas
  double _parseNumberWithCommas(String value) {
    // Remover todas las comas y luego parsear
    String cleanedValue = value.replaceAll(',', '');
    return double.tryParse(cleanedValue) ?? 0.0;
  }

  // Función para parsear enteros con comas
  int _parseIntWithCommas(String value) {
    // Remover todas las comas y luego parsear
    String cleanedValue = value.replaceAll(',', '');
    return int.tryParse(cleanedValue) ?? 1;
  }

  Product get _selectedProduct {
    return _products.firstWhere(
      (p) => p.name == _cultivoSeleccionado,
      orElse: () =>
          Product(name: '', price: 0.0, germinationPrice: 0.0, types: []),
    );
  }

  void _clearControllers() {
    _nombreController.clear();
    _vendedorController.clear();
    _emailController.clear();
    _telefonoController.clear();
    _siembraController.clear();
    _ciudadController.clear();
    _sociosController.clear();
    _cantidadController.clear();
    _manualPriceController.clear();
    _bancoController.clear();
    _montoRecibidoController.clear();
    _cultivoSeleccionado = _products.isNotEmpty ? _products.first.name : '';
    _tipoSeleccionado = '';
    _tipoGerminacionVenta = 'Germinacion';
    _metodoPagoSeleccionado = 'Efectivo';
    _manualPriceUsed = false;
    _manualPrice = null;
    _totalPrice = 0;
    _esCredito = false;
  }

  void _calculateTotalPrice() {
    setState(() {
      int quantity = _parseIntWithCommas(_cantidadController.text);
      double basePrice;

      if (_manualPrice != null) {
        basePrice = _manualPrice!;
      } else {
        basePrice = _tipoGerminacionVenta == "Venta"
            ? _selectedProduct.price
            : _selectedProduct.germinationPrice;
      }

      _totalPrice = quantity * basePrice;
    });
  }

  void _setManualPrice() {
    if (!_manualPriceUsed && _manualPriceController.text.isNotEmpty) {
      setState(() {
        _manualPrice = _parseNumberWithCommas(_manualPriceController.text);
        _manualPriceUsed = true;
        _calculateTotalPrice();
      });
    }
  }

  void _enviarDatos() async {
    if (_formKey.currentState!.validate()) {
      _calculateTotalPrice();

      double montoRecibido =
          _parseNumberWithCommas(_montoRecibidoController.text);
      double deuda = _totalPrice - montoRecibido;

      Map<String, dynamic> datos = {
        'nombre': _nombreController.text,
        'vendedor': _vendedorController.text,
        'email': _emailController.text,
        'telefono': _telefonoController.text,
        'siembra': _siembraController.text,
        'ciudad': _ciudadController.text,
        'socios': _sociosController.text,
        'cultivo': _cultivoSeleccionado,
        'tipo': _tipoSeleccionado,
        'tipoGerminacionVenta': _tipoGerminacionVenta,
        'cantidad': _parseIntWithCommas(_cantidadController.text).toString(),
        'metodoPago': _metodoPagoSeleccionado,
        'banco':
            _metodoPagoSeleccionado == 'Banco' ? _bancoController.text : null,
        'esCredito': _esCredito,
        'precioVenta': _selectedProduct.price,
        'precioGerminacion': _selectedProduct.germinationPrice,
        'precioManual': _manualPrice,
        'precioTotal': _totalPrice,
        'montoRecibido': montoRecibido,
        'deuda': deuda,
        'fecha': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };

      try {
        await _firebaseService.saveSentData(datos);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Datos Enviados'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Resumen del envío:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(),
                    _buildSummaryItem('Nombre:', datos['nombre']),
                    _buildSummaryItem('Vendedor:', datos['vendedor']),
                    _buildSummaryItem('Email:', datos['email']),
                    _buildSummaryItem('Teléfono:', datos['telefono']),
                    _buildSummaryItem('Lugar de siembra:', datos['siembra']),
                    _buildSummaryItem('Ciudad:', datos['ciudad']),
                    _buildSummaryItem('Socios:', datos['socios']),
                    _buildSummaryItem('Cultivo:', datos['cultivo']),
                    _buildSummaryItem('Tipo:', datos['tipo']),
                    _buildSummaryItem(
                      'Tipo:',
                      datos['tipoGerminacionVenta'] == 'Germinacion'
                          ? 'Germinación'
                          : 'Venta',
                    ),
                    _buildSummaryItem('Cantidad:', datos['cantidad']),
                    _buildSummaryItem(
                      'Precio Venta:',
                      NumberFormat.currency(symbol: 'L ', decimalDigits: 2)
                          .format(datos['precioVenta']),
                    ),
                    _buildSummaryItem(
                      'Precio Germinación:',
                      NumberFormat.currency(symbol: 'L ', decimalDigits: 2)
                          .format(datos['precioGerminacion']),
                    ),
                    if (datos['precioManual'] != null)
                      _buildSummaryItem(
                        'Precio Manual:',
                        NumberFormat.currency(symbol: 'L ', decimalDigits: 2)
                            .format(datos['precioManual']),
                      ),
                    _buildSummaryItem(
                      'Precio Total:',
                      NumberFormat.currency(symbol: 'L ', decimalDigits: 2)
                          .format(datos['precioTotal']),
                    ),
                    _buildSummaryItem(
                      'Monto Recibido:',
                      NumberFormat.currency(symbol: 'L ', decimalDigits: 2)
                          .format(datos['montoRecibido']),
                    ),
                    _buildSummaryItem(
                      'Deuda:',
                      NumberFormat.currency(symbol: 'L ', decimalDigits: 2)
                          .format(datos['deuda']),
                      style: TextStyle(
                        color: datos['deuda'] > 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildSummaryItem('Método de Pago:', datos['metodoPago']),
                    if (datos['banco'] != null)
                      _buildSummaryItem('Banco:', datos['banco']),
                    _buildSummaryItem(
                        'Es Crédito:', datos['esCredito'] ? 'Sí' : 'No'),
                    _buildSummaryItem('Fecha:', datos['fecha']),
                    const SizedBox(height: 20),
                    const Text(
                      '¿Desea imprimir el recibo?',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearControllers();
                  },
                ),
                TextButton(
                  child: const Text('Imprimir Recibo'),
                  onPressed: () async {
                    await ReceiptPrinter.printReceipt(datos);
                    Navigator.of(context).pop();
                    _clearControllers();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar datos: $e')),
        );
      }
    }
  }

  Widget _buildSummaryItem(String label, dynamic value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.toString(),
              style: style ??
                  const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref();
      final snapshot = await dbRef.child('data/inventory/products').get();

      if (snapshot.exists) {
        final List<dynamic> productData = snapshot.value as List<dynamic>;
        setState(() {
          _products = productData
              .map((data) => Product.fromMap(Map<String, dynamic>.from(data)))
              .toList();

          if (_products.isNotEmpty) {
            _cultivoSeleccionado = _products.first.name;
            _tipoSeleccionado = _products.first.types.isNotEmpty
                ? _products.first.types.first
                : '';
            _calculateTotalPrice();
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double montoRecibido =
        _parseNumberWithCommas(_montoRecibidoController.text);
    double deuda = _totalPrice - montoRecibido;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Envío'),
      ),
      body: FutureBuilder(
        future: FirebaseService().getCurrentUserRole(),
        builder: (context, snapshot) {
          final String role = dotenv.env['ROLE_FORM'] ?? 'form';
          return snapshot.data == role || snapshot.data == 'admin'
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Form(
                          key: _formKey,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SectionTitle(
                                    title: 'Información Personal'),
                                CustomTextField(
                                  controller: _nombreController,
                                  label: 'Nombre',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu nombre';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  controller: _vendedorController,
                                  label: 'Nombre del Vendedor',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa el nombre del vendedor';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu email';
                                    } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+")
                                        .hasMatch(value)) {
                                      return 'Por favor ingresa un email válido';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  controller: _telefonoController,
                                  label: 'Teléfono',
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu teléfono';
                                    }
                                    return null;
                                  },
                                ),
                                const SectionTitle(
                                    title: 'Información de Siembra'),
                                CustomTextField(
                                  controller: _siembraController,
                                  label: '¿Dónde siembras?',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa donde siembras';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  controller: _ciudadController,
                                  label: 'Ciudad',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu ciudad';
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  controller: _sociosController,
                                  label: 'Socios',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa los socios';
                                    }
                                    return null;
                                  },
                                ),
                                const SectionTitle(
                                    title: 'Opciones de Cultivo'),
                                DropdownButtonFormField<String>(
                                  value: _cultivoSeleccionado.isNotEmpty
                                      ? _cultivoSeleccionado
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Tipo de Cultivo',
                                  ),
                                  items: _products
                                      .map(
                                          (product) => DropdownMenuItem<String>(
                                                value: product.name,
                                                child: Text(product.name),
                                              ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _cultivoSeleccionado = value!;
                                      _tipoSeleccionado =
                                          _selectedProduct.types.isNotEmpty
                                              ? _selectedProduct.types.first
                                              : '';
                                      _calculateTotalPrice();
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                if (_cultivoSeleccionado.isNotEmpty &&
                                    _selectedProduct.types.isNotEmpty)
                                  DropdownButtonFormField<String>(
                                    value: _tipoSeleccionado.isNotEmpty
                                        ? _tipoSeleccionado
                                        : null,
                                    decoration: const InputDecoration(
                                      labelText: 'Tipo de Producto',
                                    ),
                                    items: _selectedProduct.types
                                        .map((type) => DropdownMenuItem<String>(
                                              value: type,
                                              child: Text(type),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _tipoSeleccionado = value!;
                                      });
                                    },
                                  ),
                                const SizedBox(height: 20),
                                Center(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: 'Germinacion',
                                          groupValue: _tipoGerminacionVenta,
                                          onChanged: (value) {
                                            setState(() {
                                              _tipoGerminacionVenta = value!;
                                              _calculateTotalPrice();
                                            });
                                          },
                                        ),
                                        const Text('Germinación'),
                                        Radio<String>(
                                          value: 'Venta',
                                          groupValue: _tipoGerminacionVenta,
                                          onChanged: (value) {
                                            setState(() {
                                              _tipoGerminacionVenta = value!;
                                              _calculateTotalPrice();
                                            });
                                          },
                                        ),
                                        const Text('Venta'),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const SectionTitle(title: 'Método de Pago'),
                                CheckboxListTile(
                                  title: const Text('Efectivo'),
                                  value: _metodoPagoSeleccionado == 'Efectivo',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _metodoPagoSeleccionado = 'Efectivo';
                                        _bancoController.clear();
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Cheque'),
                                  value: _metodoPagoSeleccionado == 'Cheque',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _metodoPagoSeleccionado = 'Cheque';
                                        _bancoController.clear();
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Tarjeta'),
                                  value: _metodoPagoSeleccionado == 'Tarjeta',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _metodoPagoSeleccionado = 'Tarjeta';
                                        _bancoController.clear();
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Banco'),
                                  value: _metodoPagoSeleccionado == 'Banco',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _metodoPagoSeleccionado = 'Banco';
                                      } else {
                                        _metodoPagoSeleccionado = 'Efectivo';
                                        _bancoController.clear();
                                      }
                                    });
                                  },
                                ),
                                if (_metodoPagoSeleccionado == 'Banco')
                                  CustomTextField(
                                    controller: _bancoController,
                                    label: 'Nombre del Banco',
                                    validator: (value) {
                                      if (_metodoPagoSeleccionado == 'Banco' &&
                                          (value == null || value.isEmpty)) {
                                        return 'Por favor ingresa el nombre del banco';
                                      }
                                      return null;
                                    },
                                  ),
                                const Divider(),
                                CheckboxListTile(
                                  title: const Text('Es Crédito'),
                                  value: _esCredito,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _esCredito = value ?? false;
                                    });
                                  },
                                ),
                                const Divider(),
                                CustomTextField(
                                  controller: _montoRecibidoController,
                                  label: 'Monto Recibido (L)',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa el monto recibido';
                                    }
                                    if (_parseNumberWithCommas(value) < 0.0) {
                                      return 'El monto no puede ser negativo';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _manualPriceUsed
                                      ? 'El precio manual ya fue aplicado:'
                                      : 'Este ajuste solo se puede usar una vez por formulario:',
                                  style: TextStyle(
                                    color: _manualPriceUsed
                                        ? Colors.red
                                        : Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      constraints: const BoxConstraints(
                                          maxWidth: 300, minWidth: 50),
                                      child: CustomTextField(
                                        controller: _manualPriceController,
                                        label: 'Precio Unitario (L)',
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value != null &&
                                              value.isNotEmpty) {
                                            if (_parseNumberWithCommas(value) ==
                                                0.0) {
                                              return 'Ingresa un número válido';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _manualPriceUsed
                                          ? null
                                          : _setManualPrice,
                                      child: Text(_manualPriceUsed
                                          ? 'Usado'
                                          : 'Aplicar'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                CustomQuantityField(
                                  tipoGerminacionVenta: _tipoGerminacionVenta,
                                  controller: _cantidadController,
                                  label: 'Cantidad',
                                  onQuantityChanged: _calculateTotalPrice,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa la cantidad';
                                    }
                                    if (_parseIntWithCommas(value) == 0) {
                                      return 'Por favor ingresa un número válido';
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Precio Venta: L ${_selectedProduct.price.toStringAsFixed(2)}'),
                                      Text(
                                          'Precio Germinación: L ${_selectedProduct.germinationPrice.toStringAsFixed(2)}'),
                                      if (_manualPrice != null)
                                        Text(
                                            'Precio Manual: L ${_manualPrice!.toStringAsFixed(2)}'),
                                      Text(
                                        'Precio Total: ${NumberFormat.currency(symbol: 'L ', decimalDigits: 2).format(_totalPrice)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      if (_montoRecibidoController
                                          .text.isNotEmpty)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Monto Recibido: ${NumberFormat.currency(symbol: 'L ', decimalDigits: 2).format(montoRecibido)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              'Deuda: ${NumberFormat.currency(symbol: 'L ', decimalDigits: 2).format(deuda)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    color: deuda > 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _enviarDatos,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Enviar'),
                                ),
                                const SizedBox(height: 100),
                                ElevatedButton(
                                  onPressed: () async {
                                    context.push('/planillas');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Planillas'),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    context.go('/login');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Cerrar sesión'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomQuantityField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final String tipoGerminacionVenta;
  final VoidCallback onQuantityChanged;

  const CustomQuantityField({
    super.key,
    required this.controller,
    required this.label,
    required this.tipoGerminacionVenta,
    required this.onQuantityChanged,
    this.validator,
  });

  @override
  _CustomQuantityFieldState createState() => _CustomQuantityFieldState();
}

class _CustomQuantityFieldState extends State<CustomQuantityField> {
  int _quantity = 1;
  bool _isEditing = false;

  // Función para parsear enteros con comas
  int _parseIntWithCommas(String value) {
    // Remover todas las comas y luego parsear
    String cleanedValue = value.replaceAll(',', '');
    return int.tryParse(cleanedValue) ?? 1;
  }

  @override
  void initState() {
    super.initState();
    _quantity = _parseIntWithCommas(widget.controller.text);
  }

  void _increment() {
    setState(() {
      _quantity++;
      widget.controller.text = _quantity.toString();
      widget.onQuantityChanged();
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        widget.controller.text = _quantity.toString();
        widget.onQuantityChanged();
      }
    });
  }

  void _refresh() {
    setState(() {
      _quantity = _parseIntWithCommas(widget.controller.text);
      widget.controller.text = _quantity.toString();
      widget.onQuantityChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrement,
              ),
              Expanded(
                child: Stack(
                  children: [
                    TextFormField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        labelText: widget.label,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: widget.validator,
                      onChanged: (value) {
                        if (!_isEditing) {
                          setState(() {
                            _quantity = _parseIntWithCommas(value);
                            if (_quantity < 1) _quantity = 1;
                            widget.onQuantityChanged();
                          });
                        }
                      },
                      onTap: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          _isEditing = false;
                        });
                      },
                    ),
                    Positioned(
                      right: 10,
                      top: 3,
                      child: IconButton(
                        icon: const Icon(Icons.done_sharp),
                        onPressed: _refresh,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _increment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
