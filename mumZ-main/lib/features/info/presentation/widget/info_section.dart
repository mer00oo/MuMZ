import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String number;
  final String title;
  final List<String> items;
  final bool isLast;

  const InfoSection({
    super.key,
    required this.number,
    required this.title,
    required this.items,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. $title',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.arrow_right,
                  size: 18,
                  color: Color(0xFFE89B88),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (!isLast) ...[
          const SizedBox(height: 20),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
          ),
          const SizedBox(height: 25),
        ],
      ],
    );
  }
}
