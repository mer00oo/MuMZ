import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final bool isLoading;
  final bool agreedToTerms;
  final VoidCallback onPressed;

  // ignore: use_super_parameters
  const SignUpButton({
    Key? key,
    required this.isLoading,
    required this.agreedToTerms,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                if (!agreedToTerms) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى الموافقة على الشروط والأحكام'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                onPressed();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9E8B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'متابعة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
