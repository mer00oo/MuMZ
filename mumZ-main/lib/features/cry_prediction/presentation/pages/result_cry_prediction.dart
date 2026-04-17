import 'package:flutter/material.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/cry_page.dart';

class ResultCryPrediction extends StatelessWidget {
  final String prediction;
  final String recommendation;
  final double confidence;

  const ResultCryPrediction({
    super.key,
    required this.prediction,
    required this.recommendation,
    required this.confidence,
  });

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
              padding: EdgeInsets.only(top: 200.0, bottom: 30),
              child: Text(
                'نتيجة التحليل',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff4A4A4A),
                ),
              ),
            ),
            Container(
              width: 343,
              decoration: BoxDecoration(
                color: const Color(0xffFFF8F4),
                border: Border.all(color: const Color(0xffFBDECD)),
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'سبب البكاء: $prediction',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recommendation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'نسبة الدقة: ${(confidence * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE8915A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
              child: GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CryPage()),
                  (route) => false,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8915A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'اعادة المحاولة',
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