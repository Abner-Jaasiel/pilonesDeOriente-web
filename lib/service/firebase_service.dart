import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Future<String?> getCurrentUserRole() async {
    String? currentEmail = getCurrentUserEmail();
    print("Email actual: $currentEmail");
    if (currentEmail == null) {
      return null;
    }

    try {
      DatabaseEvent userRolesSnapshot =
          await _dbRef.child('data/userRoles').once();
      if (userRolesSnapshot.snapshot.value != null) {
        List<dynamic> userRoles =
            userRolesSnapshot.snapshot.value as List<dynamic>;
        var roleEntry = userRoles.firstWhere(
          (role) => role['email'] == currentEmail,
          orElse: () => {},
        );

        if (roleEntry.isNotEmpty) {
          return roleEntry['role'];
        }
      } else {
        print('No se encontraron roles de usuario');
      }
    } catch (e) {
      print("Error al cargar roles de usuario: ${e.toString()}");
    }

    return null;
  }

  String? getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<Map<String, dynamic>> loadDataPrice() async {
    try {
      DatabaseEvent productSnapshot =
          await _dbRef.child('data/products').once();
      DatabaseEvent priceSettingsSnapshot =
          await _dbRef.child('data/priceSettings').once();

      Map<String, dynamic> data = {};

      if (productSnapshot.snapshot.value != null &&
          productSnapshot.snapshot.value is Map) {
        data['products'] =
            Map<String, dynamic>.from(productSnapshot.snapshot.value as Map);
      } else {
        data['products'] = null;
        print('No se encontraron productos');
      }

      if (priceSettingsSnapshot.snapshot.value != null) {
        var priceSettingsData = priceSettingsSnapshot.snapshot.value;

        if (priceSettingsData is Map) {
          data['priceSettings'] = Map<String, dynamic>.from(priceSettingsData);
        } else if (priceSettingsData is List) {
          data['priceSettings'] = {
            for (int i = 0; i < priceSettingsData.length; i++)
              i.toString(): priceSettingsData[i]
          };
        } else {
          data['priceSettings'] = null;
          print('Formato inesperado en priceSettings');
        }
      } else {
        data['priceSettings'] = null;
        print('No se encontraron configuraciones de precios');
      }

      return data;
    } catch (e) {
      print("Error al cargar datos: ${e.toString()}");
      throw Exception("Error al cargar datos: ${e.toString()}");
    }
  }

  Future<void> saveSentData(Map<String, dynamic> data) async {
    try {
      DatabaseReference ref = _dbRef.child('forms');
      await ref.push().set(data);
    } catch (e) {
      print('Error saving data: $e');
      rethrow;
    }
  }
}
