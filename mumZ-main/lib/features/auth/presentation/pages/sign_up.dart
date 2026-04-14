import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/core/di/injection_container.dart' as di;
import 'package:mamyapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mamyapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:mamyapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:mamyapp/features/auth/presentation/widget/button_sign_up.dart';
import 'package:mamyapp/features/auth/presentation/widget/data_picker.dart';
import 'package:mamyapp/features/auth/presentation/widget/passwoed_field.dart';
import 'package:mamyapp/features/auth/presentation/widget/terms_checkbox.dart';
import 'package:mamyapp/features/auth/presentation/widget/text_field.dart';
import 'package:mamyapp/features/home/presentation/pages/home_page.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final childNameCtrl = TextEditingController();
  final childBirthCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
create: (_) => di.sl<AuthBloc>(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFFEF4E9), Color(0xFFFBD8BA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          userName: state.user.name.isNotEmpty ? state.user.name : nameCtrl.text,
                          childName: state.user.childName.isNotEmpty ? state.user.childName : childNameCtrl.text,
                          childBirth: state.user.childBirth.isNotEmpty ? state.user.childBirth : childBirthCtrl.text,
                        ),
                      ),
                    );
                  }
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  final isPassVisible = state is AuthSignUpInProgress ? state.isPasswordVisible : false;
                  final agreed = state is AuthSignUpInProgress ? state.agreedToTerms : false;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: 40),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text('مرحباً', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF173F7B))),
                                SizedBox(height: 4),
                                Text('يرجى إدخال البيانات لإنشاء حسابك وحساب طفلك.', style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D), height: 1.5)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                             width: 60, height: 60,
                             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                             child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset('assets/images/image-removebg-preview 1.png', fit: BoxFit.cover)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(controller: childNameCtrl, hint: 'اسم الطفل', icon: Icons.child_care_outlined),
                      const SizedBox(height: 16),
                      DatePickerField(controller: childBirthCtrl, hint: 'تاريخ ميلاد الطفل'),
                      const SizedBox(height: 16),
                      CustomTextField(controller: nameCtrl, hint: 'اسم المستخدم', icon: Icons.person_outline),
                      const SizedBox(height: 16),
                      CustomTextField(controller: emailCtrl, hint: 'البريد الإلكتروني', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
PasswordField(
                      controller: passCtrl,
                      isPasswordVisible: isPassVisible,
                      onVisibilityToggle: () {
                        context.read<AuthBloc>().add(AuthPasswordVisibilityToggled());
                      },
                    ),                      const SizedBox(height: 20),
TermsCheckbox(
  agreed: agreed,
  onChanged: (value) {
    context.read<AuthBloc>().add(AuthTermsChanged(agreedToTerms: value ?? false));
  },
),                      const SizedBox(height: 20),
                      
                      SignUpButton(
                        isLoading: state is AuthLoading,
                        agreedToTerms: agreed,
                        onPressed: () {
                          context.read<AuthBloc>().add(SignUpRequested(
                            name: nameCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            password: passCtrl.text.trim(),
                            childName: childNameCtrl.text.trim(),
                            childBirth: childBirthCtrl.text.trim(),
                            agreedToTerms: agreed,
                          ));
                          
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}