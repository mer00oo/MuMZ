import 'package:mamyapp/features/story_telling/domain/entities/story.dart';

abstract  class StoryRepository {
  Story getStoryById(int id);
}
