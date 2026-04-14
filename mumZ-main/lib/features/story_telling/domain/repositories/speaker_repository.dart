// features/story_telling/domain/repositories/speaker_repository.dart
import 'package:mamyapp/features/story_telling/domain/entities/speaker_upload_entity.dart';

abstract class SpeakerRepository {
  Future<SpeakerEntity> uploadSpeakers({required List<String> filePaths});
  Future<void> saveSpeakerPaths(List<String> paths);
  Future<List<String>?> getSpeakerPaths(); // ✅ غيرناها لـ async
}