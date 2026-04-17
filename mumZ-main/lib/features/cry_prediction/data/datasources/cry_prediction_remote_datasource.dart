import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CryPredictionResult {
  final String prediction;
  final double confidence;
  final bool isUnknown;
  final String confidenceLevel;
  final List<String> recommendations;

  CryPredictionResult({
    required this.prediction,
    required this.confidence,
    required this.isUnknown,
    required this.confidenceLevel,
    required this.recommendations,
  });

  factory CryPredictionResult.fromJson(Map<String, dynamic> json) {
    return CryPredictionResult(
      prediction: json['prediction'] ?? 'unknown',
      confidence: (json['confidence'] as num).toDouble(),
      isUnknown: json['is_unknown'] ?? true,
      confidenceLevel: json['confidence_level'] ?? 'LOW',
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class CryPredictionRemoteDatasource {
  static const String _baseUrl = "http://10.0.2.2:8000";

  Future<CryPredictionResult> predictCry(String audioPath) async {
    try {
      final file = File(audioPath);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/predict'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CryPredictionResult.fromJson(json);
      } else {
        throw Exception('failed  : ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('isusee in  connection to server . Please check your internet connection and try again.');
    } catch (e) {
      throw Exception('حدث خطأ: $e');
    }
  }

  Future<Map<String, dynamic>> assessHunger(
      Map<String, String> answers) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/assess-hunger'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(answers),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(' failed');
    }
  }
}