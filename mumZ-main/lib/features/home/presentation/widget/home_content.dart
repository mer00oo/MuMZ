// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mamyapp/core/widget/custom_child_appbar.dart';
import 'package:mamyapp/features/chatbot/presentation/pages/chatBot.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/cry_page.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/choose_story.dart';

import '../../../notifiction/presentation/pages/notifications_screen.dart';
import '../../../setting/presentation/pages/settings_screen.dart';
import '../../../todolist/all_milestones_page.dart';

class HomeContent extends StatefulWidget {
  final String userName;
  final String childName;
  final String childBirth;

  const HomeContent({
    super.key,
    required this.userName,
    required this.childName,
    required this.childBirth,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int currentIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = const [
      SizedBox(), // ✅ بدل _homePage
      NotificationsScreen(),
      SettingsScreen(),
      AllMilestonesPage(),
    ];
  }

  String _calculateAge(String birthDateString) {
    try {
      DateTime birthDate = DateTime.parse(birthDateString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return '$age سنة';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F4),
      extendBodyBehindAppBar: true,

      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: currentIndex,
          children: [_homePage(), ...pages.sublist(1)],
        ),
      ),

      // ===== Bottom Bar Animated =====
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'الرئيسية', 0),
              _navItem(Icons.notifications_rounded, 'الإشعارات', 1),
              _navItem(Icons.settings_rounded, 'الإعدادات', 2),
              _navItem(Icons.task_alt_rounded, 'To Do List', 3),
            ],
          ),
        ),
      ),
    );
  }

  // ===== NAV ITEM WITH ANIMATION =====
  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFB8C1EC).withOpacity(0.3)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF6D5D6E) : Colors.grey,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF6D5D6E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= HOME PAGE =================
  Widget _homePage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          CustomChildAppBar(
            userName: (widget.userName.isEmpty) ? 'Baby' : widget.userName,
            childBirth: widget.childBirth,
          ),

          const SizedBox(height: 20),

          // ===== GRID =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _gridCard(
                  title: '   المساعد الذكي',
                  subtitle: 'اسأل عن امور الرضاعة و التطعيمات',
                  image: 'assets/images/11 (2).png',
                  colors: const [Color(0xFFFFF7ED), Color(0xFFFFE4C7)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AiAssistantScreen(),
                      ),
                    );
                  },
                ),
                _gridCard(
                  title: 'قصص بصوتك',
                  subtitle: 'احكي قصة يومية ودع طفلك يلعب بصوتك',
                  image: 'assets/images/12 (2).png',
                  colors: const [Color(0xFFFFF0F5), Color(0xFFFFD6E0)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseStory(),
                      ),
                    );
                  },
                ),
                _gridCard(
                  title: 'تحليل البكاء',
                  subtitle: 'سجلي صوت طفلك لتحليل سبب بكائه ',
                  image: 'assets/images/13 (1).png',
                  colors: const [Color(0xFFF3F0FF), Color(0xFFE0D7FF)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CryPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ===== GRID CARD =====
  Widget _gridCard({
    required String title,
    required String subtitle,
    required String image,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔥 صورة كبيرة
              Expanded(child: Image.asset(image, fit: BoxFit.contain)),

              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
