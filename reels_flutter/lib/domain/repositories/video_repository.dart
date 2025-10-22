import 'package:reels_flutter/domain/entities/video_entity.dart';

/// Repository interface that defines the contract for video data operations.
///
/// This is part of the domain layer and contains no implementation details.
/// The data layer will provide the concrete implementation of this interface.
///
/// Following the Dependency Inversion Principle: high-level modules (use cases)
/// depend on abstractions (this interface), not on concrete implementations.
abstract class VideoRepository {
  /// Fetches a list of videos.
  ///
  /// Returns a list of [VideoEntity] objects on success.
  /// Throws an exception if the operation fails.
  ///
  /// The actual data source (local, remote, cache) is determined by
  /// the concrete implementation in the data layer.
  Future<List<VideoEntity>> getVideos();

  /// Fetches a single video by its ID.
  ///
  /// Returns a [VideoEntity] if found.
  /// Returns null if no video with the given [id] exists.
  /// Throws an exception if the operation fails.
  Future<VideoEntity?> getVideoById(String id);

  /// Toggles the like status of a video.
  ///
  /// Returns the updated [VideoEntity] with the new like status and count.
  /// Throws an exception if the operation fails.
  Future<VideoEntity> toggleLike(String videoId);

  /// Increments the share count for a video.
  ///
  /// Returns the updated [VideoEntity] with the incremented share count.
  /// Throws an exception if the operation fails.
  Future<VideoEntity> incrementShareCount(String videoId);
}
