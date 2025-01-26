import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  Future<void> _fetchLocationName(
      LatLng location, LocationController locationController) async {
    final locationName = await getLocationName(location);

    setState(() {});

    if (locationName != null) {
      locationController.setLocationName(locationName);
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
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: selectedLocation ?? const LatLng(0, 0),
              initialZoom: 13,
              onTap: (tapPosition, point) async {
                LocationController locationController =
                    Provider.of<LocationController>(context, listen: false);

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
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Confirm Location",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
