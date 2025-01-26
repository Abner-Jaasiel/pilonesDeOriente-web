import 'package:carkett/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthFirebaseService {
  Future<void> registerWithEmailAndPassword(
      String password, String email, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("😒1 ${userCredential.user!.uid} y $name");

      await Future.delayed(const Duration(seconds: 5));
      final createdUser =
          await APIService().createUser(userCredential.user!.uid, name);
      print("😒2 ${userCredential.user!.uid} y $name");
      if (!createdUser) {
        await userCredential.user!.delete();
        print("😒3 ${userCredential.user!.uid} y $name");
      }
      await Future.delayed(const Duration(seconds: 5));
      await signInWithEmailAndPassword(password, email);

      print("😒4  ${userCredential.user!.uid} y $name");
    } catch (e) {
      print(e);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('user');
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
