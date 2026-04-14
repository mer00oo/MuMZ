import 'package:hive/hive.dart';

class SpeakerLocalStorage {
  static const String _boxName = 'speaker_box';
  static const String _keyPaths = 'speaker_paths';

  Future<void> saveSpeakerPaths(List<String> paths) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_keyPaths, paths);
  }

  List<String>? getSpeakerPaths() {
    final box = Hive.box(_boxName);
    return box.get(_keyPaths)?.cast<String>();
  }
}
// core/storage/speaker_local_storage.dart
// import 'package:flutter/foundation.dart';
// import 'package:mamyapp/features/story_telling/data/local/db_helper.dart';

// class SpeakerLocalStorage {
//   // ✅ حفظ الـ paths في SQLite
//   Future<void> saveSpeakerPaths(List<String> paths) async {
//     try {
//       await RecordingDatabase.instance.insertSpeakerPaths(paths);
//       if (kDebugMode) {
//         print('💾 Saved ${paths.length} speaker paths to SQLite');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(' Error saving to SQLite: $e');
//       }
//       throw Exception('Failed to save speaker paths');
//     }
//   }

//   // ✅ جلب الـ paths من SQLite
//   Future<List<String>?> getSpeakerPaths() async {
//     try {
//       final paths = await RecordingDatabase.instance.getLatestSpeakerPaths();
//       if (kDebugMode) {
//         print(' Loaded ${paths.length} speaker paths from SQLite');
//       }
//       return paths.isEmpty ? null : paths;
//     } catch (e) {
//       if (kDebugMode) {
//         print(' Error loading from SQLite: $e');
//       }
//       return null;
//     }
//   }

//   Future<void> clearSpeakerPaths() async {
//     try {
//       await RecordingDatabase.instance.clearAllSpeakerPaths();
//       if (kDebugMode) {
//         print('🗑️ Cleared all speaker paths from SQLite');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(' Error clearing SQLite: $e');
//       }
//     }
//   }
// }