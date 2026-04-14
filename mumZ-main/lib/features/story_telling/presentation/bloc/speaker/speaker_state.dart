abstract class SpeakerState {}

class SpeakerInitial extends SpeakerState {}

class SpeakerUploading extends SpeakerState {}

class SpeakerUploadSuccess extends SpeakerState {
  final List<String> speakerPaths;
  SpeakerUploadSuccess(this.speakerPaths);
}

class SpeakerUploadError extends SpeakerState {
  final String message;
  SpeakerUploadError(this.message);
}
