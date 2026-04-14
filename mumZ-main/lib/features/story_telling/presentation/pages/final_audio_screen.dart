import 'package:flutter/material.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/choose_story.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/audio_player_card.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/default_button_story.dart';

class FinalAudioScreen extends StatelessWidget {
  final int storyId;
  final String storyText;
  final String audioUrl;
     final String title;
 

  const FinalAudioScreen({
    super.key,
    required this.storyId,
    required this.storyText,
    required this.audioUrl, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD4BA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
        'انشاء القصة',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800,color: Color(0xff666666)),
              ),
              const SizedBox(height: 20),
             Container(
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
            storyText,
            style: TextStyle(
            
            ),
            ),
        ),
            ),
          
          
        
          
          ),
        
              const SizedBox(height: 20),
        
          Image.asset('assets/images/headphone.png'),
              const SizedBox(height: 20),
        
               Text(
                'تم إنشاء القصة بالصوت الافتراضي',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800,color: Color(0xff666666)),
              ),
                          const SizedBox(height: 20),
        
              AudioPlayerCard(audioUrl: audioUrl),
        
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  width: 260,
                  height:56 ,
                  child: DefaultButtonStory(text: 'توليد قصة جديدة', onClick: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseStory(),));
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



