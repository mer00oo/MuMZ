import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/speaker/speaker_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/speaker/speaker_state.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/speaker_result_page.dart';

class VoiceProcessingSpeakerScreen extends StatelessWidget {
    final int storyId;
  final String storyText;
  final String title;

  const VoiceProcessingSpeakerScreen({super.key, required this.storyId, required this.storyText, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpeakerBloc, SpeakerState>(
      listener: (context, state) {
        if (kDebugMode) {
          print('🎬 VoiceProcessingPage - State: ${state.runtimeType}');
        }

        if (state is SpeakerUploadSuccess) {
          if (kDebugMode) {
            print('✅ Success! Paths: ${state.speakerPaths}');
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: context.read<SpeakerBloc>(),
                    child: SpeakerResultPage(
                      title:title ,
                      storyId:  storyId,
                      storyText: storyText,
                      
                      
                      speakerPaths: state.speakerPaths),
                  ),
            ),
          );
        } else if (state is SpeakerUploadError) {
          if (kDebugMode) {
            print(' Error: ${state.message}');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ: ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF5F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFD4BA),
          elevation: 0,
          automaticallyImplyLeading: false, // نخفي زرار الرجوع
          title: const Text(
            'انشاء النسخة',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFFB399),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/images/load.png'),
                ),
                const SizedBox(height: 30),
                const Text(
                  'يتم إنشاء النسخة بالصوت الشخصي',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFB399),
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFB399),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
