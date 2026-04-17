import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mamyapp/features/cry_prediction/data/datasources/cry_prediction_remote_datasource.dart';

part 'cry_prediction_event.dart';
part 'cry_prediction_state.dart';

class CryPredictionBloc extends Bloc<CryPredictionEvent, CryPredictionState> {
  final CryPredictionRemoteDatasource datasource;

  CryPredictionBloc({required this.datasource})
      : super(CryPredictionInitial()) {
    on<AnalyzeCryEvent>(_onAnalyze);
  }

  Future<void> _onAnalyze(
    AnalyzeCryEvent event,
    Emitter<CryPredictionState> emit,
  ) async {
    emit(CryPredictionLoading());
    try {
      final result = await datasource.predictCry(event.audioPath);
      emit(CryPredictionSuccess(result));
    } catch (e) {
      emit(CryPredictionFailure(e.toString()));
    }
  }
}