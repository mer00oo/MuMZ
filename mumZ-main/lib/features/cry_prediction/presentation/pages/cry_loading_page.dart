import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/cry_prediction/data/datasources/cry_prediction_remote_datasource.dart';
import 'package:mamyapp/features/cry_prediction/presentation/bloc/cry_bloc/bloc/cry_prediction_bloc.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/hunger_questions_screen.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/result_cry_prediction.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/record_cry_baby.dart';

class CryLoadingScreen extends StatelessWidget {
  final String audioPath;

  const CryLoadingScreen({super.key, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CryPredictionBloc(
        datasource: CryPredictionRemoteDatasource(),
      )..add(AnalyzeCryEvent(audioPath)), // ← بتبعت أوتوماتيك لما الشاشة تفتح
      child: const _CryLoadingView(),
    );
  }
}

class _CryLoadingView extends StatelessWidget {
  const _CryLoadingView();

  String _translatePrediction(String prediction) {
    const map = {
      'belly_pain': 'ألم في البطن',
      'burping': 'يحتاج تجشؤ',
      'cold_hot': 'يشعر بالبرد أو الحر',
      'discomfort': 'عدم ارتياح',
      'scared': 'خائف',
      'tired': 'متعب',
      'unknown': 'غير محدد',
    };
    return map[prediction] ?? prediction;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CryPredictionBloc, CryPredictionState>(
      listener: (context, state) {
        if (state is CryPredictionSuccess) {
          final result = state.result;

          if (!result.isUnknown) {
            // ✅ النتيجة واضحة → روح لشاشة النتيجة
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ResultCryPrediction(
                  prediction: _translatePrediction(result.prediction),
                  recommendation: result.recommendations.isNotEmpty
                      ? result.recommendations.first
                      : '',
                  confidence: result.confidence,
                ),
              ),
            );
          } else if (result.confidence >= 0.4) {
            // ⚠️ صوت مش واضح بس قريب → اعد التسجيل
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const RecordCryBaby(showRetryMessage: true),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HungerQuestionsScreen(),
              ),
            );
          }
        } else if (state is CryPredictionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE8915A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تحليل سبب بكاء طفلك',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/image_cry.png'),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                color: Color(0xFFE8915A),
              ),
              const SizedBox(height: 24),
              const Text(
                'يتم تحليل صوت الطفل...',
                style: TextStyle(
                  color: Color(0xff4A4A4A),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}