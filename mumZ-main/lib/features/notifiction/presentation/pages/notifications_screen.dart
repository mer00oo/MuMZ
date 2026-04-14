import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFDAB9), Color(0xFFFFCBA4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'الاشعارات',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4E37), // ✅ نفس لون نص الهوم
          ),
        ),
      ),
    );
  }
}
