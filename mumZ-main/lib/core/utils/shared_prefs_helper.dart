import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveAudioUrl(String storyId, String audioUrl) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('audio_url_$storyId', audioUrl);
}



Future<String?> getSavedAudioUrl(String storyId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('audio_url_$storyId');
}
