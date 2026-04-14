import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/story_telling/data/local/db_helper.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/speaker/speaker_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/speaker/speaker_event.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/voice_processing_speaker_screen.dart';
import 'package:mamyapp/services/audio_recorder_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class VoiceRecordingPage extends StatefulWidget {
  final int storyId;
  final String storyText; 
  final String title;
   const VoiceRecordingPage({super.key, required this.storyId, required this.storyText, required this.title});

  @override
  State<VoiceRecordingPage> createState() => _VoiceRecordingPageState();
}

class _VoiceRecordingPageState extends State<VoiceRecordingPage> {
  final AudioRecorderService _recorderService = AudioRecorderService();
  bool _isRecording = false;
  int _currentSentence = 0;
  final int _totalSentences = 20;
  final List<String> _recordedFiles = [];

  final List<String> _sentences = [
    "مرحباً، كيف حالك اليوم؟",
    "الطقس جميل في هذا الوقت من السنة",
    "أحب قراءة الكتب في أوقات فراغي",
    "السفر يوسع المدارك ويثري التجربة",
    "التعليم هو مفتاح النجاح في الحياة",
    "الرياضة مهمة للحفاظ على الصحة",
    "الأسرة هي الأساس في المجتمع",
    "العمل الجاد يؤدي إلى النجاح",
    "الصداقة كنز لا يقدر بثمن",
    "الصبر مفتاح الفرج",
    "العلم نور والجهل ظلام",
    "الوقت كالسيف إن لم تقطعه قطعك",
    "من جد وجد ومن زرع حصد",
    "الأمل هو ما يبقينا أقوياء",
    "التفاؤل يجعل الحياة أجمل",
    "الإبداع يبدأ من التفكير خارج الصندوق",
    "المثابرة طريق النجاح",
    "الاحترام أساس العلاقات الناجحة",
    "التواضع من أجمل الصفات",
    "الحياة رحلة جميلة مليئة بالمفاجآت",
  ];

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى السماح بالوصول إلى الميكروفون')),
      );
    }
  }

  Future<void> _startRecording() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorderService.startRecording(path);
      setState(() => _isRecording = true);
      if (kDebugMode) print('🎤 Recording started: $path');
    } catch (e) {
      if (kDebugMode) print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorderService.stopRecording();
      if (path != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        final file = File(path);
        if (!await file.exists()) return;

        await RecordingDatabase.instance.insertRecording(path);

        setState(() {
          _isRecording = false;
          _recordedFiles.add(path);
        });

        if (kDebugMode) print('✅ Recording saved: $path');
      }
    } catch (e) {
      if (kDebugMode) print('Error stopping recording: $e');
      setState(() => _isRecording = false);
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      if (_currentSentence < _totalSentences) {
        await _startRecording();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لقد انتهيت من تسجيل جميع الجمل')),
        );
      }
    }
  }

  void _onNextOrGenerate() {
    if (_currentSentence < _totalSentences) {
      setState(() => _currentSentence++);
    } else {
      if (_recordedFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد تسجيلات للرفع')),
        );
        return;
      }

      context.read<SpeakerBloc>().add(
            UploadSpeakersEvent(filePaths: _recordedFiles),
          );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  VoiceProcessingSpeakerScreen(


title: widget.title ,
            storyId: widget.storyId,
            storyText: widget.storyText,
            
          ),
        ),
      );
    }
  }

  void _resetRecording() {
    if (_isRecording) _stopRecording();
    setState(() {
      _recordedFiles.clear();
      _currentSentence = 0;
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
      backgroundColor: const Color(0xFFFFF5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD4BA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'برنامج تدريب الصوت',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'اقرأي الجمل التالية بصوت واضح.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'سيتم حفظ كل جملة في مقطع صوت منفصل',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8B7265),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'الجملة ${_currentSentence == 0 ? 'الأولى' : (_currentSentence + 1).toString()}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF8B7265),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(
                      color: Color(0xFFE0E0E0),
                      thickness: 1,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentSentence < _totalSentences
                          ? _sentences[_currentSentence]
                          : 'تم الانتهاء من جميع الجمل ',
                      style: TextStyle(
                        fontSize: 16,
                        color: _currentSentence < _totalSentences
                            ? Colors.black87
                            : const Color(0xFF4CAF50),
                        height: 1.6,
                        fontWeight: _currentSentence >= _totalSentences
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Text(
                _currentSentence == 0
                    ? 'لم يتم تسجيل أي مقطع بعد'
                    : 'تم تسجيل ${_recordedFiles.length} من $_totalSentences مقطع',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'ابدأ في التسجيل',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording
                        ? Colors.red.withOpacity(0.8)
                        : const Color(0xFFFFB399),
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording
                                ? Colors.red
                                : const Color(0xFFFFB399))
                            .withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: _onNextOrGenerate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB399),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentSentence < _totalSentences
                              ? 'المقطع التالي'
                              : 'ابدأ التوليد',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        onPressed: _resetRecording,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD4BA),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _isRecording ? 'إيقاف التسجيل' : 'إعادة التسجيل',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
