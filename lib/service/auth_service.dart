import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _createUserData(result.user!);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> _createUserData(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        // Add other user data fields as needed
      });
    } catch (e) {
      print(e.toString());
    }
  }


  // Sign out
  Future<bool> signOut() async {
      try{
        await _auth.signOut();
        return true;
      }
      catch(e){
        return false;
      }

  }
}