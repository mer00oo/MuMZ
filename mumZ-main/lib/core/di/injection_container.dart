import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:mamyapp/core/storage/speaker_local_storage.dart';
import 'package:mamyapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mamyapp/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:mamyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:mamyapp/features/auth/domain/usecase/log_in.dart';
import 'package:mamyapp/features/auth/domain/usecase/sign_up.dart';
import 'package:mamyapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mamyapp/features/story_telling/data/datasources/audio_remote_datasource.dart';
import 'package:mamyapp/features/story_telling/data/datasources/audio_remote_datasource_impl.dart';
import 'package:mamyapp/features/story_telling/data/datasources/speaker_remote_datasource.dart';
import 'package:mamyapp/features/story_telling/data/datasources/speaker_remote_datasourceImpl.dart';
import 'package:mamyapp/features/story_telling/data/repositories/audio_repository_impl.dart';
import 'package:mamyapp/features/story_telling/data/repositories/speaker_repository_impl.dart';
import 'package:mamyapp/features/story_telling/domain/repositories/audio_repository.dart';
import 'package:mamyapp/features/story_telling/domain/repositories/speaker_repository.dart';
import 'package:mamyapp/features/story_telling/domain/use_cases/get_saved_speaker_paths_usecase.dart';
import 'package:mamyapp/features/story_telling/domain/use_cases/synthesize_story_usecase.dart';
import 'package:mamyapp/features/story_telling/domain/use_cases/upload_speakers_usecase.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_bloc.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/speaker/speaker_bloc.dart';
import 'package:mamyapp/services/firebase_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========================================
  // 🔥 External Dependencies (مرة واحدة بس)
  // ========================================
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => http.Client()); // ✅ مرة واحدة بس

  // ========================================
  // 🔥 Core Services
  // ========================================
  sl.registerLazySingleton<FirebaseService>(
    () => FirebaseService(
      authInstance: sl(),
      firestoreInstance: sl(),
    ),
  );

  sl.registerLazySingleton<SpeakerLocalStorage>(
    () => SpeakerLocalStorage(),
  );

  // ========================================
  // 🔥 Auth Feature
  // ========================================
  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      loginUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<AudioRemoteDatasource>(
    () => AudioRemoteDatasourceImpl(
      client: sl(),
      baseUrl: 'http://46.224.127.51:8000',
    ),
  );

  // Repository
  sl.registerLazySingleton<AudioRepository>(
    () => AudioRepositoryImpl(sl()),
  );

  // UseCase
  sl.registerLazySingleton<SynthesizeStoryUseCase>(
    () => SynthesizeStoryUseCase(sl()),
  );

  // Bloc
  sl.registerFactory<AudioBloc>(
    () => AudioBloc(sl()),
  );

  sl.registerLazySingleton<SpeakerRemoteDatasource>(
    () => SpeakerRemoteDatasourceImpl(
      client: sl(),
      baseUrl: 'http://46.224.127.51:8000',
    ),
  );

  // Repository
  sl.registerLazySingleton<SpeakerRepository>(
    () => SpeakerRepositoryImpl(sl(), sl()),
  );

  // Use Cases
  sl.registerLazySingleton<UploadSpeakersUseCase>(
    () => UploadSpeakersUseCase(sl()),
  );
  
  sl.registerLazySingleton<GetSavedSpeakerPathsUseCase>(
    () => GetSavedSpeakerPathsUseCase(sl()),
  );

  // Bloc
  sl.registerFactory<SpeakerBloc>(
    () => SpeakerBloc(
      uploadUseCase: sl(),
      getSavedPathsUseCase: sl(),
    ),
  );

  if (kDebugMode) {
    print('✅ All dependencies registered successfully!');
  }
}