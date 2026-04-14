import 'package:mamyapp/features/story_telling/domain/entities/story.dart';
import 'package:mamyapp/features/story_telling/domain/repositories/story_repository.dart';

class GetStoryById {
  final StoryRepository repository;

  GetStoryById(this.repository);

  Story call(int id) {
    return repository.getStoryById(id);
  }
}