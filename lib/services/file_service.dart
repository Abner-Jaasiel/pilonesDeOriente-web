import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> downloadFile(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/cube.obj';

      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);

      return path;
    } else {
      print('Error al descargar el archivo: ${response.statusCode}');
      return "";
    }
  } catch (e) {
    print('Error: $e');
    return "";
  }
}

Future<String?> uploadProductImageFirebase(
    XFile image, String productId) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  File file = File(image.path);

  try {
    final String path = 'products/$productId/images/${image.name}';
    await storage.ref(path).putFile(file);
    print("FULL");
    return await storage.ref(path).getDownloadURL();
  } catch (e) {
    print("MAL Error: $e");
  }
  return null;
}

Future<String?> uploadUserImageFirebase(
    XFile image, String? previousImageUrl) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  File file = File(image.path);

  try {
    if (uid != null) {
      if (previousImageUrl != null) {
        try {
          final Reference previousImageRef =
              storage.refFromURL(previousImageUrl);
          await previousImageRef.delete();
        } catch (e) {
          if (e is FirebaseException && e.code == 'object-not-found') {
            print("la imagen previa no existe, continuo...");
          } else {
            print("Error: $e");
          }
        }
      }
      final String path = 'users/$uid/images/${image.name}';
      await storage.ref(path).putFile(file);

      return await storage.ref(path).getDownloadURL();
    }
  } catch (e) {
    print("Error : $e");
  }
  return null;
}
