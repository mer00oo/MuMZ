import 'package:firebase_auth/firebase_auth.dart';
import '../../../../services/firebase_service.dart';

class AuthRemoteDataSource {
  final FirebaseService firebaseService;

  AuthRemoteDataSource(this.firebaseService);

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return firebaseService.createUser(email: email, password: password);
  }

  Future<void> saveProfile({
    required String uid,
    required Map<String, dynamic> profileData,
  }) {
    return firebaseService.saveUserData(uid: uid, data: profileData);
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return firebaseService.signIn(email: email, password: password);
  }

Future<Map<String, dynamic>?> getUserProfile(String uid) {
  return firebaseService.getUserData(uid: uid);
}
}
