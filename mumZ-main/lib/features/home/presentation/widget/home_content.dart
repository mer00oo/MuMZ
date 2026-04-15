// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
      SizedBox(),
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
    // ✅ خلي status bar شفاف عشان الـ gradient يوصل للأعلى
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,

      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: currentIndex,
          children: [
            _homePage(),
            ...pages.sublist(1),
          ],
        ),
      ),


      // ===== Bottom Bar Animated =====
      bottomNavigationBar: Container(
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
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFB8C1EC).withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF6D5D6E)
                  : Colors.grey,
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
            ]
          ],
        ),
      ),
    );
  }

  Widget _homePage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF1E6),
                  Color(0xFFFFE0D2),
                  Color(0xFFFFD6C2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                28,
              ),
              child: Column(
                children: [
                  const Text(
                    'أهلاً 👋',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/images/image (2).png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D5D6E),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'العمر: ${_calculateAge(widget.childBirth)}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ===== WHITE ROUNDED SECTION - زي الصورة =====
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F0F8),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ===== كارت المساعد الذكي =====
                _featureCard(
                  title: 'المساعد الذكي',
                  subtitle: 'اسأل عن أمور الرضاعة والتطعيمات',
                  image: 'assets/images/11 (2).png',
                  accentColor: const Color(0xFF7B3FA0),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AiAssistantScreen()),
                  ),
                ),

                const SizedBox(height: 14),

                // ===== كارت قصص =====
                _featureCard(
                  title: 'قصص بصوتك',
                  subtitle: 'احكي قصة يومية ودع طفلك يلعب بصوتك',
                  image: 'assets/images/12 (2).png',
                  accentColor: const Color(0xFF7B3FA0),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChooseStory()),
                  ),
                ),

                const SizedBox(height: 14),

                // ===== كارت تحليل البكاء =====
                _featureCard(
                  title: 'تحليل البكاء',
                  subtitle: 'سجلي صوت طفلك لتحليل سبب بكائه',
                  image: 'assets/images/13 (1).png',
                  colors: const [Color(0xFFF3F0FF), Color(0xFFE0D7FF)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CryPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== FEATURE CARD - زي الصورة بالظبط =====
  Widget _featureCard({
    required String title,
    required String subtitle,
    required String image,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 🔥 صورة كبيرة
              Expanded(
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),

              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
