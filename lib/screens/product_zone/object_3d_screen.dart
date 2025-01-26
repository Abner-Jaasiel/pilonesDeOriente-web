import 'package:camera/camera.dart';
import 'package:carkett/services/file_service.dart';
import 'package:carkett/widgets/custom_appbar_blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Object3dScreen extends StatefulWidget {
  final String modelUrl;

  const Object3dScreen({super.key, required this.modelUrl});

  @override
  // ignore: library_private_types_in_public_api
  _Object3dScreenState createState() => _Object3dScreenState();
}

class _Object3dScreenState extends State<Object3dScreen> {
  late Future<String> _modelPath;

  @override
  void initState() {
    super.initState();
    _modelPath = downloadFile(widget.modelUrl);
  }

  @override
  Widget build(BuildContext context) {
    print(_modelPath);
    return Scaffold(
      appBar: AppBar(title: const Text("Modelo 3D Remoto")),
      body: Center(
        child: FutureBuilder<String>(
          future: _modelPath,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Cube(
                onSceneCreated: (Scene scene) {
                  scene.world
                      .add(Object(fileName: snapshot.data!, isAsset: false));
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Object3dWithCameraScreen extends StatefulWidget {
  final String modelUrl;

  const Object3dWithCameraScreen({super.key, required this.modelUrl});

  @override
  _Object3dWithCameraScreenState createState() =>
      _Object3dWithCameraScreenState();
}

class _Object3dWithCameraScreenState extends State<Object3dWithCameraScreen> {
  late Future<String> _modelPath;
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();

    _modelPath = downloadFile(widget.modelUrl);
  }

  Future<void> _initializeAndOffCamera(bool onCamara) async {
    if (onCamara) {
      try {
        cameras = await availableCameras();
        _cameraController = CameraController(cameras[0], ResolutionPreset.high);
        await _cameraController!.initialize();
      } catch (e) {
        print('Error inicializando la cámara: $e');
      }
    } else {
      if (_cameraController != null) {
        await _cameraController!.dispose();
        _cameraController = null;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: CustomAppBarBlur(title: "3D"),
        ),
        body: Stack(
          children: [
            if (_cameraController != null &&
                _cameraController!.value.isInitialized)
              CameraPreview(_cameraController!),
            Center(
              child: FutureBuilder<String>(
                future: _modelPath,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Cube(
                      onSceneCreated: (Scene scene) {
                        final object =
                            Object(fileName: snapshot.data!, isAsset: false);

                        // object.scale.setValues(100, 100, 100);

                        scene.world.add(object);
                      },
                    );
                  }
                },
              ),
            ),
            Positioned(
              right: 26.0,
              bottom: 26.0,
              child: Switch(
                thumbIcon: const WidgetStatePropertyAll(
                    Icon(Icons.camera_alt_outlined)),
                value: isSwitched,
                onChanged: (value) {
                  _initializeAndOffCamera(value);
                  isSwitched = value;
                },
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
