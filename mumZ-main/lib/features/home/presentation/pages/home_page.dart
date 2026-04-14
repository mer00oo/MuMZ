import 'package:flutter/material.dart';
import 'package:mamyapp/features/home/presentation/widget/custom_drawer.dart';
import 'package:mamyapp/features/home/presentation/widget/home_content.dart';
import 'package:mamyapp/features/setting/presentation/pages/settings_screen.dart';
import '../../../notifiction/presentation/pages/notifications_screen.dart';

class HomePage extends StatefulWidget {
  final String? userName;
  final String ?childName;
  final String ?childBirth;

  const HomePage({
    super.key,
    this.userName,
    this.childName,
    this.childBirth,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(
        userName: widget.userName ??'',
        childName: widget.childName ??'',
        childBirth: widget.childBirth??'',
      ),
      const SettingsScreen(),
      const NotificationsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EE),
      endDrawer: CustomDrawer(
        userName: widget.userName??'',
        selectedIndex: selectedIndex,
        onItemTap: (index) {
          setState(() {
            selectedIndex = index;
          });
          Navigator.pop(context);
        },
      ),
      body: pages[selectedIndex],
    );
  }
}



