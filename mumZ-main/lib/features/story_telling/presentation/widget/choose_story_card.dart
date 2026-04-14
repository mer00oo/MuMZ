import 'package:flutter/material.dart';
import 'package:mamyapp/features/story_telling/presentation/widget/default_button_story.dart';

class ChooseStoryCard extends StatelessWidget {

  final String title ;
  final String description;
  final String textButton;
  final VoidCallback onClick; 
  const ChooseStoryCard({super.key, required this.title, required this.description, required this.textButton, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return  Container(
              width: 319,
              height: 169,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 3, color: Color(0xffFFDBC8)),

                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),

                    blurRadius: 10.7,
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.15),
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                  
                      Text(
                        description,
                        style: TextStyle(
                          color: Color(0xff7B7A7A),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                  
                      SizedBox(
                        width:221 ,
                        height:42 ,
                  
                  
                        child: DefaultButtonStory(text: textButton, onClick: onClick),
                      ),
                    ],
                  ),
                ),
              ),
            );

  }
}