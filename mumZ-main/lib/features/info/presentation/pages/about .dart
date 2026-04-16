// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mamyapp/features/info/presentation/widget/info_section.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7FC),

        appBar: AppBar(
          backgroundColor: const Color(0xFFE8915A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFFFFFFF)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'حول التطبيق',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.info_outline,
                        size: 40, color: Color(0xFFE89B88)),
                    SizedBox(height: 10),
                    Text(
                      'معلومات عن التطبيق',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'تطبيق ذكي يساعد الأمهات في فهم أطفالهن بسهولة وأمان',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              InfoSection(
                number: '١',
                title: 'Mum Z Baby Care',
                items: const [
                  'تطبيق ذكي يساعد الأمهات في فهم أطفالهن بشكل أسهل.',
                  'تحليل بكاء الطفل باستخدام الذكاء الاصطناعي.',
                  'مكتبة قصص وسجل التحليلات.',
                  'مساعد ذكي للإجابة عن الأسئلة اليومية.',
                  'إنشاء قصص صوتية مخصّصة بصوت الأم.',
                  'يهدف التطبيق إلى دعم الأمومة بشكل آمن وموثوق.',
                ],
              ),

              InfoSection(
                number: '٢',
                title: 'إصدار التطبيق',
                items: const [
                  'الإصدار: 1.0.0',
                ],
              ),

              InfoSection(
                number: '٣',
                title: 'تواصل معنا',
                items: const [
                  'Email: example@email.com',
                  'Facebook: MumZBabyCare',
                  'Instagram: @MumZBabyCare',
                ],
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}