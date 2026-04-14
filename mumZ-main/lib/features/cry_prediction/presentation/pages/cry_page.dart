import 'package:flutter/material.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/record_cry_baby.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/default_button_story.dart';

class CryPage extends StatelessWidget {
  const CryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),      body: Center(
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              child: Text('سجّلي صوت بكاء طفلك ليحلله الذكاء الاصطناعي',
              style: TextStyle(
                color: Color(0xff4A4A4A),
                fontWeight: FontWeight.w700,
                fontSize: 16
              ),),

            ),

            Image.asset('assets/images/image_cry.png'),

     Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
       child: DefaultButtonStory(
        
        text: 'ابدئي التسجيل', onClick: (){
        Navigator.push(context, MaterialPageRoute(builder:(context) => const  RecordCryBaby()));
       
       }),
     )

        
          ],
        ),
      ),
    );
  }
}