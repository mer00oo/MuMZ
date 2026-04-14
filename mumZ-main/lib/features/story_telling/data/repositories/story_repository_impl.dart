import 'package:mamyapp/features/story_telling/data/datasources/story_local_data.dart';
import 'package:mamyapp/features/story_telling/domain/entities/story.dart';
import 'package:mamyapp/features/story_telling/domain/repositories/story_repository.dart';

class StoryRepositoryImpl  implements StoryRepository {
  @override
  Story getStoryById(int id) {
    return StoryLocalData.stories.firstWhere(
      (story) => story.id == id,
    );
  }


}