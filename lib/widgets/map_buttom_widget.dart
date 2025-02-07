import 'package:carkett/widgets/custom_show_modal_bottom_sheet.dart';
import 'package:carkett/widgets/flutter_map_widget.dart';
import 'package:flutter/material.dart';

class MapButtomWidget extends StatelessWidget {
  final double lat;
  final double long;
  final double height;
  final VoidCallback? onTap;

  const MapButtomWidget({
    super.key,
    this.lat = 22,
    this.long = 22,
    this.height = 200,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 500),
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FlutterMapWidget(lat: lat, long: long),
          ),
        ),
        InkWell(
          onTap: onTap ??
              () {
                // Función predeterminada si no se proporciona `onTap`
                customShowModalBottomListItem(
                  context: context,
                  title: "Map",
                  items: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(90, 92, 119, 122),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 450,
                            width: double.infinity,
                            child: FlutterMapWidget(lat: lat, long: long),
                          ),
                        ),
                      ),
                    ),
                  ],
                  height: 500,
                  padding: const EdgeInsets.all(0),
                );
              },
          child: Container(
            height: 130,
            margin: const EdgeInsets.only(top: 100),
          ),
        ),
      ],
    );
  }
}
