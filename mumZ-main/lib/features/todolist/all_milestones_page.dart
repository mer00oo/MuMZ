import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'milestone_data.dart';
import 'milestone_detail_page.dart';

class AllMilestonesPage extends StatefulWidget {
  const AllMilestonesPage({super.key});

  @override
  State<AllMilestonesPage> createState() => _AllMilestonesPageState();
}

class _AllMilestonesPageState extends State<AllMilestonesPage> {

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    for (int s = 0; s < allStages.length; s++) {
      final stage = allStages[s];

      for (int c = 0; c < stage.categories.length; c++) {
        final cat = stage.categories[c];

        for (int i = 0; i < cat.items.length; i++) {
          final id = '${s}_${c}_$i';
          cat.items[i].isCompleted = prefs.getBool(id) ?? false;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0EEF5),

        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8915A), Color(0xFFE8915A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,

          // ✅ زر الرجوع على اليمين
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFFFFFFF),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],

          title: const Text(
            'كل المراحل',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),

        body: SafeArea(
          child: ListView.builder(
            itemCount: allStages.length,
            itemBuilder: (context, index) {
              final stage = allStages[index];

              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MilestoneDetailPage(
                        stageIndex: index,
                      ),
                    ),
                  );
                  await loadProgress();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [

                      // 🟪 الصورة
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: stage.bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            stage.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // 📊 البيانات
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  stage.label,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${stage.completed}/${stage.total}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: stage.total > 0
                                    ? stage.completed / stage.total
                                    : 0,
                                minHeight: 5,
                                backgroundColor: Colors.grey.shade300,
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF28BFBF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}