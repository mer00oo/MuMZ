import 'package:flutter/material.dart';

class CryLoadingScreen extends StatelessWidget {
  const CryLoadingScreen({super.key});

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
            Image.asset('assets/images/image_cry.png'),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 60.0,
              ),
              child: Text(
                'يتم تحليل صوت الطفل',
                style: TextStyle(
                  color: Color(0xff4A4A4A),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
