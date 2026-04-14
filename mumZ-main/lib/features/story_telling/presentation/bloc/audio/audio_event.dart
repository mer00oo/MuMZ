abstract class AudioEvent {}

class SynthesizeStoryEvent extends AudioEvent {
  final String text;
  final List<String>? speakerPaths;
  final int storyId;

  SynthesizeStoryEvent({
    required this.text,
    this.speakerPaths,
     required this.storyId, // <-- لازم يتم تمريره
  });
}
