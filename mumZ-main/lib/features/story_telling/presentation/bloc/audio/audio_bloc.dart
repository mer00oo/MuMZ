import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamyapp/core/utils/shared_prefs_helper.dart';
import 'package:mamyapp/features/story_telling/domain/use_cases/synthesize_story_usecase.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_event.dart';
import 'package:mamyapp/features/story_telling/presentation/bloc/audio/audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final SynthesizeStoryUseCase synthesizeStoryUseCase;

  AudioBloc(this.synthesizeStoryUseCase) : super(AudioInitial()) {
    on<SynthesizeStoryEvent>(_onSynthesize);
  }

  Future<void> _onSynthesize(
  SynthesizeStoryEvent event,
  Emitter<AudioState> emit,
) async {
  emit(AudioLoading());

  try {
    final audio = await synthesizeStoryUseCase(
      text: event.text,
      speakerPaths: event.speakerPaths,
    );

    if (audio.audioUrl.isEmpty) {
      emit(AudioError("فشل في توليد الصوت"));
      return;
    }

    if (event.storyId != null) {
      await saveAudioUrl(
        event.storyId!.toString(),
        audio.audioUrl,
      );
    }

    emit(AudioSuccess(audio));
  } catch (e) {
    emit(AudioError("حدث خطأ أثناء توليد الصوت"));
  }
}

}
