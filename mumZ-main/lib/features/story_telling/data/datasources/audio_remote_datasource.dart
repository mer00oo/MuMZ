
import 'package:mamyapp/features/story_telling/data/models/audio_model.dart';


abstract class AudioRemoteDatasource {
  Future<AudioModel> synthesize({
    required String text,
    required String mode,
    List<String>? speakerPaths,
    required bool useDiacritization,
  });
}