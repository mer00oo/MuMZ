import 'package:record/record.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<void> startRecording(String path) async {
    if (await _recorder.hasPermission()) {
      await  _recorder.start(
  const RecordConfig(
    encoder: AudioEncoder.aacLc,
    sampleRate: 44100,
    bitRate: 192000, 
    numChannels: 1,
  ),
  path: path,
);
    }
  }

 Future<String?> stopRecording() async {
  if (await _recorder.isRecording()) {
    final path = await _recorder.stop();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return path;
  }
  return null;
}
  Future<bool> isRecording() async {
    return _recorder.isRecording();
  }

  void dispose() {
    _recorder.dispose();
  }
}
