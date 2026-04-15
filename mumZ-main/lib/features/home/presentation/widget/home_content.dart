import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F0F8),
      body: IndexedStack(
        index: currentIndex,
        children: [
          _homePage(),
          ...pages.sublist(1),
        ],
      ),
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
              ? const Color(0xFFE8915A).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon,
                color:
                isSelected ? const Color(0xFFE8915A) : Colors.grey),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                    color: Color(0xFFE8915A),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
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
          // ===== HERO HEADER  =====
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7B3FA0),
                  Color(0xFFeee0fb),

                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  left: -40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 60,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).padding.top + 16,
                    20,
                    0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 160,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.asset(
                                  'assets/images/qqq.png',
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // بيانات المستخدم
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userName,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'العمر: ${_calculateAge(widget.childBirth)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      Colors.white.withOpacity(0.85),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.childName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                      Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 7),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.white.withOpacity(0.2),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white
                                            .withOpacity(0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'الملف الشخصي',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.sync_alt_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===== WHITE ROUNDED SECTION  =====
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
                  image: 'assets/images/image 1 (2).png',
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
                  image: 'assets/images/image (2).png',
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
                  image: 'assets/images/3 (2).png',
                  accentColor: const Color(0xFF7B3FA0),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CryPage()),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== FEATURE CARD  =====
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: accentColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'انطلق',
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              SizedBox(
                width: 90,
                height: 90,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}