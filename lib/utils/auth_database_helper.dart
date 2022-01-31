import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final _auth = FirebaseAuth.instance;

  static User get currentUser => _auth.currentUser;

  static Future createUser(email, password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future signIn(email, password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future logout() async {
    return await _auth.signOut();
  }
}
