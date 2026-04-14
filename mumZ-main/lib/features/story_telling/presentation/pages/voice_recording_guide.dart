// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'voice_recording_speaker_page.dart';

class VoiceGuideScreen extends StatelessWidget {
    final int storyId;
  final String storyText;
    final String title;

  // ignore: use_super_parameters
  const VoiceGuideScreen({Key? key, required this.storyId, required this.storyText, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFDAB9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5D4E37)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'إرشادات التسجيل والتحويل الصوتي',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4E37),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Title Text
              const Text(
                'قبل ما تبدأي في إنشاء نسخة صوتك، التزمي\nبالإرشادات التالية للحصول على أفضل نتيجة:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              // Sound Wave Illustration
              Container(
                width: double.infinity,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomPaint(
                  painter: LargeSoundWavePainter(),
                ),
              ),

              const SizedBox(height: 30),

              // Guidelines List
              const GuidelineItem(
                text: ' اقرئي الجمل المطلوبة بالترتيب.',
              ),
              const SizedBox(height: 12),

              const GuidelineItem(
                text: 'سجّلي كل جملة بدون استعجال',
              ),
              const SizedBox(height: 12),

              const GuidelineItem(
                text: 'اختاري مكان هادئ بدون ضوضاء.',
              ),
              const SizedBox(height: 12),

              const GuidelineItem(
                text: ' استخدمي نبرة صوت طبيعية وواضحة.',
              ),
              const SizedBox(height: 12),

              const GuidelineItem(
                text: 'من المهم تسجيل على الأقل 20 مقطع',
              ),

              const SizedBox(height: 40),

              // Start Button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFDAB9),
                      Color(0xFFFFB08A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB08A).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  VoiceRecordingPage(
                          title: title,
                                storyId: storyId,
        storyText: storyText,
                        ),
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'ابدأي الآن',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Guideline Item Widget
class GuidelineItem extends StatelessWidget {
  final String text;

  const GuidelineItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.check,
          color: Color(0xFFFFB08A),
          size: 20,
        ),
      ],
    );
  }
}

// Large Sound Wave Painter
class LargeSoundWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB08A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barCount = 60;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;

      // Create wave pattern
      double heightFactor;
      final normalizedPos = (i / barCount);

      // Create a wave shape
      if (normalizedPos < 0.2 || normalizedPos > 0.8) {
        heightFactor = 0.2;
      } else if (normalizedPos >= 0.45 && normalizedPos <= 0.55) {
        heightFactor = 1.0;
      } else if (normalizedPos >= 0.4 && normalizedPos <= 0.6) {
        heightFactor = 0.85;
      } else if (normalizedPos >= 0.35 && normalizedPos <= 0.65) {
        heightFactor = 0.7;
      } else if (normalizedPos >= 0.3 && normalizedPos <= 0.7) {
        heightFactor = 0.55;
      } else {
        heightFactor = 0.35;
      }

      final barHeight = size.height * heightFactor * 0.9;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}