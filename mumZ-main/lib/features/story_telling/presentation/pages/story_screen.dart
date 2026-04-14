import 'package:flutter/material.dart';
import 'package:mamyapp/features/story_telling/data/repositories/story_repository_impl.dart';
import 'package:mamyapp/features/story_telling/domain/use_cases/get_story_by_id.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/voice_cloning.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/default_button_story.dart';

class StoryScreen extends StatelessWidget {
    final int storyId;
       final String title;

  const StoryScreen({super.key, required this.storyId, required this.title});

  @override
  Widget build(BuildContext context) {
    final story = GetStoryById(StoryRepositoryImpl()).call(storyId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD4BA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'اختاري القصة',
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

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                
                decoration: BoxDecoration(
                  color: const Color(0xffFFF8F4),
                  border: Border.all(color: const Color(0xffFBDECD)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 16,
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        story.title,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        story.content,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: DefaultButtonStory(text: 'بدء تسجيل القصة', onClick: (){

                Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceCloningScreen(
                  title: title,
                  
            storyId: storyId, 
            storyText: story.content, 
        
                ),));
              })
            ),
          ],
        ),
      ),
    );
  }
}
