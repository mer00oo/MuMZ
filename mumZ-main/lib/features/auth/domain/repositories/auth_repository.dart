import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String childName,
    required String childBirth,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });
}
