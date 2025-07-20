/*import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:pilones_de_oriente/widgets/show_notification.dart';

class OrderCardWidget extends StatefulWidget {
  final Map<String, dynamic> order;
  final double screenWidth;
  final DatabaseReference dbRef;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.screenWidth,
    required this.dbRef,
  });

  @override
  _OrderCardWidgetState createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  late Map<String, dynamic> _currentOrder;
  late DatabaseReference _orderRef;

  @override
  void initState() {
    super.initState();
    _currentOrder = Map.from(widget.order);
    _orderRef = widget.dbRef.child(_currentOrder['key']);
    _setupDatabaseListener();
  }

  void _setupDatabaseListener() {
    _orderRef.onValue.listen((event) {
      if (event.snapshot.value != null && mounted) {
        final updatedData = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _currentOrder = {
            'key': _currentOrder['key'],
            'nombre': updatedData['nombre'] ?? 'No disponible',
            'tipo': updatedData['tipo'] ?? 'No disponible',
            'cultivo': updatedData['cultivo'] ?? 'No disponible',
            'cantidad': updatedData['cantidad'] ?? 0,
            'fechaSiembra': updatedData['fechaSiembra'],
            'fechaEntrega': updatedData['fechaEntrega'],
            'semillaSobrante': updatedData['semillaSobrante'],
            'numeroLote': updatedData['numeroLote'] ?? 'No definido',
            'numeroLote2': updatedData['numeroLote2'] ?? 'No definido',
            'precioTotal': updatedData['precioTotal'] ?? 0.0,
            'metodoPago': updatedData['metodoPago'] ?? 'No especificado',
          };
        });
      }
    });
  }

  void _updateSiembraDate(BuildContext context) async {
    final newDate = await _selectDate(context);
    if (newDate != null) {
      bool confirm =
          await _showConfirmationDialog(context, "fechaSiembra", newDate);

      if (confirm) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
        _orderRef.update({"fechaSiembra": formattedDate});

        bool proceed = await _showPreAlertMessage(context);
        if (!proceed) return;

        DateTime? notificationDate = await _selectNotificationDate(context);

        if (notificationDate != null) {
          String title = "Alerta de Siembra";
          String body =
              "${_currentOrder['nombre'] ?? 'Cliente no disponible'}, con el cultivo: ${_currentOrder['cultivo'] ?? 'No disponible'} ${_currentOrder['tipo'] ?? 'No disponible'}, fecha de siembra: $formattedDate";

          final notificationService = LocalNotificationService();
          await notificationService.scheduleNotification(
            title,
            body,
            notificationDate,
          );
        }
      }
    }
  }

  void _updateLoteNumber(BuildContext context) async {
    TextEditingController lote1Controller = TextEditingController(
      text: _currentOrder['numeroLote']?.toString() ?? '',
    );

    TextEditingController lote2Controller = TextEditingController(
      text: _currentOrder['numeroLote2']?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Números de Lote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: lote1Controller,
              decoration: const InputDecoration(
                labelText: 'Lote de Siembra',
                hintText: 'Ingrese el primer número de lote',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lote2Controller,
              decoration: const InputDecoration(
                labelText: 'Lote de Fabrica',
                hintText: 'Ingrese el segundo número de lote',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (lote1Controller.text.isNotEmpty ||
                  lote2Controller.text.isNotEmpty) {
                _orderRef.update({
                  "numeroLote": lote1Controller.text,
                  "numeroLote2": lote2Controller.text,
                }).then((_) {
                  Navigator.of(context).pop();
                });
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showPreAlertMessage(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Atención'),
              content: const Text(
                'A continuación, se te pedirá que selecciones la fecha de la alerta. '
                'Por favor, elige un día en el que quieras recibir el recordatorio.',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Continuar'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<DateTime?> _selectNotificationDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        return await showDialog<DateTime>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar fecha y hora'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          'Fecha: ${DateFormat('dd-MM-yyyy').format(finalDateTime)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Hora: ${selectedTime.format(context)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(finalDateTime),
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    }
    return null;
  }

  void _updateEntregaDate(BuildContext context) async {
    final newDate = await _selectDate(context);
    if (newDate != null) {
      final remainingSeeds = await _showSeedInputDialog(context);
      if (remainingSeeds != null) {
        bool confirm =
            await _showConfirmationDialog(context, "fechaEntrega", newDate);
        if (confirm) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
          _orderRef.update({
            "fechaEntrega": formattedDate,
            "semillaSobrante": remainingSeeds,
          });
        }
      }
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<String?> _showSeedInputDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cantidad de Semilla Sobrante'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Semilla sobrante',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String fieldName, DateTime newDate) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar actualización'),
            content: Text(
              '¿Estás seguro de que quieres insertar la ${fieldName == "fechaSiembra" ? "siembra" : "entrega"} para la fecha $formattedDate?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    bool tieneFechaSiembra = _currentOrder['fechaSiembra'] != null;
    bool tieneFechaEntrega = _currentOrder['fechaEntrega'] != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${_currentOrder['nombre'] ?? 'No disponible'}',
              style: TextStyle(
                fontSize: widget.screenWidth > 600 ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Cantidad: ${_currentOrder['cantidad'] ?? 0}'),
            Text(
                'Cultivo: ${(_currentOrder['cultivo'] ?? 'No disponible')} ${(_currentOrder['tipo'] ?? '')}'),
            Text(
                'Fecha de Siembra: ${_currentOrder['fechaSiembra'] ?? 'No definida'}'),
            Text(
                'Fecha de Entrega: ${_currentOrder['fechaEntrega'] ?? 'No definida'}'),
            Text(
                'Semilla Sobrante: ${_currentOrder['semillaSobrante'] ?? 'No definida'}'),
            Text(
                'Número de Lote 1: ${_currentOrder['numeroLote'] ?? 'No definido'}'),
            Text(
                'Número de Lote 2: ${_currentOrder['numeroLote2'] ?? 'No definido'}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white, size: 24),
                  label: const Text(
                    'Lotes',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () => _updateLoteNumber(context),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        tieneFechaSiembra ? Colors.grey : Colors.brown,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  label: const Text(
                    'Siembra',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: tieneFechaSiembra
                      ? null
                      : () => _updateSiembraDate(context),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (!tieneFechaSiembra || tieneFechaEntrega)
                        ? Colors.grey
                        : Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  label: const Text(
                    'Entrega',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: (!tieneFechaSiembra || tieneFechaEntrega)
                      ? null
                      : () => _updateEntregaDate(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:pilones_de_oriente/widgets/show_notification.dart';

class OrderCardWidget extends StatefulWidget {
  final Map<String, dynamic> order;
  final double screenWidth;
  final DatabaseReference dbRef;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.screenWidth,
    required this.dbRef,
  });

  @override
  _OrderCardWidgetState createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  late Map<String, dynamic> _currentOrder;
  late DatabaseReference _orderRef;

  @override
  void initState() {
    super.initState();
    _currentOrder = Map.from(widget.order);
    _orderRef = widget.dbRef.child(_currentOrder['key']);
    _setupDatabaseListener();
  }

  void _setupDatabaseListener() {
    _orderRef.onValue.listen((event) {
      if (event.snapshot.value != null && mounted) {
        final updatedData = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _currentOrder = {
            'key': _currentOrder['key'],
            'nombre': updatedData['nombre'] ?? 'No disponible',
            'tipo': updatedData['tipo'] ?? 'No disponible',
            'cultivo': updatedData['cultivo'] ?? 'No disponible',
            'cantidad': updatedData['cantidad'] ?? 0,
            'fechaSiembra': updatedData['fechaSiembra'],
            'fechaEntrega': updatedData['fechaEntrega'],
            'semillaSobrante': updatedData['semillaSobrante'],
            'numeroLote': updatedData['numeroLote'] ?? 'No definido',
            'numeroLote2': updatedData['numeroLote2'] ?? 'No definido',
            'precioTotal': updatedData['precioTotal'] ?? 0.0,
            'metodoPago': updatedData['metodoPago'] ?? 'No especificado',
          };
        });
      }
    });
  }

  void _updateSiembraDate(BuildContext context) async {
    final newDate = await _selectDate(context);
    if (newDate != null) {
      bool confirm =
          await _showConfirmationDialog(context, "fechaSiembra", newDate);

      if (confirm) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
        _orderRef.update({"fechaSiembra": formattedDate});

        bool proceed = await _showPreAlertMessage(context);
        if (!proceed) return;

        DateTime? notificationDate = await _selectNotificationDate(context);

        if (notificationDate != null) {
          String title = "Alerta de Siembra";
          String body =
              "${_currentOrder['nombre'] ?? 'Cliente no disponible'}, con el cultivo: ${_currentOrder['cultivo'] ?? 'No disponible'} ${_currentOrder['tipo'] ?? 'No disponible'}, fecha de siembra: $formattedDate";

          final notificationService = LocalNotificationService();
          await notificationService.scheduleNotification(
            title,
            body,
            notificationDate,
          );
        }
      }
    }
  }

  void _updateLoteNumber(BuildContext context) async {
    TextEditingController lote1Controller = TextEditingController(
      text: _currentOrder['numeroLote']?.toString() ?? '',
    );

    TextEditingController lote2Controller = TextEditingController(
      text: _currentOrder['numeroLote2']?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Números de Lote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: lote1Controller,
              decoration: const InputDecoration(
                labelText: 'Lote de Siembra',
                hintText: 'Ingrese el primer número de lote',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lote2Controller,
              decoration: const InputDecoration(
                labelText: 'Lote de Fabrica',
                hintText: 'Ingrese el segundo número de lote',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (lote1Controller.text.isNotEmpty ||
                  lote2Controller.text.isNotEmpty) {
                _orderRef.update({
                  "numeroLote": lote1Controller.text,
                  "numeroLote2": lote2Controller.text,
                }).then((_) {
                  Navigator.of(context).pop();
                });
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showPreAlertMessage(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Atención'),
              content: const Text(
                'A continuación, se te pedirá que selecciones la fecha de la alerta. '
                'Por favor, elige un día en el que quieras recibir el recordatorio.',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Continuar'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<DateTime?> _selectNotificationDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        return await showDialog<DateTime>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar fecha y hora'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          'Fecha: ${DateFormat('dd-MM-yyyy').format(finalDateTime)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Hora: ${selectedTime.format(context)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(finalDateTime),
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    }
    return null;
  }

  void _updateEntregaDate(BuildContext context) async {
    final newDate = await _selectDate(context);
    if (newDate != null) {
      final remainingSeeds = await _showSeedInputDialog(context);
      if (remainingSeeds != null) {
        bool confirm =
            await _showConfirmationDialog(context, "fechaEntrega", newDate);
        if (confirm) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
          _orderRef.update({
            "fechaEntrega": formattedDate,
            "semillaSobrante": remainingSeeds,
          });
        }
      }
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<String?> _showSeedInputDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cantidad de Semilla Sobrante'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Semilla sobrante',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String fieldName, DateTime newDate) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar actualización'),
            content: Text(
              '¿Estás seguro de que quieres insertar la ${fieldName == "fechaSiembra" ? "siembra" : "entrega"} para la fecha $formattedDate?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    bool tieneFechaSiembra = _currentOrder['fechaSiembra'] != null;
    bool tieneFechaEntrega = _currentOrder['fechaEntrega'] != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${_currentOrder['nombre'] ?? 'No disponible'}',
              style: TextStyle(
                fontSize: widget.screenWidth > 600 ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Cantidad: ${_currentOrder['cantidad'] ?? 0}'),
            Text(
                'Cultivo: ${(_currentOrder['cultivo'] ?? 'No disponible')} ${(_currentOrder['tipo'] ?? '')}'),
            Text(
                'Fecha de Siembra: ${_currentOrder['fechaSiembra'] ?? 'No definida'}'),
            Text(
                'Fecha de Entrega: ${_currentOrder['fechaEntrega'] ?? 'No definida'}'),
            Text(
                'Semilla Sobrante: ${_currentOrder['semillaSobrante'] ?? 'No definida'}'),
            Text(
                'Número de Lote 1: ${_currentOrder['numeroLote'] ?? 'No definido'}'),
            Text(
                'Número de Lote 2: ${_currentOrder['numeroLote2'] ?? 'No definido'}'),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                // Ajustamos el diseño según el ancho disponible
                if (constraints.maxWidth < 500) {
                  // Diseño para pantallas pequeñas (vertical)
                  return Column(
                    children: [
                      _buildActionButton(
                        context: context,
                        label: 'Lotes',
                        icon: Icons.edit,
                        color: Colors.blue,
                        onPressed: () => _updateLoteNumber(context),
                      ),
                      const SizedBox(height: 8),
                      _buildActionButton(
                        context: context,
                        label: 'Siembra',
                        icon: Icons.add,
                        color: tieneFechaSiembra ? Colors.grey : Colors.brown,
                        onPressed: tieneFechaSiembra
                            ? null
                            : () => _updateSiembraDate(context),
                      ),
                      const SizedBox(height: 8),
                      _buildActionButton(
                        context: context,
                        label: 'Entrega',
                        icon: Icons.add,
                        color: (!tieneFechaSiembra || tieneFechaEntrega)
                            ? Colors.grey
                            : Colors.green,
                        onPressed: (!tieneFechaSiembra || tieneFechaEntrega)
                            ? null
                            : () => _updateEntregaDate(context),
                      ),
                    ],
                  );
                } else {
                  // Diseño para pantallas más anchas (horizontal)
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildActionButton(
                          context: context,
                          label: 'Lotes',
                          icon: Icons.edit,
                          color: Colors.blue,
                          onPressed: () => _updateLoteNumber(context),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          context: context,
                          label: 'Siembra',
                          icon: Icons.add,
                          color: tieneFechaSiembra ? Colors.grey : Colors.brown,
                          onPressed: tieneFechaSiembra
                              ? null
                              : () => _updateSiembraDate(context),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          context: context,
                          label: 'Entrega',
                          icon: Icons.add,
                          color: (!tieneFechaSiembra || tieneFechaEntrega)
                              ? Colors.grey
                              : Colors.green,
                          onPressed: (!tieneFechaSiembra || tieneFechaEntrega)
                              ? null
                              : () => _updateEntregaDate(context),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 120, // Ancho fijo para consistencia
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
