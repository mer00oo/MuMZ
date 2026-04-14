import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerItem({super.key, 
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFFFB347) : const Color(0xFF888888),
        size: 22,
      ),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF333333) : const Color(0xFF666666),
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFFFFF5EE),
      onTap: onTap,
    );
  }
}
