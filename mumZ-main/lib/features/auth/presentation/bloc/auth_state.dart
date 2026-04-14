import 'package:equatable/equatable.dart';
import 'package:mamyapp/features/auth/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}


class AuthSignUpInProgress extends AuthState {
  final bool isPasswordVisible;
  final bool agreedToTerms;

  AuthSignUpInProgress({
    this.isPasswordVisible = false,
    this.agreedToTerms = false,
  });

  AuthSignUpInProgress copyWith({
    bool? isPasswordVisible,
    bool? agreedToTerms,
  }) {
    return AuthSignUpInProgress(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible, agreedToTerms];
}