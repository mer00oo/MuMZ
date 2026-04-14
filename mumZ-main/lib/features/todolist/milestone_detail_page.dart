import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'milestone_data.dart';

class MilestoneDetailPage extends StatefulWidget {
  final int stageIndex;

  const MilestoneDetailPage({super.key, required this.stageIndex});

  @override
  State<MilestoneDetailPage> createState() =>
      _MilestoneDetailPageState();
}

class _MilestoneDetailPageState extends State<MilestoneDetailPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.stageIndex;
    loadProgress(); // 🔥 تحميل البيانات
  }

  MilestoneStage get currentStage => allStages[currentIndex];
  List<MilestoneCategory> get categories => currentStage.categories;

  int get totalCompleted =>
      categories.fold(0, (int sum, c) => sum + c.completed);

  int get totalItems =>
      categories.fold(0, (int sum, c) => sum + c.total);

  // ✅ تحميل كل الحالات
  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    for (int c = 0; c < categories.length; c++) {
      for (int i = 0; i < categories[c].items.length; i++) {

        final id = '${currentIndex}_${c}_$i';

        categories[c].items[i].isCompleted =
            prefs.getBool(id) ?? false;
      }
    }

    setState(() {});
  }

  // ✅ حفظ
  Future<void> saveProgress(int c, int i, bool value) async {
    final prefs = await SharedPreferences.getInstance();

    final id = '${currentIndex}_${c}_$i';

    await prefs.setBool(id, value);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0EEF5),
        body: SafeArea(
          child: Column(
            children: [

              // 🔝 Header
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          currentStage.label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B3FA8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 📄 Content
              Expanded(
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [

                      // 🟪 الصورة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          color: currentStage.bgColor,
                          child: Center(
                            child: Text(
                              currentStage.emoji,
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 📊 Progress
                      Text(
                        '$totalCompleted من $totalItems مكتملة',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🧩 Categories
                      ...List.generate(categories.length, (cIndex) {
                        final cat = categories[cIndex];

                        return _CategoryCard(
                          category: cat,
                          categoryIndex: cIndex,
                          onChanged: () => setState(() {}),
                          onItemToggle: (itemIndex, value) async {
                            await saveProgress(cIndex, itemIndex, value);
                          },
                        );
                      }),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ⬅️➡️ Navigation
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: currentIndex > 0
                          ? () async {
                        setState(() => currentIndex--);
                        await loadProgress(); // 🔥 مهم
                      }
                          : null,
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF8B3FA8)),
                      label: const Text(
                        'السابق',
                        style: TextStyle(
                          color: Color(0xFF8B3FA8),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed:
                      currentIndex < allStages.length - 1
                          ? () async {
                        setState(() => currentIndex++);
                        await loadProgress(); // 🔥 مهم
                      }
                          : null,
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward,
                          color: Color(0xFF8B3FA8)),
                      label: const Text(
                        'التالي',
                        style: TextStyle(
                          color: Color(0xFF8B3FA8),
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
}

class _CategoryCard extends StatefulWidget {
  final MilestoneCategory category;
  final int categoryIndex;
  final VoidCallback onChanged;
  final Function(int itemIndex, bool value) onItemToggle;

  const _CategoryCard({
    required this.category,
    required this.categoryIndex,
    required this.onChanged,
    required this.onItemToggle,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {

  bool _isExpanded = false;

  late AnimationController _controller;
  late Animation<double> _iconTurn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _iconTurn = Tween<double>(begin: 0, end: 0.5)
        .animate(_controller);
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Column(
      children: [

        GestureDetector(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(category.icon, color: category.bgColor),
                const SizedBox(width: 10),
                Expanded(child: Text(category.title)),
                Text('${category.completed}/${category.total}'),
              ],
            ),
          ),
        ),

        AnimatedCrossFade(
          firstChild: Column(
            children: List.generate(category.items.length, (i) {
              final item = category.items[i];

              return ListTile(
                title: Text(item.title),
                trailing: Icon(
                  item.isCompleted
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                ),
                onTap: () {
                  setState(() {
                    item.isCompleted = !item.isCompleted;
                  });

                  widget.onItemToggle(i, item.isCompleted);
                  widget.onChanged();
                },
              );
            }),
          ),
          secondChild: const SizedBox(),
          crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 250),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}