import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7FC),

        appBar: AppBar(
          backgroundColor: const Color(0xFFFFEDF2),
          elevation: 0,
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFE89B88)),
            onPressed: () {},
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Color(0xFFE89B88)),
              onPressed: () => Navigator.pop(context),
            ),
          ],

          title: const Text(
            'تواصل معنا',
            style: TextStyle(
              color: Color(0xFFE89B88),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                    Icon(Icons.support_agent,
                        size: 40, color: Color(0xFFE89B88)),
                    SizedBox(height: 10),
                    Text(
                      'هل لديك سؤال أو مشكلة؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'يسعدنا مساعدتك في أي وقت عبر وسائل التواصل المختلفة',
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
                title: 'البريد الإلكتروني',
                items: const [
                  'Email: example@email.com',
                  'للإستفسارات أو الإبلاغ عن مشكلة أو اقتراح ميزة.',
                ],
              ),

              _buildSection(
                number: '٢',
                title: 'مركز المساعدة',
                items: const [
                  'أسئلة شائعة وإرشادات سريعة لحل أغلب المشكلات.',
                ],
              ),

              _buildSection(
                number: '٣',
                title: 'إرسال بلاغ داخل التطبيق',
                items: const [
                  'يمكنك إرسال رسالة مباشرة من داخل التطبيق مع وصف المشكلة.',
                ],
              ),

              const SizedBox(height: 20),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "إرسال رسالة",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB4A0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildSection(
                number: '٤',
                title: 'تابعينا على صفحاتنا',
                items: const [
                  'Instagram: @MumZBabyCare',
                  'Facebook: MumZBabyCare',
                ],
                isLast: true,
              ),

              const SizedBox(height: 20),

              const Text(
                'سعداء دائمًا بمساعدتك ❤️',
                style: TextStyle(
                  color: Color(0xFFE89B88),
                  fontSize: 18,
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