import 'package:flutter/material.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/record_cry_baby.dart';

class CryPage extends StatelessWidget {
  const CryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8915A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تحليل سبب بكاء طفلك',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60.0),
              child: Text(
                'سجّلي صوت بكاء طفلك ليحلله الذكاء الاصطناعي',
                style: TextStyle(
                  color: Color(0xff4A4A4A),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            Image.asset('assets/images/image_cry.png'),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),

              // ✅ التعديل هنا فقط
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecordCryBaby(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8915A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE8915A).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'ابدئي التسجيل',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}