
import 'package:mamyapp/features/story_telling/data/models/speaker_upload_model.dart';

abstract class SpeakerRemoteDatasource {
  Future<SpeakerUploadModel> upload({
    required List<String> filePaths,
  });
}