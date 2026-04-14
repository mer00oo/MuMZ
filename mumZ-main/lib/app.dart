import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/cry_page.dart';
import 'package:mamyapp/features/cry_prediction/presentation/pages/result_cry_prediction.dart';
import 'package:mamyapp/features/home/presentation/pages/home_page.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/speaker/speaker_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/pages/choose_story.dart';
import 'package:mamyapp/core/di/injection_container.dart' as di;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioBloc>(
          create: (_) => di.sl<AudioBloc>(),
        ),

        BlocProvider<SpeakerBloc>(
          create: (_) => di.sl<SpeakerBloc>(),
        ),

        // 👇 بعدين تزودي أي Bloc تاني هنا
        // BlocProvider<StoryBloc>(
        //   create: (_) => di.sl<StoryBloc>(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BabyCare',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        ),
        home: HomePage(),
      ),
    );
  }
}
