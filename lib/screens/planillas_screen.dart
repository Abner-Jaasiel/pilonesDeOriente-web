import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:pilones_de_oriente/service/firebase_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PlanillasScreen extends StatefulWidget {
  const PlanillasScreen({super.key});

  @override
  _PlanillasScreenState createState() => _PlanillasScreenState();
}

// Clase para productos del inventario
class Product {
  final String name;
  final List<String> types;

  Product({required this.name, required this.types});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      types: List<String>.from(map['types'] ?? []),
    );
  }
}

// Clase para las entradas de la tabla
class GridEntry {
  String? key;
  String nombre;
  String semillaSembrada;
  String tipo;
  double total;
  DateTime fecha;

  GridEntry({
    this.key,
    required this.nombre,
    required this.semillaSembrada,
    required this.tipo,
    required this.total,
    required this.fecha,
  });

  factory GridEntry.fromMap(Map<dynamic, dynamic> map, String key) {
    return GridEntry(
      key: key,
      nombre: map['nombre'] ?? '',
      semillaSembrada: map['semillaSembrada'] ?? '',
      tipo: map['tipo'] ?? '',
      total: (map['total'] ?? 0.0).toDouble(),
      fecha: DateTime.parse(map['fecha']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'semillaSembrada': semillaSembrada,
      'tipo': tipo,
      'total': total,
      'fecha': DateFormat('yyyy-MM-dd').format(fecha),
    };
  }
}

class _PlanillasScreenState extends State<PlanillasScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('planillas');
  final List<GridEntry> _entries = [];
  bool _isLoading = true;
  DateTime? _fechaFiltro;
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _totalController = TextEditingController();

  List<Product> _products = [];
  String? _selectedProductForAdd;
  String? _selectedTypeForAdd;

  late GridEntryDataSource _gridEntryDataSource;

  // Controlador para el desplazamiento horizontal
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Liberar el controlador al cerrar
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final snapshot = await _dbRef.once();
      if (snapshot.snapshot.exists) {
        final Map<dynamic, dynamic> data =
            snapshot.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _entries.clear();
          data.forEach((key, value) {
            _entries.add(GridEntry.fromMap(value, key));
          });
          _gridEntryDataSource = GridEntryDataSource(
            entries: _entries,
            onEdit: (entry) => _showEditDialog(entry),
            onDelete: (entry) => _deleteEntry(entry.key!),
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _gridEntryDataSource = GridEntryDataSource(
            entries: [],
            onEdit: (entry) {},
            onDelete: (entry) {},
          );
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error al cargar datos: $e');
    }
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
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  Future<void> _saveEntry(GridEntry entry) async {
    try {
      if (entry.key == null) {
        final newEntryRef = _dbRef.push();
        await newEntryRef.set(entry.toMap());
        entry.key = newEntryRef.key;
      } else {
        await _dbRef.child(entry.key!).update(entry.toMap());
      }
      await _loadData();
    } catch (e) {
      _showError('Error al guardar: $e');
    }
  }

  Future<void> _deleteEntry(String key) async {
    try {
      await _dbRef.child(key).remove();
      await _loadData();
    } catch (e) {
      _showError('Error al eliminar: $e');
    }
  }

  Future<void> _addNewRow() async {
    if (_formKey.currentState!.validate()) {
      final newEntry = GridEntry(
        nombre: _nombreController.text,
        semillaSembrada: _selectedProductForAdd ?? '',
        tipo: _selectedTypeForAdd ?? '',
        total: double.tryParse(_totalController.text) ?? 0.0,
        fecha: _fechaFiltro ?? DateTime.now(),
      );
      await _saveEntry(newEntry);
      _clearForm();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaFiltro ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _fechaFiltro = picked);
    }
  }

  void _clearForm() {
    _nombreController.clear();
    _totalController.clear();
    setState(() {
      _fechaFiltro = null;
      _selectedProductForAdd = null;
      _selectedTypeForAdd = null;
    });
  }

  Future<void> _printPlanilla() async {
    final filteredEntries = _fechaFiltro == null
        ? _entries
        : _entries
            .where((e) =>
                DateFormat('yyyy-MM-dd').format(e.fecha) ==
                DateFormat('yyyy-MM-dd').format(_fechaFiltro!))
            .toList();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: ['Nombre', 'Semilla', 'Tipo', 'Total', 'Fecha'],
            data: filteredEntries
                .map((e) => [
                      e.nombre,
                      e.semillaSembrada,
                      e.tipo,
                      e.total.toStringAsFixed(2),
                      DateFormat('dd/MM/yyyy').format(e.fecha),
                    ])
                .toList(),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildFilterRow() {
    return FutureBuilder(
      future: FirebaseService().getCurrentUserRole(),
      builder: (context, snapshot) {
        final String role = dotenv.env['ROLE_FORM'] ?? 'form';
        return role == snapshot.data || snapshot.data == 'admin'
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _fechaFiltro == null
                                ? 'Filtrar por fecha'
                                : DateFormat('dd/MM/yyyy')
                                    .format(_fechaFiltro!),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.filter_alt),
                      onPressed: () {
                        setState(() {
                          _gridEntryDataSource = GridEntryDataSource(
                            entries: _fechaFiltro == null
                                ? _entries
                                : _entries
                                    .where((e) =>
                                        DateFormat('yyyy-MM-dd')
                                            .format(e.fecha) ==
                                        DateFormat('yyyy-MM-dd')
                                            .format(_fechaFiltro!))
                                    .toList(),
                            onEdit: (entry) => _showEditDialog(entry),
                            onDelete: (entry) => _deleteEntry(entry.key!),
                          );
                        });
                      },
                      tooltip: 'Aplicar filtro',
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _fechaFiltro = null;
                          _gridEntryDataSource = GridEntryDataSource(
                            entries: _entries,
                            onEdit: (entry) => _showEditDialog(entry),
                            onDelete: (entry) => _deleteEntry(entry.key!),
                          );
                        });
                      },
                      tooltip: 'Limpiar filtro',
                    ),
                    IconButton(
                      icon: const Icon(Icons.print),
                      onPressed: _printPlanilla,
                      tooltip: 'Imprimir planilla',
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildAddForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agregar Nuevo Registro',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: DropdownButtonFormField<String>(
                  value: _selectedProductForAdd,
                  decoration: const InputDecoration(
                    labelText: 'Semilla Sembrada',
                    border: OutlineInputBorder(),
                  ),
                  items: _products
                      .map((product) => DropdownMenuItem<String>(
                            value: product.name,
                            child: Text(product.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProductForAdd = value;
                      _selectedTypeForAdd = null;
                    });
                  },
                  validator: (value) => value == null ? 'Requerido' : null,
                ),
              ),
              if (_selectedProductForAdd != null) ...[
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: DropdownButtonFormField<String>(
                    value: _selectedTypeForAdd,
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(),
                    ),
                    items: _products
                        .firstWhere((p) => p.name == _selectedProductForAdd)
                        .types
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeForAdd = value;
                      });
                    },
                    validator: (value) => value == null ? 'Requerido' : null,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: _totalController,
                  decoration: const InputDecoration(
                    labelText: 'Total',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _fechaFiltro == null
                        ? 'Seleccionar fecha'
                        : DateFormat('dd/MM/yyyy').format(_fechaFiltro!),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addNewRow,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataGrid() {
    return Scrollbar(
      thumbVisibility: true, // Hace que la barra de desplazamiento sea visible
      controller: _scrollController, // Vincula el controlador
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController, // Usa el controlador para el scroll
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: const Color.fromARGB(255, 224, 224, 224),
              selectionColor: Colors.green[100],
            ),
            child: SfDataGrid(
              source: _gridEntryDataSource,
              columns: [
                GridColumn(
                  columnName: 'nombre',
                  minimumWidth: 150,
                  maximumWidth: 300, // Límite máximo de ancho
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text('Nombre'),
                  ),
                ),
                GridColumn(
                  columnName: 'semilla',
                  minimumWidth: 150,
                  maximumWidth: 250,
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text('Semilla Sembrada'),
                  ),
                ),
                GridColumn(
                  columnName: 'tipo',
                  minimumWidth: 100,
                  maximumWidth: 200,
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text('Tipo'),
                  ),
                ),
                GridColumn(
                  columnName: 'total',
                  minimumWidth: 100,
                  maximumWidth: 150,
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text('Total'),
                  ),
                ),
                GridColumn(
                  columnName: 'fecha',
                  minimumWidth: 120,
                  maximumWidth: 150,
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text('Fecha'),
                  ),
                ),
                GridColumn(
                  columnName: 'acciones',
                  minimumWidth: 120,
                  maximumWidth: 150,
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text('Acciones'),
                  ),
                ),
              ],
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columnWidthMode: ColumnWidthMode.auto,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddFormModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: _buildAddForm(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planillas de Cultivo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterRow(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _buildDataGrid()),
                            Expanded(flex: 2, child: _buildAddForm()),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(child: _buildDataGrid()),
                            FloatingActionButton(
                              onPressed: _showAddFormModal,
                              backgroundColor:
                                  const Color.fromARGB(255, 65, 141, 69),
                              child: const Icon(Icons.add),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showEditDialog(GridEntry entry) {
    String? selectedProduct = entry.semillaSembrada;
    String? selectedType = entry.tipo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Registro'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        initialValue: entry.nombre,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        onChanged: (value) => entry.nombre = value,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: DropdownButtonFormField<String>(
                        value: _products.any((p) => p.name == selectedProduct)
                            ? selectedProduct
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Semilla Sembrada'),
                        items: _products
                            .map((product) => DropdownMenuItem<String>(
                                  value: product.name,
                                  child: Text(product.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProduct = value;
                            selectedType = null;
                          });
                        },
                      ),
                    ),
                    if (selectedProduct != null &&
                        _products.any((p) => p.name == selectedProduct))
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: DropdownButtonFormField<String>(
                          value: _products
                                  .firstWhere((p) => p.name == selectedProduct)
                                  .types
                                  .contains(selectedType)
                              ? selectedType
                              : null,
                          decoration: const InputDecoration(labelText: 'Tipo'),
                          items: _products
                              .firstWhere((p) => p.name == selectedProduct)
                              .types
                              .map((type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        initialValue: entry.total.toStringAsFixed(2),
                        decoration: const InputDecoration(labelText: 'Total'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            entry.total = double.tryParse(value) ?? 0.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: entry.fecha,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            entry.fecha = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(entry.fecha),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    entry.semillaSembrada = selectedProduct ?? '';
                    entry.tipo = selectedType ?? '';
                    await _saveEntry(entry);
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
                TextButton(
                  onPressed: () async {
                    await _deleteEntry(entry.key!);
                    Navigator.pop(context);
                  },
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class GridEntryDataSource extends DataGridSource {
  GridEntryDataSource({
    required this.entries,
    required this.onEdit,
    required this.onDelete,
  });

  final List<GridEntry> entries;
  final Function(GridEntry) onEdit;
  final Function(GridEntry) onDelete;

  @override
  List<DataGridRow> get rows => entries
      .map<DataGridRow>((e) => DataGridRow(cells: [
            DataGridCell<String>(columnName: 'nombre', value: e.nombre),
            DataGridCell<String>(
                columnName: 'semilla', value: e.semillaSembrada),
            DataGridCell<String>(columnName: 'tipo', value: e.tipo),
            DataGridCell<double>(columnName: 'total', value: e.total),
            DataGridCell<String>(
                columnName: 'fecha',
                value: DateFormat('dd/MM/yyyy').format(e.fecha)),
            DataGridCell<Widget>(
                columnName: 'acciones',
                value: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => onEdit(e),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onDelete(e),
                    ),
                  ],
                )),
          ]))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == 'acciones') {
          return e.value as Widget;
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            e.value.toString(),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        );
      }).toList(),
    );
  }
}
