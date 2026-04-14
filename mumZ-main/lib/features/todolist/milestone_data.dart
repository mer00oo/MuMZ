import 'package:flutter/material.dart';

class MilestoneItem {
  final String title;
  bool isCompleted;

  MilestoneItem({
    required this.title,
    this.isCompleted = false,
  });

}

class MilestoneCategory {
  final String title;
  final Color bgColor;
  final IconData icon;
  final List<MilestoneItem> items;

  MilestoneCategory({
    required this.title,
    required this.bgColor,
    required this.icon,
    required this.items,
  });

  int get completed => items.where((i) => i.isCompleted).length;
  int get total => items.length;
}

class MilestoneStage {
  final String label;
  final Color bgColor;
  final String emoji;
  final List<MilestoneCategory> categories;

  MilestoneStage({
    required this.label,
    required this.bgColor,
    required this.emoji,
    required this.categories,
  });

  // ✅ حساب ديناميك
  int get completed =>
      categories.fold(0, (sum, c) => sum + c.completed);

  int get total =>
      categories.fold(0, (sum, c) => sum + c.total);
}

// ✅ كل البيانات
final List<MilestoneStage> allStages = [
  MilestoneStage(
    label: '٠ – ٢ شهر',
    bgColor: const Color(0xFFF5E6B0),
    emoji: '👶',
    categories: [
      MilestoneCategory(
        title: 'المهارات الإدراكية (التعلم، التفكير، حل المشكلات)',
        bgColor: const Color(0xFF4CAF82),
        icon: Icons.lightbulb_outline,
        items: [
          MilestoneItem(title: 'يتابعك بعينيه وأنت تتحرك'),
          MilestoneItem(title: 'ينظر إلى لعبة لعدة ثوانٍ'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات اللغة والتواصل',
        bgColor: const Color(0xFF26C6DA),
        icon: Icons.chat_bubble_outline,
        items: [
          MilestoneItem(title: 'يصدر أصواتاً غير البكاء'),
          MilestoneItem(title: 'يستجيب للأصوات العالية'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات الحركة والنمو الجسدي',
        bgColor: const Color(0xFF7B3FA8),
        icon: Icons.accessibility_new,
        items: [
          MilestoneItem(title: 'يرفع رأسه أثناء الاستلقاء على بطنه'),
          MilestoneItem(title: 'يحرك ذراعيه وساقيه'),
          MilestoneItem(title: 'يفتح يديه لفترة قصيرة'),
        ],
      ),
      MilestoneCategory(
        title: 'المهارات الاجتماعية والعاطفية',
        bgColor: const Color(0xFFF5A96A),
        icon: Icons.sentiment_satisfied_alt,
        items: [
          MilestoneItem(title: 'يهدأ عند حمله أو التحدث إليه'),
          MilestoneItem(title: 'ينظر إلى وجهك'),
          MilestoneItem(title: 'يبدو سعيداً عند اقترابك منه'),
          MilestoneItem(title: 'يبتسم عند التحدث إليه أو الابتسام له'),
        ],
      ),
    ],
  ),

  MilestoneStage(
    label: '٢ – ٤ شهر',
    bgColor: const Color(0xFFF5A96A),
    emoji: '🧒',
    categories: [
      MilestoneCategory(
        title: 'المهارات الإدراكية',
        bgColor: const Color(0xFF4CAF82),
        icon: Icons.lightbulb_outline,
        items: [
          MilestoneItem(title: 'يتعرف على وجه أمه'),
          MilestoneItem(title: 'يتابع الأشياء المتحركة بعينيه'),
          MilestoneItem(title: 'يُظهر الملل عند تكرار نفس النشاط'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات اللغة والتواصل',
        bgColor: const Color(0xFF26C6DA),
        icon: Icons.chat_bubble_outline,
        items: [
          MilestoneItem(title: 'يصدر أصوات مثل "آه" و"اوه"'),
          MilestoneItem(title: 'يبتسم عند سماع صوتك'),
          MilestoneItem(title: 'يبدأ في الثرثرة'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات الحركة',
        bgColor: const Color(0xFF7B3FA8),
        icon: Icons.accessibility_new,
        items: [
          MilestoneItem(title: 'يرفع رأسه وصدره على بطنه'),
          MilestoneItem(title: 'يمد يده نحو الأشياء'),
          MilestoneItem(title: 'يمسك الأشياء لفترة قصيرة'),
          MilestoneItem(title: 'يدفع بساقيه عند وضعه على سطح صلب'),
        ],
      ),
      MilestoneCategory(
        title: 'المهارات الاجتماعية والعاطفية',
        bgColor: const Color(0xFFF5A96A),
        icon: Icons.sentiment_satisfied_alt,
        items: [
          MilestoneItem(title: 'يبتسم تلقائياً للناس'),
          MilestoneItem(title: 'يحب اللعب مع الناس'),
          MilestoneItem(title: 'يقلد بعض الحركات والتعابير'),
        ],
      ),
    ],
  ),

  MilestoneStage(
    label: '٤ – ٦ شهر',
    bgColor: const Color(0xFFB8E878),
    emoji: '🧒',
    categories: [
      MilestoneCategory(
        title: 'المهارات الإدراكية',
        bgColor: const Color(0xFF4CAF82),
        icon: Icons.lightbulb_outline,
        items: [
          MilestoneItem(title: 'يتعرف على الأشياء المألوفة'),
          MilestoneItem(title: 'يبحث عن الأشياء الساقطة'),
          MilestoneItem(title: 'يُظهر فضولاً تجاه الأشياء البعيدة'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات اللغة والتواصل',
        bgColor: const Color(0xFF26C6DA),
        icon: Icons.chat_bubble_outline,
        items: [
          MilestoneItem(title: 'يستجيب لاسمه'),
          MilestoneItem(title: 'يصدر أصوات ساخطة وسعيدة'),
          MilestoneItem(title: 'يبدأ بالمناغاة بحروف ساكنة'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات الحركة',
        bgColor: const Color(0xFF7B3FA8),
        icon: Icons.accessibility_new,
        items: [
          MilestoneItem(title: 'يتقلب من بطنه لظهره'),
          MilestoneItem(title: 'يجلس بدعم'),
          MilestoneItem(title: 'يمسك الأشياء بيد واحدة'),
          MilestoneItem(title: 'يضع الأشياء في فمه'),
        ],
      ),
      MilestoneCategory(
        title: 'المهارات الاجتماعية والعاطفية',
        bgColor: const Color(0xFFF5A96A),
        icon: Icons.sentiment_satisfied_alt,
        items: [
          MilestoneItem(title: 'يعرف الوجوه المألوفة'),
          MilestoneItem(title: 'يحب اللعب مع الآخرين'),
        ],
      ),
    ],
  ),

  MilestoneStage(
    label: '٦ – ٩ شهر',
    bgColor: const Color(0xFFB98AE8),
    emoji: '👧',
    categories: [
      MilestoneCategory(
        title: 'المهارات الإدراكية',
        bgColor: const Color(0xFF4CAF82),
        icon: Icons.lightbulb_outline,
        items: [
          MilestoneItem(title: 'يبحث عن شيء مخفي أمامه'),
          MilestoneItem(title: 'يضرب شيئين ببعض'),
          MilestoneItem(title: 'يفهم كلمة "لا"'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات اللغة والتواصل',
        bgColor: const Color(0xFF26C6DA),
        icon: Icons.chat_bubble_outline,
        items: [
          MilestoneItem(title: 'يناغي بحروف مثل "بابا" "ماما"'),
          MilestoneItem(title: 'يستخدم الإيماءات مثل التلويح'),
          MilestoneItem(title: 'يُظهر ردود فعل على المشاعر'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات الحركة',
        bgColor: const Color(0xFF7B3FA8),
        icon: Icons.accessibility_new,
        items: [
          MilestoneItem(title: 'يجلس بدون دعم'),
          MilestoneItem(title: 'يزحف'),
          MilestoneItem(title: 'يقف بمساعدة'),
          MilestoneItem(title: 'ينقل الأشياء بين يديه'),
        ],
      ),
      MilestoneCategory(
        title: 'المهارات الاجتماعية والعاطفية',
        bgColor: const Color(0xFFF5A96A),
        icon: Icons.sentiment_satisfied_alt,
        items: [
          MilestoneItem(title: 'يخاف من الغرباء'),
          MilestoneItem(title: 'يُظهر تعلقاً بمن يرعاه'),
          MilestoneItem(title: 'يلعب ألعاب بسيطة مثل الغميضة'),
        ],
      ),
    ],
  ),

  MilestoneStage(
    label: '٩ – ١٢ شهر',
    bgColor: const Color(0xFF6AD8E8),
    emoji: '👧',
    categories: [
      MilestoneCategory(
        title: 'المهارات الإدراكية',
        bgColor: const Color(0xFF4CAF82),
        icon: Icons.lightbulb_outline,
        items: [
          MilestoneItem(title: 'يستخدم الأشياء بشكل صحيح مثل الكوب'),
          MilestoneItem(title: 'يضع الأشياء داخل حاوية'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات اللغة والتواصل',
        bgColor: const Color(0xFF26C6DA),
        icon: Icons.chat_bubble_outline,
        items: [
          MilestoneItem(title: 'يقول "ماما" و"بابا" بوعي'),
          MilestoneItem(title: 'يفهم طلبات بسيطة'),
          MilestoneItem(title: 'يُشير إلى ما يريده'),
        ],
      ),
      MilestoneCategory(
        title: 'مهارات الحركة',
        bgColor: const Color(0xFF7B3FA8),
        icon: Icons.accessibility_new,
        items: [
          MilestoneItem(title: 'يقف لوحده'),
          MilestoneItem(title: 'يمشي خطوات بمساعدة'),
          MilestoneItem(title: 'يمسك الأشياء الصغيرة بإصبعين'),
        ],
      ),
      MilestoneCategory(
        title: 'المهارات الاجتماعية والعاطفية',
        bgColor: const Color(0xFFF5A96A),
        icon: Icons.sentiment_satisfied_alt,
        items: [
          MilestoneItem(title: 'يُظهر تفضيلاً لأشخاص معينين'),
          MilestoneItem(title: 'يكرر أفعالاً تضحك الآخرين'),
        ],
      ),
    ],
  ),
];
