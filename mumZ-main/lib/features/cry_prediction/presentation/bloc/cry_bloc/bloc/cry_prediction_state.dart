part of 'cry_prediction_bloc.dart';

@immutable
sealed class CryPredictionState {}

class CryPredictionInitial extends CryPredictionState {}

class CryPredictionLoading extends CryPredictionState {}

class CryPredictionSuccess extends CryPredictionState {
  final CryPredictionResult result;
  CryPredictionSuccess(this.result);
}

class CryPredictionFailure extends CryPredictionState {
  final String message;
  CryPredictionFailure(this.message);
}