import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final double screenWidth;
  final DatabaseReference dbRef;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.screenWidth,
    required this.dbRef,
  });

  void _updateSiembraDate(BuildContext context) async {
    final newDate = await _selectDate(context);
    if (newDate != null) {
      bool confirm =
          await _showConfirmationDialog(context, "fechaSiembra", newDate);
      if (confirm) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
        dbRef.child(order['key']).update({"fechaSiembra": formattedDate});
      }
    }
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
          dbRef.child(order['key']).update({
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
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(null),
          ),
          ElevatedButton(
            child: const Text('Aceptar'),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.of(context).pop(controller.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String fieldName, DateTime newDate) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar actualización'),
            content: Text(
              '¿Estás seguro de que quieres insertar la ${fieldName == "fechaSiembra" ? "siembra" : "entrega"} para la fecha $formattedDate?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child: const Text('Confirmar'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    bool tieneFechaSiembra = order['fechaSiembra'] != null;
    bool tieneFechaEntrega = order['fechaEntrega'] != null;

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
              'Nombre: ${order['nombre']}',
              style: TextStyle(
                fontSize: screenWidth > 600 ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Cantidad: ${order['cantidad']}'),
            Text('Cultivo: ${order['cultivo']}'),
            Text('Fecha de Siembra: ${order['fechaSiembra'] ?? 'No definida'}'),
            Text('Fecha de Entrega: ${order['fechaEntrega'] ?? 'No definida'}'),
            Text(
                'Semilla Sobrante: ${order['semillaSobrante'] ?? 'No definida'}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
}
