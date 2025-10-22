import 'package:reels_flutter/domain/entities/video_entity.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';

/// Use case for fetching videos from the repository.
///
/// This class encapsulates the business logic for retrieving videos.
/// It depends on the VideoRepository abstraction, not on concrete implementations.
///
/// In Clean Architecture, use cases represent application-specific business rules.
/// They orchestrate the flow of data between entities and the outside world.
class GetVideosUseCase {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  /// Executes the use case to fetch all videos.
  ///
  /// Returns a list of [VideoEntity] objects.
  /// Throws an exception if the operation fails.
  ///
  /// Future enhancements could include:
  /// - Pagination support
  /// - Filtering by category
  /// - Sorting options
  /// - Caching logic
  Future<List<VideoEntity>> call() async {
    return await repository.getVideos();
  }
}
