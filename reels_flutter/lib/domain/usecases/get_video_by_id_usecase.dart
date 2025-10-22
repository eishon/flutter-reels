import 'package:reels_flutter/domain/entities/video_entity.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';

/// Use case for fetching a single video by its ID.
///
/// Encapsulates the business logic for retrieving a specific video.
class GetVideoByIdUseCase {
  final VideoRepository repository;

  GetVideoByIdUseCase(this.repository);

  /// Executes the use case to fetch a video by ID.
  ///
  /// Returns a [VideoEntity] if found, null otherwise.
  /// Throws an exception if the operation fails.
  Future<VideoEntity?> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Video ID cannot be empty');
    }
    return await repository.getVideoById(id);
  }
}
