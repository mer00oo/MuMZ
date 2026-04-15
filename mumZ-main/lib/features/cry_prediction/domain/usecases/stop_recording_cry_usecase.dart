import 'package:mamyapp/features/cry_prediction/domain/entities/audio_cry_record.dart';
import 'package:mamyapp/features/cry_prediction/domain/repositories/audio_cry_repository.dart';

class StopRecordingCryUsecase {
  final AudioCryRepository repository;

  StopRecordingCryUsecase(this.repository);
  Future<AudioCryRecord?> call ()async{
    final path = await repository.stopRecording();
    if(path==null) return null;
    return (AudioCryRecord(path: path));
  
    
  } 



}