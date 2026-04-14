// features/story_telling/data/repositories/speaker_repository_impl.dart
import 'package:flutter/foundation.dart';
import 'package:mamyapp/core/storage/speaker_local_storage.dart';
import 'package:mamyapp/features/story_telling/data/datasources/speaker_remote_datasource.dart';
import 'package:mamyapp/features/story_telling/domain/entities/speaker_upload_entity.dart';
import 'package:mamyapp/features/story_telling/domain/repositories/speaker_repository.dart';

class SpeakerRepositoryImpl implements SpeakerRepository {
  final SpeakerRemoteDatasource remote;
  final SpeakerLocalStorage local;

  SpeakerRepositoryImpl(this.remote, this.local);

  @override
  Future<SpeakerEntity> uploadSpeakers({required List<String> filePaths}) async {
    // 1️⃣ رفع الملفات للسيرفر
    final model = await remote.upload(filePaths: filePaths);
    
    // 2️⃣ حفظ الـ paths اللي راجعة من السيرفر في SQLite
    await local.saveSpeakerPaths(model.paths);
    
    if (kDebugMode) {
      print('✅ Uploaded and saved ${model.paths.length} speaker paths');
    }
    
    return model.toEntity();
  }

  @override
  Future<void> saveSpeakerPaths(List<String> paths) async {
    await local.saveSpeakerPaths(paths);
  }

  @override
  Future<List<String>?> getSpeakerPaths() async {
    return await local.getSpeakerPaths();
  }
}