import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7FC),

        // AppBar
        appBar: AppBar(
          backgroundColor: const Color(0xFFE8915A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFFFFFFFF)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'الخصوصية',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.privacy_tip,
                        color: Color(0xFFE89B88), size: 40),
                    SizedBox(height: 10),
                    Text(
                      'نلتزم بحماية بياناتك وبيانات طفلك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'وضمان استخدامها بأمان داخل التطبيق.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildSection(
                number: '١',
                title: 'البيانات التي نجمعها',
                items: [
                  'اسم الطفل، العمر والصورة (اختياري).',
                  'تسجيلات الصوت للفحص أو تحليل البكاء.',
                  'سجل الفحوصات والتشخيص ونتائج التحليل.',
                ],
              ),

              _buildSection(
                number: '٢',
                title: 'استخدام البيانات',
                items: [
                  'تحسين دقة تحليل بكاء الطفل.',
                  'إنشاء القصص الصوتية.',
                  'تحسين تجربة المساعد الذكي.',
                ],
              ),

              _buildSection(
                number: '٣',
                title: 'حماية البيانات',
                items: [
                  'تخزين آمن ومشفر.',
                  'عدم مشاركة البيانات مع أي طرف خارجي.',
                  'عدم استخدام البيانات لأغراض تسويقية.',
                ],
              ),

              _buildSection(
                number: '٤',
                title: 'التحكم ببياناتك',
                items: [
                  'يمكنك تعديل أو حذف بيانات طفلك في أي وقت.',
                ],
              ),

              _buildSection(
                number: '٥',
                title: 'تحديث السياسة',
                items: [
                  'قد يتم تحديث هذه السياسة.',
                  'سيتم إعلامك عند حدوث تغييرات مهمة.',
                ],
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required List<String> items,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFFFEDF2),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFFE89B88),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Items
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.circle,
                      size: 6, color: Color(0xFFE89B88)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}