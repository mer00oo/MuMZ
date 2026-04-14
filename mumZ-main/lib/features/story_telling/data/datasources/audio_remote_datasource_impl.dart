import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/audio_model.dart';
import 'audio_remote_datasource.dart';

class AudioRemoteDatasourceImpl implements AudioRemoteDatasource {
  final http.Client client;
  final String baseUrl;

  AudioRemoteDatasourceImpl({required this.client, required this.baseUrl});

  @override
  Future<AudioModel> synthesize({
    required String text,
    required String mode,
    List<String>? speakerPaths,
    required bool useDiacritization,
  }) async {
    final response = await client.post(
  Uri.parse('$baseUrl/synthesize'),
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: {
    'text': text,
    'mode': mode,
    'use_diacritization': useDiacritization.toString(),
    if (speakerPaths != null && speakerPaths.isNotEmpty)
      'speaker_paths': speakerPaths.join(','),
  },
);

if (kDebugMode) {
  print('SYNTHESIZE RESPONSE => ${response.body}');
}

if (response.statusCode != 200) {
  throw Exception('XTTS synthesis failed');
}

final jsonMap = json.decode(response.body);
jsonMap['audio_url'] = '$baseUrl${jsonMap['audio_url']}';

return AudioModel.fromJson(jsonMap);
  }
}
