import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/cry_loading_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mamyapp/services/audio_recorder_service.dart';

class RecordCryBaby extends StatefulWidget {
  const RecordCryBaby({super.key});

  @override
  State<RecordCryBaby> createState() => _RecordCryBabyState();
}

class _RecordCryBabyState extends State<RecordCryBaby> {

  final AudioRecorderService _recorderService = AudioRecorderService();

  bool _isRecording = false;
  String? _recordedFile;

  /// start recording
  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();

    final path =
        '${directory.path}/cry_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorderService.startRecording(path);

    setState(() {
      _isRecording = true;
    });
  }

  /// stop recording
  Future<void> _stopRecording() async {
    final path = await _recorderService.stopRecording();

    if (path != null) {
      setState(() {
        _isRecording = false;
        _recordedFile = path; // حفظ التسجيل
      });

      print("record saved : $path");
    }
  }

  /// toggle recording
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  void _sendRecording() {

    if (_recordedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("لم يتم تسجيل أي صوت بعد"),
        ),
      );
      return;
    }

    File file = File(_recordedFile!);

    print("Saved file path: ${file.path}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم حفظ التسجيل بنجاح"),
      ),
    );
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CryLoadingScreen(),
    ),
  );

  }

  /// reset recording
  void _resetRecording() {
    setState(() {
      _recordedFile = null;
      _isRecording = false;
    });
  }

  @override
  void dispose() {
    _recorderService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD4BA),
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

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            'assets/images/image_cry.png',
            height: 322,
          ),

          const SizedBox(height: 10),

          const Text(
            "ابدأي التسجيل",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          /// زر التسجيل
          GestureDetector(
            onTap: _toggleRecording,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording
                    ? Colors.red
                    : const Color(0xFFFFB399),
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording
                            ? Colors.red
                            : const Color(0xFFFFB399))
                        .withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(
                _isRecording
                    ? Icons.stop_rounded
                    : Icons.mic_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _sendRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD4BA),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "ارسال التسجيل",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              ElevatedButton(
                onPressed: _resetRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB399),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "اعادة التسجيل",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}