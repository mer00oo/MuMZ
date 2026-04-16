import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:mamyapp/app.dart';
import 'package:mamyapp/core/di/injection_container.dart' as di;
import 'package:mamyapp/services/firebase_options.dart';
import 'package:mamyapp/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('speaker_box');

  await di.init();

  await NotificationService.init();

  runApp(const MyApp());
}