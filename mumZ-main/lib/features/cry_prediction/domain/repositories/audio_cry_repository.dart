import 'dart:async';
import 'dart:core';

abstract class AudioCryRepository {
  Future<void> startRecording(String path);
  Future <String?> stopRecording();
    void dispose();

}