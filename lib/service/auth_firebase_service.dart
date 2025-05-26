import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService {
  Future<void> registerWithEmailAndPassword(
      String password, String email, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("Usuario registrado: ${userCredential.user?.uid}");

      await signInWithEmailAndPassword(password, email);
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.code} - ${e.message}");
    } catch (e) {
      print("Error desconocido: $e");
    }
  }

  Future<void> signInWithEmailAndPassword(String password, String email) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> getIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  Future<String?> getUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      print(e);
    }
  }
}
