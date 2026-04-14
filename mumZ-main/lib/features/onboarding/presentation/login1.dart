import 'package:flutter/material.dart';
import 'package:mamyapp/core/theme/app_colors.dart';
import 'package:mamyapp/features/auth/presentation/pages/log_in.dart';
import 'package:mamyapp/features/auth/presentation/pages/sign_up.dart';


void main() {
  runApp(const BabyCareApp());
}

class BabyCareApp extends StatelessWidget {
  const BabyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Almarai',
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Widget _buildImagePlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/image-removebg-preview 1.png',
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required String text,
        required VoidCallback onPressed,
        required Color color,
      }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          // ignore: deprecated_member_use
          shadowColor: color.withOpacity(0.5),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                _buildImagePlaceholder(),

                const SizedBox(height: 30),

                const Text(
                  "أهلاً بك في",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                  textDirection: TextDirection.rtl,
                ),

                const SizedBox(height: 5),

                const Text(
                  "Baby Care",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkBlue,
                  ),
                ),

                const SizedBox(height: 80),

                _buildActionButton(
                  context,
                  text: "تسجيل الدخول",
                  color: AppColors.loginButtonColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  Login(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                _buildActionButton(
                  context,
                  text: "إنشاء حساب",
                  color: AppColors.createAccountButtonColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) =>  SignUpPage(),
                    ),
                    );
                  },
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}