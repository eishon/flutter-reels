import 'package:reels_flutter/data/datasources/video_local_data_source.dart';
import 'package:reels_flutter/domain/entities/video_entity.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';

/// Concrete implementation of VideoRepository.
///
/// This class implements the repository interface defined in the domain layer
/// and uses the VideoLocalDataSource to fetch data from assets.
///
/// Following the Repository pattern:
/// - Abstracts data source details from business logic
/// - Can easily switch between local/remote data sources
/// - Converts data models to domain entities
class VideoRepositoryImpl implements VideoRepository {
  final VideoLocalDataSource localDataSource;

  VideoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<VideoEntity>> getVideos() async {
    try {
      final videoModels = await localDataSource.getVideos();
      // Convert models to entities
      return videoModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get videos: $e');
    }
  }

  @override
  Future<VideoEntity?> getVideoById(String id) async {
    try {
      final videoModel = await localDataSource.getVideoById(id);
      return videoModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get video by ID: $e');
    }
  }

  @override
  Future<VideoEntity> toggleLike(String videoId) async {
    try {
      final videoModel = await localDataSource.toggleLike(videoId);
      return videoModel.toEntity();
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  @override
  Future<VideoEntity> incrementShareCount(String videoId) async {
    try {
      final videoModel = await localDataSource.incrementShareCount(videoId);
      return videoModel.toEntity();
    } catch (e) {
      throw Exception('Failed to increment share count: $e');
    }
  }
}
