import 'package:reels_flutter/domain/entities/video_entity.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';

/// Use case for incrementing the share count of a video.
///
/// Encapsulates the business logic for sharing videos.
class IncrementShareCountUseCase {
  final VideoRepository repository;

  IncrementShareCountUseCase(this.repository);

  /// Executes the use case to increment share count.
  ///
  /// Returns the updated [VideoEntity] with incremented share count.
  /// Throws an exception if the operation fails.
  Future<VideoEntity> call(String videoId) async {
    if (videoId.isEmpty) {
      throw ArgumentError('Video ID cannot be empty');
    }
    return await repository.incrementShareCount(videoId);
  }
}
