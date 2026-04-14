import 'package:flutter/material.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/story_screen.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/choose_story_card.dart';

class ChooseStory extends StatelessWidget {
  const ChooseStory({super.key});

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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 37, bottom: 37),
              child: Text(
                'قصص قصيرة وهادئة لنوم طفلك',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff4A4A4A),
                ),
              ),
            ),

            ChooseStoryCard(
              title: " رِحْلَةُ تُوتُو البَطِيء",
              description: 'قصة هادئة عن رِحْلَةُ تُوتُو البَطِيء',
              textButton: 'بدءالقصة',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StoryScreen(storyId: 1,      title: '🐢 رِحْلَةُ تُوتُو البَطِيء – قِصَّةٌ قَبْلَ النَّوْم',
),
                  ),
                );
              },
            ),
            SizedBox(height: 26),



            
            ChooseStoryCard(
              title: " لُولُو الحُوتُ الصَّغِير  ",
              description: 'قصة هادئة عن لُولُو الحُوتُ الصَّغِير',
              textButton: 'بدءالقصة',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StoryScreen(storyId: 2,           title: '🐋 لُولُو الحُوتُ الصَّغِير الَّذِي يَخَافُ مِنَ الأَعْمَاق',

),
                  ),
                );
              },
            ),

                        SizedBox(height: 26),

            ChooseStoryCard(
              title: "مُغَامَرَاتُ السَّلْحَفَاةِ تُوبِي",
              description: 'قصة مُغَامَرَاتُ السَّلْحَفَاةِ تُوبِي.',
              textButton: 'بدءالقصة',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StoryScreen(storyId: 3,       title: '🐢 مُغَامَرَاتُ السَّلْحَفَاةِ تُوبِي',
),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
