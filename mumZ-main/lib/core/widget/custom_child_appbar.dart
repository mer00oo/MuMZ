import 'package:flutter/material.dart';

class CustomChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String childBirth;

  const CustomChildAppBar({
    super.key,
    required this.userName,
    required this.childBirth,
  });

  String _calculateAge(String birthDate) {
    // منطق حساب العمر هنا
    return birthDate; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFF1E6),
            Color(0xFFFFE0D2),
            Color(0xFFFFD6C2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea( // لضمان عدم تداخل المحتوى مع شريط الحالة (Status Bar)
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end, // محاذاة النص للأيمن
            children: [
              const Text(
                'مرحباً بك',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D5D6E), // تم تغيير اللون ليكون واضحاً على الخلفية الفاتحة
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textDirection: TextDirection.rtl, // لضمان ترتيب العناصر من اليمين لليسار
                children: [
                  // الصورة
                  Container(
                    width: 120, // تم تصغير الحجم قليلاً ليتناسب مع الـ AppBar
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/images/image (2).png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // البيانات
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D5D6E),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'العمر: ${_calculateAge(childBirth)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8E7D8E),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // تحديد الارتفاع المطلوب للـ AppBar
  Size get preferredSize => const Size.fromHeight(250); 
}