import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/cry_prediction/data/datasources/audio_cry_local_datasource.dart';
import 'package:mamyapp/features/cry_prediction/data/repositories/audio_cry_repository_impl.dart';
import 'package:mamyapp/features/cry_prediction/domain/usecases/start_recording_cry_usecase.dart';
import 'package:mamyapp/features/cry_prediction/domain/usecases/stop_recording_cry_usecase.dart';
import 'package:mamyapp/features/cry_prediction/presentation/bloc/bloc/audio_cry_bloc.dart';
import 'cry_loading_page.dart';
// import your datasource, repository, usecases as before

class RecordCryBaby extends StatelessWidget {
  const RecordCryBaby({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
    final datasource = AudioCryLocalDatasourceImpl(); // ✅ instance واحدة
    final repository = AudioCryRepositoryImpl(datasource);

    return RecordCryBloc(
      startRecordingCryUsecase: StartRecordingCryUsecase(repository),
      stopRecordingCryUsecase: StopRecordingCryUsecase(repository),
    );
  },
      child: const _RecordCryView(),
    );
  }
}

class _RecordCryView extends StatelessWidget {
  const _RecordCryView();

  void _handleSend(BuildContext context, RecordCryState state) {
    if (state is RecordCryStopped) {
      debugPrint("Saved file: ${state.record.path}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CryLoadingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لم يتم تسجيل أي صوت بعد")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecordCryBloc, RecordCryState>(
      listener: (context, state) {
        if (state is RecordCryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isRecording = state is RecordCryRecording;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFD4BA),
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/image_cry.png', height: 322),
              const SizedBox(height: 10),
              const Text(
                "ابدأي التسجيل",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Record Button
              GestureDetector(
                onTap: () => context.read<RecordCryBloc>().add(ToggleRecordingEvent()),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.red : const Color(0xFFFFB399),
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording ? Colors.red : const Color(0xFFFFB399))
                            .withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _handleSend(context, state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD4BA),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("ارسال التسجيل", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<RecordCryBloc>().add(ResetRecordingEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB399),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("اعادة التسجيل", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}