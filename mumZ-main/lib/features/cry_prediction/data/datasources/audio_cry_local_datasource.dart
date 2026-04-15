import 'package:mamyapp/services/audio_recorder_service.dart';

abstract class AudioCryLocalDatasource {

  Future <void> startRecording( String path);
    Future<String?> stopRecording();
  void dispose();

}


class  AudioCryLocalDatasourceImpl implements AudioCryLocalDatasource{
  final AudioRecorderService _recorderService= AudioRecorderService();
  
  @override
  void dispose() {
    _recorderService.dispose();
  }
  
  @override
  Future<void> startRecording(String path) async{
        await _recorderService.startRecording(path);

  }
  
  @override
  Future<String?> stopRecording() async{
    return await _recorderService.stopRecording();
  }
}