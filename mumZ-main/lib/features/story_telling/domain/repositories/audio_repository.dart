import 'package:mamyapp/features/story_telling/domain/entities/audio_entity.dart';

abstract class AudioRepository {
  Future<AudioEntity> synthesizeStory({
    required String text,
    required String mode,
    List<String>? speakerPaths,
    required bool useDiacritization,
  });
}
