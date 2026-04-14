import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_event.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_state.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/final_audio_screen.dart';

class VoiceProcessingScreen extends StatefulWidget {
  final int storyId;
  final String storyText;
    final String title;


  const VoiceProcessingScreen({super.key, required this.storyId, required this.storyText, required this.title});

  @override
  State<VoiceProcessingScreen> createState() => _VoiceProcessingScreenState();
}

class _VoiceProcessingScreenState extends State<VoiceProcessingScreen> {

  @override
  void initState() {
    super.initState();

    context.read<AudioBloc>().add(
      SynthesizeStoryEvent(
        text: widget.storyText,
              storyId: widget.storyId,

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AudioBloc, AudioState>(
         listener: (context, state) {
  if (state is AudioSuccess) {
    if(state.audio.audioUrl.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الـ audio_url فارغ، حاول مرة أخرى"))
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FinalAudioScreen(
          title: widget.title,
          storyId: widget.storyId,
          audioUrl: state.audio.audioUrl,
          storyText: widget.storyText,
        ),
      ),
    );
  }
},
          builder: (context, state) {
            if (state is AudioLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [

                  Image.asset('assets/images/headphone.png'),
                  SizedBox(height: 20),

                                    Text('يتم إنشاء القصة بالصوت الافتراضي',
                                    style:TextStyle(color: Color(0xff666666), fontSize: 22,fontWeight: FontWeight.w800),
                                    )
,                  SizedBox(height: 20),

                  CircularProgressIndicator(
                    color: Color(0xffFF9E8B),

                  ),
                  SizedBox(height: 20),
                ],
              );
            }

            if (state is AudioError) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
