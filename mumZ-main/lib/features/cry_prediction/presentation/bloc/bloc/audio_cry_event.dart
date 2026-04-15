part of 'audio_cry_bloc.dart';

@immutable
sealed class RecordCryEvent {}

class ToggleRecordingEvent extends RecordCryEvent {}

class SendRecordingEvent extends RecordCryEvent {}

class ResetRecordingEvent extends RecordCryEvent {}