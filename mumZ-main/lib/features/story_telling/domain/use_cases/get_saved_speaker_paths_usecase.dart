// features/story_telling/domain/use_cases/get_saved_speaker_paths_usecase.dart
import 'package:mamyapp/features/story_telling/domain/repositories/speaker_repository.dart';

class GetSavedSpeakerPathsUseCase {
  final SpeakerRepository repository;

  GetSavedSpeakerPathsUseCase(this.repository);

  Future<List<String>?> call() async {
    return await repository.getSpeakerPaths();
  }
}