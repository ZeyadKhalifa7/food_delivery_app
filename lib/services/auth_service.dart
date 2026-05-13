import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.userChanges();

  String? get currentUserId => _auth.currentUser?.uid;

  Future<User?> signUpWithEmail(String email, String password, String displayName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(displayName);
      await _firestore.collection('users').doc(result.user!.uid).set({
        'displayName': displayName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('SignUp error: ${e.code}');
      return null;
    }
  }

  Future<bool> updateDisplayName(String newDisplayName) async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      await user.updateDisplayName(newDisplayName);
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': newDisplayName,
      });
      return true;
    } catch (e) {
      print('Update display name error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('SignIn error: ${e.code}');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}