import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseService({FirebaseAuth? authInstance, FirebaseFirestore? firestoreInstance})
      : auth = authInstance ?? FirebaseAuth.instance,
        firestore = firestoreInstance ?? FirebaseFirestore.instance;

  Future<UserCredential> createUser({
    required String email,
    required String password,
  }) {
    return auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> saveUserData({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return firestore.collection('users').doc(uid).set(data);
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Stream<User?> authStateChanges() => auth.authStateChanges();

Future<Map<String, dynamic>?> getUserData({required String uid}) async {
  final doc = await firestore.collection('users').doc(uid).get();
  return doc.data();
}

  Future<void> signOut() => auth.signOut();
}
