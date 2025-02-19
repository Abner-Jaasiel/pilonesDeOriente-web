import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/models/order_seller_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  _ProviderDashboardScreenState createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  List<OrderSellerModel> orders = [];
  String? sellerFirebaseUid;
  String? token;
  List<int> selectedCartItemIds = []; // Lista de cartItemIds seleccionados

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  // Obtener el UID y el token del usuario actualmente autenticado
  Future<void> _getCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        sellerFirebaseUid = user.uid;
        token = await user.getIdToken();
        fetchOrders(sellerFirebaseUid!, token!);
      } else {
        print("No hay usuario autenticado.");
      }
    } catch (e) {
      print("Error obteniendo datos del usuario: $e");
    }
  }

  // Función para obtener los pedidos del proveedor
  Future<void> fetchOrders(String sellerFirebaseUid, String token) async {
    final response =
        await APIService().fetchOrdersBySeller(sellerFirebaseUid, token);
    setState(() {
      orders = response;
    });
  }

  // Función para mostrar opciones en un modal
  void showOrderOptions(OrderSellerModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pedido de ${order.buyerFirebaseUid}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Producto: ${order.productId}'),
                  Text('Cantidad: ${order.quantity}'),
                  const SizedBox(height: 10),
                  Text('Precio: \$${order.price}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Procesar pedido'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Cancelar pedido'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Función para manejar la selección de un grupo
  void toggleGroupSelection(bool isSelected, List<OrderSellerModel> orders) {
    setState(() {
      if (isSelected) {
        // Agregar todos los cartItemIds del grupo
        for (var order in orders) {
          if (!selectedCartItemIds.contains(order.cartItemId)) {
            selectedCartItemIds.add(order.cartItemId);
          }
        }
      } else {
        // Eliminar todos los cartItemIds del grupo
        for (var order in orders) {
          selectedCartItemIds.remove(order.cartItemId);
        }
      }
    });
  }

  // Función para enviar los ítems seleccionados

  void sendSelectedItems() {
    if (selectedCartItemIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Envío'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Se enviarán los siguientes ítems:'),
              const SizedBox(height: 10),
              ...orders
                  .where(
                      (order) => selectedCartItemIds.contains(order.cartItemId))
                  .map((order) => ListTile(
                        leading: Image.network(order.urlImage[0],
                            width: 50, height: 50),
                        title: Text('Producto: ${order.productId}'),
                        subtitle: Text(
                            'Cantidad: ${order.quantity}, Precio: \$${order.price}'),
                      )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Obtener los ítems seleccionados
                final selectedOrders = orders
                    .where((order) =>
                        selectedCartItemIds.contains(order.cartItemId))
                    .toList();

                // Navegar a la pantalla que muestra todos los tickets
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TicketListScreen(selectedOrders: selectedOrders),
                  ),
                );
              },
              child: const Text('Confirmar Envío'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ordenar las órdenes por identityNumber y orderId
    orders.sort((a, b) {
      int identityCompare = a.identityNumber.compareTo(b.identityNumber);
      if (identityCompare != 0) return identityCompare;
      return a.orderId.compareTo(b.orderId);
    });

    // Agrupar las órdenes por identityNumber y orderId
    final Map<String, List<OrderSellerModel>> groupedOrders = {};
    for (var order in orders) {
      final key = '${order.identityNumber}_${order.orderId}';
      if (!groupedOrders.containsKey(key)) {
        groupedOrders[key] = [];
      }
      groupedOrders[key]!.add(order);
    }

    // Convertir el mapa a una lista de grupos
    final List<MapEntry<String, List<OrderSellerModel>>> orderGroups =
        groupedOrders.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos del Proveedor'),
      ),
      body: orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderGroups.length,
              itemBuilder: (context, index) {
                final group = orderGroups[index];
                final key = group.key;
                final ordersInGroup = group.value;

                final parts = key.split('_');
                final identityNumber = parts[0];
                final orderId = parts[1];

                // Verificar si todos los elementos del grupo están seleccionados
                bool isGroupSelected = ordersInGroup.every(
                    (order) => selectedCartItemIds.contains(order.cartItemId));

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Checkbox(
                          value: isGroupSelected,
                          onChanged: (bool? value) {
                            toggleGroupSelection(value ?? false, ordersInGroup);
                          },
                        ),
                        Text(
                          'Pedidos de Identidad: $identityNumber, Orden: $orderId',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    children: ordersInGroup.map((order) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: CheckboxListTile(
                          value: selectedCartItemIds.contains(order.cartItemId),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected ?? false) {
                                selectedCartItemIds.add(order.cartItemId);
                              } else {
                                selectedCartItemIds.remove(order.cartItemId);
                              }
                            });
                          },
                          title: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  width: 100,
                                  height: 100,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: order.urlImage[0])),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Pedido #${order.orderId}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text('Precio: \$${order.price}'),
                                  Text('Cantidad: ${order.quantity}'),
                                  Text('Estado: ${order.status}'),
                                  Text(
                                    'Fecha: ${DateFormat('dd/MM/yyyy').format(order.addedAt)}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      // Botón de envío flotante
      floatingActionButton: FloatingActionButton(
        onPressed: selectedCartItemIds.isNotEmpty ? sendSelectedItems : null,
        tooltip: 'Enviar ítems seleccionados',
        child: const Icon(Icons.send),
      ),
    );
  }
}

class TicketListScreen extends StatelessWidget {
  final List<OrderSellerModel> selectedOrders;

  TicketListScreen({super.key, required this.selectedOrders});
  final ScreenshotController controller = ScreenshotController();
  final GlobalKey previewContainer = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tickets de Pedidos")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: ElevatedButton(
              onPressed: () {
                captureTicket();
              },
              child: const Text('Imprimir Todos los Tickets'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedOrders.length,
              itemBuilder: (context, index) {
                final order = selectedOrders[index];
                return Screenshot(
                  controller: controller,
                  child: RepaintBoundary(
                    key: previewContainer,
                    child: TicketWidget(order: order),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void captureTicket() async {
    final file = await controller.capture();
    if (file != null) {
      // Utiliza el archivo según sea necesario (por ejemplo, para imprimir o compartir)
    }
  }
}
