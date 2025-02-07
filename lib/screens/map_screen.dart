import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/message_container_widget.dart';
import 'package:carkett/widgets/super_progressindicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;
  String locationMessage = "Ubicación no obtenida";

  Future<void> _fetchLocationName(
      LatLng location, LocationController locationController) async {
    final locationName = await getLocationName(location);

    setState(() {});

    if (locationName != null) {
      locationController.setLocationName(locationName);
    }
  }

  Future<void> _getLocation(LocationController locationController) async {
    Position? position = await LocationService.getCurrentLocation();
    if (position != null) {
      selectedLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        locationMessage = "No se pudo obtener la ubicación.";
      });
    }
  }

  @override
  void initState() {
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);
    selectedLocation = locationController.locationLat != null &&
            locationController.locationLng != null
        ? LatLng(
            locationController.locationLat!, locationController.locationLng!)
        : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: selectedLocation ?? const LatLng(14.0333, 86.5833),
              initialZoom: 13,
              onTap: (tapPosition, point) async {
                setState(() {
                  selectedLocation = point;
                });
                locationController.setLocation(
                    selectedLocation ?? const LatLng(14.0333, 86.5833));
                await _fetchLocationName(point, locationController);
                if (selectedLocation != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Location Confirmed: ${locationController.locationName}",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a location."),
                    ),
                  );
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: selectedLocation != null
                    ? [
                        Marker(
                          point: selectedLocation!,
                          width: 80.0,
                          height: 80.0,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                      ]
                    : [],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text(
                "Confirm Location",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Positioned(
              top: 4,
              left: 1,
              child: Row(
                children: [
                  RawMaterialButton(
                    onPressed: () async {
                      superProgressIndicator(context);
                      try {
                        await _getLocation(locationController);
                        locationController.setLocation(
                            selectedLocation ?? const LatLng(14.0333, 86.5833));

                        await _fetchLocationName(
                            selectedLocation!, locationController);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Location Confirmed: ${locationController.locationName}",
                            ),
                          ),
                        );
                      } on Exception catch (e) {
                        // TODO
                      }
                      GoRouter.of(context).pop();
                    },
                    elevation: 1.0,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.location_on,
                      size: 28.0,
                    ),
                  ),
                  const MessageContainerWidget(
                    message: "< GPS",
                    maxWidth: 200,
                    margin: 0,
                    rewrite: true,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
