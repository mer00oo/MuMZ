import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool agreed;
  final ValueChanged<bool?>? onChanged;

  const TermsCheckbox({super.key, required this.agreed, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: agreed,
          onChanged: onChanged,
          activeColor: const Color(0xFF173F7B),
        ),
        const Expanded(child: Text('أوافق على شروط الخدمة وسياسة الخصوصية المعمول بها BabyCare الخاصة', style: TextStyle(fontSize: 12))),
      ],
    );
  }
}