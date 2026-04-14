
import 'package:mamyapp/features/story_telling/domain/entities/speaker_upload_entity.dart';

class SpeakerUploadModel {
  final List<String> paths;

  SpeakerUploadModel({required this.paths});

  factory SpeakerUploadModel.fromJson(Map<String, dynamic> json) {
    return SpeakerUploadModel(
      paths: List<String>.from(json['paths']),
    );
  }

  SpeakerEntity toEntity() {
    return SpeakerEntity(paths: paths);
  }
}
