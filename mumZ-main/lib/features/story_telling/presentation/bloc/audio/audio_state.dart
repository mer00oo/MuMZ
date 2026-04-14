import 'package:mamyapp/features/story_telling/domain/entities/audio_entity.dart';


abstract class AudioState {}
class AudioInitial extends AudioState {}
class AudioLoading extends AudioState {}
class AudioSuccess extends AudioState {
  final AudioEntity audio;
  AudioSuccess(this.audio);
}
class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}
