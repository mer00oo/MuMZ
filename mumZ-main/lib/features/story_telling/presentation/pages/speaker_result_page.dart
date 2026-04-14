import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_event.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_state.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/choose_story.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/audio_player_card.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/default_button_story.dart';

class SpeakerResultPage extends StatefulWidget {
  final List<String> speakerPaths;
  final int storyId;
  final String storyText;
  final String title;

  const SpeakerResultPage({
    super.key,
    required this.speakerPaths,
    required this.storyId,
    required this.storyText, required this.title,
  });

  @override
  State<SpeakerResultPage> createState() => _SpeakerResultPageState();
}
class _SpeakerResultPageState extends State<SpeakerResultPage> {
  @override
  void initState() {
    super.initState();

    context.read<AudioBloc>().add(
      SynthesizeStoryEvent(
        text: widget.storyText,
        speakerPaths: widget.speakerPaths,
        storyId: widget.storyId,
      ),
    );
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
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        title: const Text(
          'اكتملت النسخة',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
              
              
                  Text(widget.title, 
                  style: TextStyle(
                    color: Color(0xff666666),
                    fontSize:22 ,
                    fontWeight: FontWeight.w800
                  ),),




Padding(
  padding: const EdgeInsets.only(top: 20.0,bottom: 20),
  child: Container(
    width: 361,
    height: 170,
    decoration: BoxDecoration(
      color: Color(0xffFFF8F4),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: Color(0xffFBDECD)),
  
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 4),
          blurRadius: 16
        )
      ]
  
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Text(
          textDirection: TextDirection.rtl,
          widget.storyText,
          style: TextStyle(
          
          ),
          ),
      ),
    ),
  
  
  
  ),
),



  Padding(
  padding: const EdgeInsets.only(top: 20.0,bottom: 20),
    child: Image.asset('assets/images/load.png'),
  ),


                  Padding(
  padding: const EdgeInsets.only(top: 20.0,bottom: 20),
                    child: Text('تم إنشاء القصة بصوتك', 
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:22 ,
                      fontWeight: FontWeight.w800
                    ),),
                  ),
  
  
  

       
BlocBuilder<AudioBloc, AudioState>(
  builder: (context, state) {
    if (state is AudioLoading) {
      return const CircularProgressIndicator();
    }
   if (state is AudioSuccess) {
  return AudioPlayerCard(
    audioUrl: state.audio.audioUrl,
  );
}

    if (state is AudioError) {
      return Text(state.message, style: const TextStyle(color: Colors.red));
    }
    return const SizedBox.shrink();
  },
)
,

  Padding(
  padding: const EdgeInsets.only(top: 60.0,bottom: 20),
    child: SizedBox(
      width: 361,
      height: 48,
      child: DefaultButtonStory(text: 'توليد قصة جديدة', onClick: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseStory()));
      
      }),
    ),
  )
                ]
              
                 
                        ),
            ),
        ),
      ),
    ));
  }}
