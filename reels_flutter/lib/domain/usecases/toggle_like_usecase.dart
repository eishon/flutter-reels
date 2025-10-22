import 'package:reels_flutter/domain/entities/video_entity.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';

/// Use case for toggling the like status of a video.
///
/// Encapsulates the business logic for liking/unliking videos.
class ToggleLikeUseCase {
  final VideoRepository repository;

  ToggleLikeUseCase(this.repository);

  /// Executes the use case to toggle like on a video.
  ///
  /// Returns the updated [VideoEntity] with new like status.
  /// Throws an exception if the operation fails.
  Future<VideoEntity> call(String videoId) async {
    if (videoId.isEmpty) {
      throw ArgumentError('Video ID cannot be empty');
    }
    return await repository.toggleLike(videoId);
  }
}
