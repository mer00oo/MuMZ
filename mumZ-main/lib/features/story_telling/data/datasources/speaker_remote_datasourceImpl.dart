import 'package:mamyapp/features/story_telling/data/datasources/speaker_remote_datasource.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mamyapp/features/story_telling/data/models/speaker_upload_model.dart';

class SpeakerRemoteDatasourceImpl implements SpeakerRemoteDatasource {
  final http.Client client;
  final String baseUrl;

  SpeakerRemoteDatasourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<SpeakerUploadModel> upload({
    required List<String> filePaths,
  }) async {
    final uri = Uri.parse('$baseUrl/upload_speakers');
    final request = http.MultipartRequest('POST', uri);

    for (final path in filePaths) {
      request.files.add(
        await http.MultipartFile.fromPath('files', path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final jsonMap = json.decode(response.body);

    if (response.statusCode != 200 || jsonMap['ok'] != true) {
      throw Exception('Upload speakers failed');
    }

    return SpeakerUploadModel.fromJson(jsonMap);
  }
}



