import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mamyapp/features/chatbot/presentation/pages/chatBot.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/cry_page.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/choose_story.dart';

import '../../../notifiction/presentation/pages/notifications_screen.dart';
import '../../../setting/presentation/pages/settings_screen.dart';
import '../../../todolist/all_milestones_page.dart';
import '../../../home/presentation/widget/custom_drawer.dart';

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
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EE),
      body: IndexedStack(
        index: currentIndex,
        children: [
          _homePage(),
          const SettingsScreen(),
          const AllMilestonesPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ===== BOTTOM NAV  =====
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_rounded, 'الرئيسية', 0),
            _navItem(Icons.settings_rounded, 'الإعدادات', 1),
            _navItem(Icons.task_alt_rounded, 'المهام', 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;
    const selectedColor = Color(0xFFE8915A);

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
              ? selectedColor.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 22,
                color: isSelected ? selectedColor : Colors.grey.shade400),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: selectedColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _homePage() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 20),
                  _buildGreetingSection(),
                  const SizedBox(height: 16),
                  _buildLargeFeatureCard(
                    title: 'حللي بكاء طفلك',
                    subtitle: 'سجلي صوت طفلك لتحديد سبب بكائه فوراً',
                    image: 'assets/images/3 (2).png',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CryPage()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallFeatureCard(
                          title: 'قصص بصوتك',
                          subtitle: 'اختاري قصة ودعي\nطفلك يقرأها بصوتك',
                          image: 'assets/images/image (2).png',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ChooseStory()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSmallFeatureCard(
                          title: 'المساعد الذكي',
                          subtitle: 'اسأل عن أمور\nالرضاعة والتطعيمات',
                          image: 'assets/images/image 1 (2).png',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AiAssistantScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===== HEADER  =====
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE8915A),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu icon
              Icon(Icons.menu_rounded,
                  color: Colors.white.withOpacity(0.9), size: 26),

              // Title
              const Text(
                'الصفحة الرئيسية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),

              // Bell → Navigator.push للإشعارات
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          backgroundColor: const Color(0xFFE8915A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          title: const Text(
                            'الإشعارات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          centerTitle: true,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        body: const NotificationsScreen(),
                      ),
                    ),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.notifications_outlined,
                        color: Colors.white.withOpacity(0.9), size: 26),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE8915A),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== GREETING SECTION =====
  Widget _buildGreetingSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFDE8D8),
              border: Border.all(
                color: const Color(0xFFE8915A).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/qqq.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.child_care_rounded,
                  size: 32,
                  color: Color(0xFFE8915A),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'اهلا ${widget.userName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.childName,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                'عمر الطفل: ${_calculateAge(widget.childBirth)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== LARGE FEATURE CARD =====
  Widget _buildLargeFeatureCard({
    required String title,
    required String subtitle,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.child_care,
                  size: 60,
                  color: Color(0xFFE8915A),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      fontFamily: 'Cairo',
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
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== SMALL FEATURE CARD =====
  Widget _buildSmallFeatureCard({
    required String title,
    required String subtitle,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.auto_stories,
                    size: 50,
                    color: Color(0xFFE8915A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                height: 1.4,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
