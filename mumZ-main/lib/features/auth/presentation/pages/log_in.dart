// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/core/di/injection_container.dart' as di;
import 'package:mamyapp/core/theme/app_colors.dart';
import 'package:mamyapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mamyapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:mamyapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:mamyapp/features/auth/presentation/pages/reset%20_password.dart';
import 'package:mamyapp/features/auth/presentation/pages/sign_up.dart';
import 'package:mamyapp/features/home/presentation/pages/home_page.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightBeige,
          appBar: AppBar(
            backgroundColor: AppColors.lightBeige,
            elevation: 0,
            title: const Text(
              'تسجيل دخول',
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.darkBlue,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          userName: state.user.name,
                          childName: state.user.childName,
                          childBirth: state.user.childBirth,
                        ),
                      ),
                    );
                  }
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  // بنجيب حالة الباسورد من الـ BLoC
                  // لو هو في حالة SignUpInProgress بناخد القيمة، غير كده بنفترض إنه مخفي
                  final isObscure = state is AuthSignUpInProgress 
                      ? !state.isPasswordVisible // لاحظي العكس هنا عشان اللوجيك
                      : true; 

                  return Column(
                    children: [
                      const SizedBox(height: 20),

                      // --- 1. Header Section ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/image-removebg-preview 1.png',
                            height: 60,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'مرحباً بك',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'يرجى إدخال بريدك الإلكتروني وكلمة المرور للدخول إلى حسابك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // --- 2. Input Fields ---
                      LoginTextField(
                        controller: emailCtrl,
                        hintText: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 20),

                      LoginTextField(
                        controller: passwordCtrl,
                        hintText: 'كلمة السر',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isObscure: isObscure,
                        onVisibilityToggle: () {
                          context.read<AuthBloc>().add(AuthPasswordVisibilityToggled());
                        },
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: AppColors.loginButtonColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(
                                        LoginRequested(
                                          email: emailCtrl.text.trim(),
                                          password: passwordCtrl.text.trim(),
                                        ),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.loginButtonColor,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: AppColors.loginButtonColor.withOpacity(0.5),
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'متابعة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'انشئ حساب',
                              style: TextStyle(
                                color: AppColors.loginButtonColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            'ليس لديك حساب؟',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
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

// ==========================================================
// Widget مفصول للحقل عشان الكود يكون نظيف ونعيد استخدامه
// بنفس الـ UI اللي انتي عملاه (BoxShadow, BorderRadius, Colors)
// ==========================================================
class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onVisibilityToggle;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.isObscure = false,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && isObscure,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 15,
          ),
          suffixIcon: Icon(icon, color: Colors.grey[400]),
          prefixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[400],
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}