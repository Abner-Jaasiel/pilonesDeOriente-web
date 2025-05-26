import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pilones_de_oriente/service/firebase_service.dart';
import 'package:pilones_de_oriente/widgets/orde_card_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('forms');
  final ScrollController _scrollControllerActivos = ScrollController();
  final ScrollController _scrollControllerHistorial = ScrollController();
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    _dbRef.onChildAdded.listen((event) {
      final order = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        orders.insert(0, {
          'key': event.snapshot.key,
          'nombre': order['nombre'],
          'cultivo': order['cultivo'],
          'cantidad': order['cantidad'],
          'fechaSiembra': order['fechaSiembra'],
          'fechaEntrega': order['fechaEntrega'],
          'semillaSobrante': order['semillaSobrante'], // Added new field
        });
      });
      _scrollToTop();
    });

    _dbRef.onChildChanged.listen((event) {
      final updatedOrder = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        final index = orders.indexWhere((o) => o['key'] == event.snapshot.key);
        if (index != -1) {
          orders[index] = {
            'key': event.snapshot.key,
            'nombre': updatedOrder['nombre'],
            'cultivo': updatedOrder['cultivo'],
            'cantidad': updatedOrder['cantidad'],
            'fechaSiembra': updatedOrder['fechaSiembra'],
            'fechaEntrega': updatedOrder['fechaEntrega'],
            'semillaSobrante':
                updatedOrder['semillaSobrante'], // Added new field
          };
        }
      });
    });
  }

  void _scrollToTop() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollControllerActivos.hasClients) {
        _scrollControllerActivos.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      if (_scrollControllerHistorial.hasClients) {
        _scrollControllerHistorial.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final pedidosActivos =
        orders.where((order) => order['fechaEntrega'] == null).toList();
    final pedidosHistorial =
        orders.where((order) => order['fechaEntrega'] != null).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos Recibidos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Actuales'),
              Tab(text: 'Historial'),
            ],
          ),
        ),
        body: FutureBuilder(
          future: FirebaseService().getCurrentUserRole(),
          builder: (context, snapshot) {
            final String role = dotenv.env['ROLE_ORDERS_AND_DELIVERIES'] ??
                'orders_and_deliveries';
            if (snapshot.data == role || snapshot.data == 'admin') {
              return TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth > 600 ? 50 : 16.0),
                    child: ListView.builder(
                      controller: _scrollControllerActivos,
                      itemCount: pedidosActivos.length,
                      itemBuilder: (context, index) {
                        final order = pedidosActivos[index];
                        return OrderCardWidget(
                          order: order,
                          screenWidth: screenWidth,
                          dbRef: _dbRef,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth > 600 ? 50 : 16.0),
                    child: ListView.builder(
                      controller: _scrollControllerHistorial,
                      itemCount: pedidosHistorial.length,
                      itemBuilder: (context, index) {
                        final order = pedidosHistorial[index];
                        return OrderCardWidget(
                          order: order,
                          screenWidth: screenWidth,
                          dbRef: _dbRef,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
