// lib/features/auth/data/models/user_model.dart
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.childName,
    required super.childBirth,
    required super.age,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      childName: map['childName'] ?? '',
      childBirth: map['birthdate'] ?? '',
      age: (map['age'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'childName': childName,
      'birthdate': childBirth,
      'age': age,
    };
  }
}
