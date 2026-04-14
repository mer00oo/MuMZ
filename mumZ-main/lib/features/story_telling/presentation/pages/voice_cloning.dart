// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/virtual_Voice_preview_screen.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/voice_recording_guide.dart';

class VoiceCloningScreen extends StatefulWidget {
  final int storyId;
  final String storyText;
    final String title;

  const VoiceCloningScreen({super.key, required this.storyId, required this.storyText, required this.title});

  @override
  State<VoiceCloningScreen> createState() => _VoiceCloningScreenState();
}

class _VoiceCloningScreenState extends State<VoiceCloningScreen> {
  bool isRecording = false;

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
          'اختاري نوع الصوت للقصص',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4E37),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF5D4E37)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Headphones Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/headphone.png', // استخدمي أيقونة السماعات
                    width: 70,
                    height: 70,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.headphones,
                        size: 70,
                        color: Color(0xFFFFB08A),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Description Text
              const Text(
                'استخدمي صوتنا متاحاً لسرد القصص',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 25),

              // Default Voice Button
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
                

                    Navigator.push(context, MaterialPageRoute(builder: (context) => VirtualVoicePreviewScreen(
                      title: widget.title,
                      storyId: widget.storyId,
        storyText: widget.storyText,
                    ),));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'الصوت الافتراضي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Microphone with Sound Wave
              Stack(
                alignment: Alignment.center,
                children: [
                  // Sound wave background
                  Container(
                    width: 180,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: const Size(140, 60),
                        painter: SoundWavePainter(isActive: isRecording),
                      ),
                    ),
                  ),
                  // Microphone icon
                  Positioned(
                    right: 15,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB08A),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB08A).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Instruction Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'أنشئي نسخة من صوتك لسرد القصص لطفلتك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Upload Voice Button
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
                        builder: (context) => VoiceGuideScreen(
                          title: widget.title,
                          storyId: widget.storyId,
        storyText: widget.storyText,
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
                    'تقليد صوتك',
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

// Custom Painter for Sound Wave
class SoundWavePainter extends CustomPainter {
  final bool isActive;

  SoundWavePainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB08A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barCount = 25;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;

      // Create varying heights for wave effect
      double heightFactor;
      if (i < 8 || i > 17) {
        heightFactor = 0.2;
      } else if (i == 12 || i == 13) {
        heightFactor = 1.0;
      } else if (i == 11 || i == 14) {
        heightFactor = 0.8;
      } else if (i == 10 || i == 15) {
        heightFactor = 0.6;
      } else {
        heightFactor = 0.4;
      }

      final barHeight = size.height * heightFactor * 0.8;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}