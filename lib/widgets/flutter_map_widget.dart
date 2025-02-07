import 'package:carkett/providers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class FlutterMapWidget extends StatefulWidget {
  final double lat;
  final double long;

  const FlutterMapWidget({
    super.key,
    required this.lat,
    required this.long,
  });

  @override
  State<FlutterMapWidget> createState() => _FlutterMapWidgetState();
}

class _FlutterMapWidgetState extends State<FlutterMapWidget> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(LatLng(widget.lat, widget.long), 13);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Provider.of<ThemeController>(context);
    LatLng initialPosition = LatLng(widget.lat, widget.long);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: initialPosition,
        initialZoom: 13,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all, // Permitir interacción si es necesario
        ),
        backgroundColor: Colors.black,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://{s}.basemaps.cartocdn.com/${themeController.getTextTheme()}_all/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: initialPosition,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
