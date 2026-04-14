import 'package:flutter/material.dart';

class AnimatedNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AnimatedNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedNavBarState createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الخلفية
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xfff8c7b6),
              borderRadius: BorderRadius.circular(30),
            ),
          ),

          // الدائرة المتحركة
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left: 20 + (MediaQuery.of(context).size.width / 3) * widget.selectedIndex,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Center(
                child: Icon(
                  _icons[widget.selectedIndex],
                  color: Colors.orange,
                  size: 28,
                ),
              ),
            ),
          ),

          // شريط الأيقونات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_icons.length, (index) {
              return GestureDetector(
                onTap: () => widget.onTap(index),
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: Icon(
                    _icons[index],
                    color: widget.selectedIndex == index
                        ? Colors.transparent
                        : Colors.orange.shade400,
                    size: 28,
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  final List<IconData> _icons = [
    Icons.home,
    Icons.settings,
    Icons.notifications,
  ];
}
