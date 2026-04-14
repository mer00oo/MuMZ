import '../repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository); 

  Future<UserModel> call({
    required String name,
    required String email,
    required String password,
    required String childName,
    required String childBirth,
  }) {
    return repository.signUp(
      name: name,
      email: email,
      password: password,
      childName: childName,
      childBirth: childBirth,
    );
  }
}