import 'package:mamyapp/features/cry_prediction/domain/repositories/audio_cry_repository.dart';
import 'package:path_provider/path_provider.dart';

class StartRecordingCryUsecase {
  final AudioCryRepository repository;

  StartRecordingCryUsecase(  this.repository);

  Future <void> call() async{
   final directory =await getApplicationDocumentsDirectory();
   final path=  '${directory.path}/cry_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await repository.startRecording(path);
  }
}