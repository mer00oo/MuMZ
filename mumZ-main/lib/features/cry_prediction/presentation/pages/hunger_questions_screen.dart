import 'package:flutter/material.dart';
import 'package:mamyapp/features/cry_prediction/data/datasources/cry_prediction_remote_datasource.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/result_cry_prediction.dart';

class HungerQuestionsScreen extends StatefulWidget {
  const HungerQuestionsScreen({super.key});

  @override
  State<HungerQuestionsScreen> createState() => _HungerQuestionsScreenState();
}

class _HungerQuestionsScreenState extends State<HungerQuestionsScreen> {
  final Map<String, String?> _answers = {
    'q1': null,
    'q2': null,
    'q3': null,
    'q4': null,
    'q5': null,
    'q6': null,
  };

  bool _isLoading = false;

  // أسئلة وهمية مؤقتة
  final List<Map<String, dynamic>> _questions = [
    {
      'id': 'q1',
      'text': 'متى كانت آخر رضعة أو وجبة لطفلك؟',
      'options': [
        {'value': 'a', 'label': 'منذ أقل من ساعة'},
        {'value': 'b', 'label': 'منذ ساعة إلى ساعتين'},
        {'value': 'c', 'label': 'منذ أكثر من ساعتين'},
        {'value': 'd', 'label': 'لا أتذكر'},
      ],
    },
    {
      'id': 'q2',
      'text': 'هل طفلك يضع يده في فمه؟',
      'options': [
        {'value': 'a', 'label': 'نعم باستمرار'},
        {'value': 'b', 'label': 'أحيانًا'},
        {'value': 'c', 'label': 'لا'},
      ],
    },
    {
      'id': 'q3',
      'text': 'هل يتحرك رأسه يمينًا ويسارًا (rooting reflex)؟',
      'options': [
        {'value': 'a', 'label': 'نعم'},
        {'value': 'b', 'label': 'لا'},
        {'value': 'c', 'label': 'غير متأكدة'},
      ],
    },
    {
      'id': 'q4',
      'text': 'كيف كان بكاؤه؟',
      'options': [
        {'value': 'a', 'label': 'متقطع وقصير'},
        {'value': 'b', 'label': 'مستمر وقوي'},
        {'value': 'c', 'label': 'هادئ ومنخفض'},
        {'value': 'd', 'label': 'متصاعد تدريجيًا'},
      ],
    },
    {
      'id': 'q5',
      'text': 'هل أكل طفلك كميته الطبيعية في آخر رضعة؟',
      'options': [
        {'value': 'a', 'label': 'نعم'},
        {'value': 'b', 'label': 'لا، أكل أقل من المعتاد'},
        {'value': 'c', 'label': 'لا أعرف'},
      ],
    },
    {
      'id': 'q6',
      'text': 'هل طفلك يمص شفتيه أو لسانه؟',
      'options': [
        {'value': 'a', 'label': 'نعم'},
        {'value': 'b', 'label': 'لا'},
      ],
    },
  ];

  bool get _allAnswered => _answers.values.every((v) => v != null);

  Future<void> _submit() async {
    if (!_allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك أجيبي على كل الأسئلة')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final answers = _answers.map((k, v) => MapEntry(k, v!));
      final result =
          await CryPredictionRemoteDatasource().assessHunger(answers);

      if (!mounted) return;

      final isHungry = result['is_hungry'] as bool;
      final confidence = (result['confidence'] as num).toDouble();
      final recs = List<String>.from(result['recommendations'] ?? []);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultCryPrediction(
            prediction: isHungry ? 'الجوع' : 'ليس جوعًا',
            recommendation: recs.isNotEmpty ? recs.first : '',
            confidence: confidence,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8915A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تقييم الجوع',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE8915A)),
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'أجيبي على الأسئلة التالية لمعرفة إذا كان طفلك جائعًا',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff4A4A4A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final q = _questions[index];
                      final qId = q['id'] as String;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xffFBDECD)),
                        ),
                        color: const Color(0xffFFF8F4),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ${q['text']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...(q['options'] as List).map((opt) {
                                return RadioListTile<String>(
                                  value: opt['value'] as String,
                                  groupValue: _answers[qId],
                                  activeColor: const Color(0xFFE8915A),
                                  title: Text(opt['label'] as String),
                                  onChanged: (val) =>
                                      setState(() => _answers[qId] = val),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: _submit,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _allAnswered
                            ? const Color(0xFFE8915A)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'تحليل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}