import 'package:flutter/material.dart';
import 'package:mamyapp/features/auth/presentation/pages/baby_account_page.dart';
import 'package:mamyapp/features/home/presentation/widget/drower_item.dart';
import 'package:mamyapp/features/info/presentation/pages/about%20.dart';
import 'package:mamyapp/features/info/presentation/pages/asked.dart';
import 'package:mamyapp/features/info/presentation/pages/contact_page.dart';
import 'package:mamyapp/features/info/presentation/pages/privacy_policy_page.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final int selectedIndex;
  final Function(int) onItemTap;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header with user info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8915A), Color(0xFFE8915A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/aa.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  'مرحبا بكٍ $userName',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4E37),
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerSection(
                  'الرئيسية',
                  [
                    DrawerItem(
                      icon: Icons.home,
                      title: 'الصفحة الرئيسية',
                      isSelected: selectedIndex == 0,
                      onTap: () => onItemTap(0),
                    ),
                  ],
                ),
                const Divider(height: 1),
                _buildDrawerSection(
                  'حساب الطفل',
                  [
                    DrawerItem(
                      icon: Icons.child_care,
                      title: 'حساب الطفل و تعديل البيانات',
                      isSelected: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BabyAccountPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(height: 1),
                _buildDrawerSection(
                  'مُفضلتك',
                  [
                    DrawerItem(
                      icon: Icons.favorite_border,
                      title: 'مكتبه القصص',
                      isSelected: false,
                    onTap: () {},
                    ),
                    DrawerItem(
                      icon: Icons.message,
                      title: 'سجل المحادثات',
                      isSelected: false,
                      onTap: () {},
                    ),
                    DrawerItem(
                      icon: Icons.child_friendly,
                      title: 'سجل تحليل البكاء',
                      isSelected: false,
                      onTap: () {},
                    ),
                  ],
                ),
                const Divider(height: 1),
                _buildDrawerSection(
                  'الخصوصية والدعم',
                  [
                    DrawerItem(
                      icon: Icons.privacy_tip,
                      title: 'الخصوصية',
                      isSelected: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                    ),

                    DrawerItem(
                      icon: Icons.help,
                      title: 'الأسئلة الشائعة',
                      isSelected: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  Asked(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(height: 1),
                _buildDrawerSection(
                  'عن التطبيق',
                  [
                    DrawerItem(
                      icon: Icons.info,
                      title: 'حول التطبيق',
                      isSelected: false,
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const About(),
                        ),
                      );
                        },
                    ),
                  ],
                ),
                  const Divider(height: 1),
                  _buildDrawerSection(
                    'تواصل معنا',
                    [
                      DrawerItem(
                        icon: Icons.contacts,
                        title: 'تواصل معنا',
                        isSelected: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContactPage(),
                            ),
                          );
                        },
                      ),
                    ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}
