part of 'cry_prediction_bloc.dart';

@immutable
sealed class CryPredictionEvent {}

class AnalyzeCryEvent extends CryPredictionEvent {
  final String audioPath;
  AnalyzeCryEvent(this.audioPath);
}