abstract class SpeakerEvent {}

class UploadSpeakersEvent extends SpeakerEvent {
  final List<String> filePaths;
  UploadSpeakersEvent({required this.filePaths});
}

class LoadSavedSpeakerPathsEvent extends SpeakerEvent {
  final List<String> paths;
  LoadSavedSpeakerPathsEvent(this.paths);
}