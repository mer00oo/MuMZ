// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/auth/domain/usecase/log_in.dart';
import 'package:mamyapp/features/auth/domain/usecase/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.signUpUseCase,
    required this.loginUseCase,
  }) : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    
    on<AuthPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<AuthTermsChanged>(_onTermsChanged);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!event.agreedToTerms) {
      emit(AuthFailure('يرجى الموافقة على الشروط والأحكام'));
      return;
    }

    if (event.name.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        event.childName.isEmpty ||
        event.childBirth.isEmpty) {
      emit(AuthFailure('يرجى ملء جميع الحقول'));
      return;
    }

    if (!event.email.contains('@')) {
      emit(AuthFailure('يرجى إدخال بريد إلكتروني صالح'));
      return;
    }

    emit(AuthLoading());
    try {
      final user = await signUpUseCase(
        name: event.name,
        email: event.email,
        password: event.password,
        childName: event.childName,
        childBirth: event.childBirth,
      );
      emit(AuthAuthenticated(user));
    } on Exception catch (e) {
      emit(AuthFailure(e.toString()));
    } catch (e) {
      emit(AuthFailure('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(AuthFailure('يرجى ملء البريد وكلمة المرور'));
      return;
    }
    emit(AuthLoading());
    try {
      final user = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } on Exception catch (e) {
      emit(AuthFailure(e.toString()));
    } catch (e) {
      emit(AuthFailure('حدث خطأ غير متوقع'));
    }
  }


  void _onPasswordVisibilityToggled(
    AuthPasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthSignUpInProgress) {
      final currentState = state as AuthSignUpInProgress;
      emit(currentState.copyWith(
        isPasswordVisible: !currentState.isPasswordVisible,
      ));
    } else {
      // لو مش في SignUpInProgress، ابدأ واحدة جديدة
      emit(AuthSignUpInProgress(isPasswordVisible: true));
    }
  }

  void _onTermsChanged(
    AuthTermsChanged event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthSignUpInProgress) {
      final currentState = state as AuthSignUpInProgress;
      emit(currentState.copyWith(
        agreedToTerms: event.agreedToTerms,
      ));
    } else {
      emit(AuthSignUpInProgress(
        agreedToTerms: event.agreedToTerms,
      ));
    }
  }
}
