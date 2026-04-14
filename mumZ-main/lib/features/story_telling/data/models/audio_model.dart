import 'package:mamyapp/features/story_telling/domain/entities/audio_entity.dart';


class AudioModel {
  final String audioUrl;
  final String originalText;
  final String? diacritizedText;

  AudioModel({
    required this.audioUrl,
    required this.originalText,
    this.diacritizedText,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      audioUrl: json['audio_url'],
      originalText: json['original_text'],
      diacritizedText: json['diacritized_text'],
    );
  }

  AudioEntity toEntity() {
    return AudioEntity(
      audioUrl: audioUrl,
      originalText: originalText,
      diacritizedText: diacritizedText,
    );
  }
}
