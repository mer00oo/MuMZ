
import 'package:mamyapp/features/story_telling/data/datasources/audio_remote_datasource.dart';
import 'package:mamyapp/features/story_telling/domain/entities/audio_entity.dart';
import 'package:mamyapp/features/story_telling/domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioRemoteDatasource remoteDatasource;

  AudioRepositoryImpl(this.remoteDatasource);

  @override
  Future<AudioEntity> synthesizeStory({
    required String text,
    required String mode,
    List<String>? speakerPaths,
    required bool useDiacritization,
  }) async {
    final model = await remoteDatasource.synthesize(
      text: text,
      mode: mode,
      speakerPaths: speakerPaths,
      useDiacritization: useDiacritization,
    );
    return model.toEntity();
  }
}
