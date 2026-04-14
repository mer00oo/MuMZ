// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mamyapp/features/chatbot/presentation/widget/message_bubble.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<ChatHistory> _chatHistory = [
    ChatHistory(
      title: 'مشاكل النوم بالليل',
      date: 'اليوم - 2:10',
      preview: '',
    ),
    ChatHistory(
      title: 'تهدئة بكاء الطفل',
      date: 'أمس - 7:55',
      preview: '',
    ),
    ChatHistory(
      title: 'صراخ الطفل',
      date: 'منذ أسبوع',
      preview: '',
    ),
    ChatHistory(
      title: 'سخونة طفلي',
      date: 'منذ أسبوع',
      preview: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // رسائل افتراضية للعرض (بالترتيب من فوق لتحت)
    _messages.addAll([
      ChatMessage(
        text: 'مرحبا! أنا مساعدك الذكي\nجاهز لمساعدتك بكل ما يخص طفلك، مثل: تقديم نصائح، الإجابة عن أسئلتك، أو أي حاجة تحتاجينها.',
        isBot: true,
      ),
      ChatMessage(
        text: 'نصائح عن نوم الأطفال تعرفي على أفضل الطرق لمساعدة طفلتك بنام بشكل صحي',
        isBot: true,
      ),
      ChatMessage(
        text: 'صحة طفلك اليومية معلومات موثوقة عن التطعيمات، التطور، والفيتامينات',
        isBot: true,
      ),
      ChatMessage(
        text: 'الثقافة اليومية إرشادات بسيطة تساعدك في فهم احتياجات طفلك في كل مرحلة',
        isBot: true,
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isBot: false,
        ),
      );
    });

    _messageController.clear();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'شكراً على سؤالك! أنا هنا للمساعدة.',
            isBot: true,
          ),
        );
      });
    });
  }

  void _showChatHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'تاريخ المحادثات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Chat history list
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: _chatHistory.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE0E0E0),
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final history = _chatHistory[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('فتح محادثة: ${history.title}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                // Delete icon
                                InkWell(
                                  onTap: () {
                                    setModalState(() {
                                      _chatHistory.removeAt(index);
                                    });
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم حذف: ${history.title}'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Color(0xFF666666),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Chat info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        history.title,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        history.date,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF999999),
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFDAB9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5D4E37)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'مساعدك الذكي',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4E37),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFF5D4E37)),
            tooltip: 'سجل المحادثات',
            onPressed: _showChatHistoryBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  text: message.text,
                  isBot: message.isBot,
                );
              },
            ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Send button
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFDAB9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xFF5D4E37),
                        size: 20,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Text field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          hintText: 'كيف يمكنني مساعدتك؟',
                          hintStyle: TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}


// Chat Message Model
class ChatMessage {
  final String text;
  final bool isBot;

  ChatMessage({
    required this.text,
    required this.isBot,
  });
}

// Chat History Model
class ChatHistory {
  final String title;
  final String date;
  final String preview;

  ChatHistory({
    required this.title,
    required this.date,
    required this.preview,
  });
}