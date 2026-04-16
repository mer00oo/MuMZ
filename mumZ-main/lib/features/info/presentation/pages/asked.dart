import 'package:flutter/material.dart';

class Asked extends StatelessWidget {
  Asked({super.key});

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7FC),

        appBar: AppBar(
          backgroundColor: const Color(0xFFE8915A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFFFFFFFF)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            ' الأسئلة الشائعة',
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
              // Header
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
                    Icon(Icons.help_outline,
                        size: 40, color: Color(0xFFE89B88)),
                    SizedBox(height: 10),
                    Text(
                      'إجابات على أكثر الأسئلة شيوعًا',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'ولو مش لاقي إجابة سؤالك ابعتلنا رسالة 👇',
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
                title: 'هل تحليل بكاء الطفل دقيق؟',
                items: const [
                  'نعم، يعتمد على نموذج ذكاء اصطناعي مدرّب، لكنه ليس بديلاً عن الطبيب.',
                ],
              ),

              _buildSection(
                number: '٢',
                title: 'كم عدد المقاطع المطلوبة لنسخ الصوت؟',
                items: const [
                  'يجب تسجيل 20 مقطع صوتي للحصول على أفضل دقة.',
                ],
              ),

              _buildSection(
                number: '٣',
                title: 'كيف يتم إنشاء القصص؟',
                items: const [
                  'يتم توليد القصص باستخدام الذكاء الاصطناعي بصوتك أو صوت افتراضي.',
                ],
              ),

              _buildSection(
                number: '٤',
                title: 'ماذا أفعل إذا واجهت مشكلة؟',
                items: const [
                  'يمكنك التواصل عبر البريد الإلكتروني أو إرسال رسالة داخل التطبيق.',
                ],
                isLast: true,
              ),

              const SizedBox(height: 20),

              // Input Card
              Container(
                padding: const EdgeInsets.all(12),
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
                child: TextField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'اكتبي رسالتك هنا...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.chat,
                        color: Color(0xFFE89B88)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إرسال الرسالة بنجاح!'),
                        ),
                      );
                      messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "إرسال الرسالة",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8915A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'سعداء بالإجابة عن أسئلتك دائمًا ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE89B88),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFFFEDF2),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFFE89B88),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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