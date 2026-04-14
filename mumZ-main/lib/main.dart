import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mamyapp/app.dart';   
import 'package:mamyapp/core/di/injection_container.dart' as di;
import 'package:mamyapp/features/story_telling/presentation/pages/speaker_result_page.dart';
import 'package:mamyapp/services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('speaker_box'); 

  await di.init();

  runApp(const MyApp());
}