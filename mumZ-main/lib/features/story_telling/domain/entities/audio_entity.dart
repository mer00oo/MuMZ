class AudioEntity {
  final String audioUrl;
  final String originalText;
  final String? diacritizedText;

  AudioEntity({
    required this.audioUrl,
    required this.originalText,
    this.diacritizedText,
  });
}
