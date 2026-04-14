import 'package:flutter/foundation.dart';
import 'package:mamyapp/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String childName,
    required String childBirth,
  }) async {
    final cred = await remote.signUp(email: email, password: password);
    final user = cred.user!;
    final birth = DateTime.tryParse(childBirth);
    final today = DateTime.now();
    final age = birth == null
        ? 0
        : today.year - birth.year - ((today.month < birth.month || (today.month == birth.month && today.day < birth.day)) ? 1 : 0);

    final profile = {
      'name': name,
      'email': email,
      'childName': childName,
      'birthdate': childBirth,
      'age': age,
    };

    await remote.saveProfile(uid: user.uid, profileData: profile);

    return UserModel(
      uid: user.uid,
      name: name,
      email: email,
      childName: childName,
      childBirth: childBirth,
      age: age,
    );
  }

  @override
  @override
Future<UserModel> login({required String email, required String password}) async {
  final cred = await remote.login(email: email, password: password);
  final user = cred.user!;

  try {
    final userData = await remote.getUserProfile(user.uid);

    if (userData != null) {
      return UserModel(
        uid: user.uid,
        name: userData['name'] ?? user.displayName ?? '',
        email: user.email ?? email,
        childName: userData['childName'] ?? '',       
        childBirth: userData['birthdate'] ?? '',    
        age: (userData['age'] ?? 0) as int,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching user data: $e');
    }
  }

  return UserModel(
    uid: user.uid,
    name: user.displayName ?? '',
    email: user.email ?? email,
    childName: '',
    childBirth: '',
    age: 0,
  );
}}