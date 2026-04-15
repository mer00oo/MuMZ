import 'package:mamyapp/features/cry_prediction/data/datasources/audio_cry_local_datasource.dart';
import 'package:mamyapp/features/cry_prediction/domain/repositories/audio_cry_repository.dart';

class AudioCryRepositoryImpl  implements AudioCryRepository{

  final AudioCryLocalDatasource  datasource;

  AudioCryRepositoryImpl( this.datasource);
  @override
  void dispose() {
    datasource.dispose();
  }

  @override
  Future<void> startRecording(String path) async {
    await datasource.startRecording(path);
  }

  @override
  Future<String?> stopRecording() async{
    return await datasource.stopRecording();

  }

}