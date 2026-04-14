import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String childName;
  final String childBirth;
  final bool agreedToTerms;

  SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.childName,
    required this.childBirth,
    required this.agreedToTerms,
  });

  @override
  List<Object?> get props => [name, email, childName, childBirth, agreedToTerms];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}


class AuthPasswordVisibilityToggled extends AuthEvent {}

class AuthTermsChanged extends AuthEvent {
  final bool agreedToTerms;
  
  AuthTermsChanged({required this.agreedToTerms});
  
  @override
  List<Object?> get props => [agreedToTerms];
}