import 'package:flutter/material.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/cry_page.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/default_button_story.dart';

class ResultCryPrediction extends StatelessWidget {
  const ResultCryPrediction({super.key});

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
      ),

      body: Center(
        child: Column(
          children: [
             Padding(
               padding: const EdgeInsets.only(top: 200.0,bottom: 30),
               child: Text('نتيجة التحليل',
               style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xff4A4A4A)
               ),
                
               ),
             ),


             Container(
              width: 343,
              height: 172,
              decoration: BoxDecoration(
                color: Color(0xffFFF8F4),
                border: Border.all(color: Color(0xffFBDECD)),
                borderRadius: BorderRadius.circular(40)

              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text('سبب البكاء: الجوع',style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text('قد يكون طفلك جائعًا. جرّبي تقديم الرضاعة أو وجبة خفيفة.',style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff666666)
                  ),),
                )
              ],),
             ),

             Padding(
               padding: const EdgeInsets.only(top: 120.0,left: 20,right: 20),

               child: DefaultButtonStory(text: 'اعادة المحاولة', onClick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CryPage()));
               }),
             )
          ],
        ),
      ),
      
      
          );
  }
}