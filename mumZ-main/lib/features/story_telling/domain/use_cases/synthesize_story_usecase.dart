import 'package:mamyapp/features/story_telling/domain/entities/audio_entity.dart';
import 'package:mamyapp/features/story_telling/domain/repositories/audio_repository.dart';
class SynthesizeStoryUseCase {
  final AudioRepository repository;

  SynthesizeStoryUseCase(this.repository);

  Future<AudioEntity> call({
    required String text,
    List<String>? speakerPaths,
    bool useDiacritization = true,
  }) {
    final mode =
        (speakerPaths != null && speakerPaths.isNotEmpty) ? 'clone' : 'default';

    return repository.synthesizeStory(
      text: text,
      mode: mode,
      speakerPaths: speakerPaths,
      useDiacritization: useDiacritization,
    );
  }
}

