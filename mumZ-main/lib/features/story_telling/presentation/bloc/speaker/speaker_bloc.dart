import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/features/story_telling/domain/use_cases/get_saved_speaker_paths_usecase.dart';
import 'package:mamyapp/features/story_telling/domain/use_cases/upload_speakers_usecase.dart';
import 'speaker_event.dart';
import 'speaker_state.dart';

class SpeakerBloc extends Bloc<SpeakerEvent, SpeakerState> {
  final UploadSpeakersUseCase uploadUseCase;
  final GetSavedSpeakerPathsUseCase getSavedPathsUseCase;

  SpeakerBloc({
    required this.uploadUseCase,
    required this.getSavedPathsUseCase,
  }) : super(SpeakerInitial()) {
    on<UploadSpeakersEvent>(_onUpload);
    on<LoadSavedSpeakerPathsEvent>(_onLoadSaved);

    _loadInitialPaths();
  }

  Future<void> _loadInitialPaths() async {
    final savedPaths = await getSavedPathsUseCase();
    if (savedPaths != null && savedPaths.isNotEmpty) {
      add(LoadSavedSpeakerPathsEvent(savedPaths));
      if (kDebugMode) {
        print('📦 Loaded ${savedPaths.length} saved paths from database');
      }
    }
  }

  Future<void> _onUpload(
    UploadSpeakersEvent event,
    Emitter<SpeakerState> emit,
  ) async {
    emit(SpeakerUploading());
    try {
      if (kDebugMode) {
        print('🚀 Uploading ${event.filePaths.length} files to server...');
      }
      
      final entity = await uploadUseCase(
        filePaths: event.filePaths,
      );

      if (kDebugMode) {
        print('Upload successful! ${entity.paths.length} paths received');
      }
      if (kDebugMode) {
        print(' Paths automatically saved to SQLite database');
      }

      emit(SpeakerUploadSuccess(entity.paths));
    } catch (e) {
      if (kDebugMode) {
        print(' error: $e');
      }
      emit(SpeakerUploadError(e.toString()));
    }
  }

  void _onLoadSaved(
    LoadSavedSpeakerPathsEvent event,
    Emitter<SpeakerState> emit,
  ) {
    if (kDebugMode) {
      print(' Loading saved paths: ${event.paths.length} files');
    }
    emit(SpeakerUploadSuccess(event.paths));
  }
}