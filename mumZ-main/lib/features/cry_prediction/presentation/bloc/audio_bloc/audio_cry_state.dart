part of 'audio_cry_bloc.dart';

@immutable
sealed class  RecordCryState {}

class RecordCryInitial extends RecordCryState {}

class RecordCryRecording extends RecordCryState {}

class RecordCryStopped extends RecordCryState {
  final  AudioCryRecord record;
  RecordCryStopped(this.record);
}

class RecordCryReset extends RecordCryState {}

class RecordCryError extends RecordCryState {
  final String message;
  RecordCryError(this.message);
}