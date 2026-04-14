import 'package:flutter/material.dart';
// شيلي import البلوك من هنا خالص، مش محتاجينه

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  // 1. ضفنا متغير للكول باك (الأمر اللي هيتنفذ)
  final VoidCallback? onVisibilityToggle; 

  const PasswordField({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    this.onVisibilityToggle, // 2. نستقبله في الكونستركتور
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isPasswordVisible,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'كلمة السر',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[400],
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[400],
            ),
            // 3. هنا بننفذ الأمر اللي جاي من برا، بدل ما ننادي البلوك مباشر
            onPressed: onVisibilityToggle, 
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}