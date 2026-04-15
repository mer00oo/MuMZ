import 'package:bloc/bloc.dart';
import 'package:mamyapp/features/cry_prediction/domain/entities/audio_cry_record.dart';
import 'package:mamyapp/features/cry_prediction/domain/usecases/start_recording_cry_usecase.dart';
import 'package:mamyapp/features/cry_prediction/domain/usecases/stop_recording_cry_usecase.dart';
import 'package:meta/meta.dart';

part 'audio_cry_event.dart';
part 'audio_cry_state.dart';

class RecordCryBloc extends Bloc<RecordCryEvent, RecordCryState> {
  final StartRecordingCryUsecase startRecordingCryUsecase;
  final StopRecordingCryUsecase stopRecordingCryUsecase;
  RecordCryBloc({
    required this.startRecordingCryUsecase,
    required this.stopRecordingCryUsecase,
  }) : super(RecordCryInitial()) {


    on<ToggleRecordingEvent>(_onToggleRecording);

    on<ResetRecordingEvent>(_onReset);

  }

  Future<void> _onToggleRecording( ToggleRecordingEvent event,
    Emitter<RecordCryState> emit)
    async {

      if (state is RecordCryRecording) {
        try {
          final record= await stopRecordingCryUsecase();
          if(record!=null){
            emit(RecordCryStopped(record));
          }else{
            emit(RecordCryError("Failed to stop recording"));
          }
       } catch (e) {
          emit(RecordCryError(e.toString()));
        }
      } else {
        try {
          await startRecordingCryUsecase();
          emit(RecordCryRecording());
        } catch (e) {
          emit(RecordCryError(e.toString()));
        }
      }
   
     }


 void _onReset(ResetRecordingEvent event, Emitter<RecordCryState> emit) {
    emit(RecordCryInitial());
  }
}

