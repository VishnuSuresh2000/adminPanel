import 'package:beru_admin/Schema/Admin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  loginWithEmailAndPassword(Admin user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      return true;
    } catch (e) {
      print("Error from loginWithEmailAndPassword $e");
      throw e;
    }
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
