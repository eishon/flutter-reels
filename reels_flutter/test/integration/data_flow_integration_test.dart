import 'package:reels_flutter/core/di/injection_container.dart';
import 'package:reels_flutter/data/datasources/video_local_data_source.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';
import 'package:reels_flutter/domain/usecases/get_video_by_id_usecase.dart';
import 'package:reels_flutter/domain/usecases/get_videos_usecase.dart';
import 'package:reels_flutter/domain/usecases/increment_share_count_usecase.dart';
import 'package:reels_flutter/domain/usecases/toggle_like_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

/// Integration tests for complete data flow through layers
///
/// These tests verify that all layers work together with real implementations:
/// - Dependency Injection initialization
/// - Data Source → Repository → Use Cases flow
/// - Real asset loading (mock_videos.json)
/// - End-to-end data transformations
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize dependency injection with real implementations
    await initializeDependencies();
  });

  tearDownAll(() async {
    // Clean up
    await resetDependencies();
  });

  group('Data Flow Integration Tests', () {
    group('dependency injection', () {
      test('should initialize all dependencies', () {
        // Assert - All dependencies should be registered
        expect(sl.isRegistered<VideoLocalDataSource>(), true);
        expect(sl.isRegistered<VideoRepository>(), true);
        expect(sl.isRegistered<GetVideosUseCase>(), true);
        expect(sl.isRegistered<GetVideoByIdUseCase>(), true);
        expect(sl.isRegistered<ToggleLikeUseCase>(), true);
        expect(sl.isRegistered<IncrementShareCountUseCase>(), true);
      });

      test('should resolve dependencies from container', () {
        // Act & Assert - Should be able to resolve all dependencies
        expect(() => sl<VideoLocalDataSource>(), returnsNormally);
        expect(() => sl<VideoRepository>(), returnsNormally);
        expect(() => sl<GetVideosUseCase>(), returnsNormally);
        expect(() => sl<GetVideoByIdUseCase>(), returnsNormally);
        expect(() => sl<ToggleLikeUseCase>(), returnsNormally);
        expect(() => sl<IncrementShareCountUseCase>(), returnsNormally);
      });

      test('should share repository singleton across use cases', () {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();
        final getVideoByIdUseCase = sl<GetVideoByIdUseCase>();
        final toggleLikeUseCase = sl<ToggleLikeUseCase>();
        final incrementShareUseCase = sl<IncrementShareCountUseCase>();

        // Assert - All should use same repository instance
        expect(
          identical(
              getVideosUseCase.repository, getVideoByIdUseCase.repository),
          true,
        );
        expect(
          identical(
              getVideoByIdUseCase.repository, toggleLikeUseCase.repository),
          true,
        );
        expect(
          identical(
              toggleLikeUseCase.repository, incrementShareUseCase.repository),
          true,
        );
      });
    });

    group('data source to repository flow', () {
      test('should load videos from asset through data source', () async {
        // Arrange
        final dataSource = sl<VideoLocalDataSource>();

        // Act
        final videos = await dataSource.getVideos();

        // Assert
        expect(videos, isNotEmpty);
        expect(videos, isList);
        expect(videos.first.id, isNotEmpty);
        expect(videos.first.title, isNotEmpty);
      });

      test('should load videos through repository', () async {
        // Arrange
        final repository = sl<VideoRepository>();

        // Act
        final videos = await repository.getVideos();

        // Assert
        expect(videos, isNotEmpty);
        expect(videos, isList);
        expect(videos.first.id, isNotEmpty);
        expect(videos.first.title, isNotEmpty);
      });

      test('should maintain data consistency between layers', () async {
        // Arrange
        final dataSource = sl<VideoLocalDataSource>();
        final repository = sl<VideoRepository>();

        // Act
        final sourceVideos = await dataSource.getVideos();
        final repoVideos = await repository.getVideos();

        // Assert - Should have same count
        expect(repoVideos.length, sourceVideos.length);

        // Should have same IDs
        expect(repoVideos.first.id, sourceVideos.first.id);
        expect(repoVideos.first.title, sourceVideos.first.title);
      });
    });

    group('use case to repository flow', () {
      test('should get videos through use case', () async {
        // Arrange
        final useCase = sl<GetVideosUseCase>();

        // Act
        final videos = await useCase();

        // Assert
        expect(videos, isNotEmpty);
        expect(videos, isList);
      });

      test('should get video by id through use case', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();
        final getVideoByIdUseCase = sl<GetVideoByIdUseCase>();

        // Get videos first to know valid IDs
        final videos = await getVideosUseCase();
        final firstVideoId = videos.first.id;

        // Act
        final video = await getVideoByIdUseCase(firstVideoId);

        // Assert
        expect(video, isNotNull);
        expect(video?.id, firstVideoId);
      });

      test('should toggle like through use case', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();
        final toggleLikeUseCase = sl<ToggleLikeUseCase>();

        final videos = await getVideosUseCase();
        final firstVideo = videos.first;
        final initialLikeStatus = firstVideo.isLiked;

        // Act
        final updatedVideo = await toggleLikeUseCase(firstVideo.id);

        // Assert
        expect(updatedVideo.id, firstVideo.id);
        expect(updatedVideo.isLiked, !initialLikeStatus);
      });

      test('should increment share count through use case', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();
        final incrementShareUseCase = sl<IncrementShareCountUseCase>();

        final videos = await getVideosUseCase();
        final firstVideo = videos.first;
        final initialShares = firstVideo.shares;

        // Act
        final updatedVideo = await incrementShareUseCase(firstVideo.id);

        // Assert
        expect(updatedVideo.id, firstVideo.id);
        expect(updatedVideo.shares, initialShares + 1);
      });
    });

    group('end-to-end data transformations', () {
      test('should transform data correctly from source to entity', () async {
        // Arrange
        final dataSource = sl<VideoLocalDataSource>();
        final repository = sl<VideoRepository>();

        // Act
        final sourceModel = (await dataSource.getVideos()).first;
        final repoEntity = (await repository.getVideos()).first;

        // Assert - Data should match
        expect(repoEntity.id, sourceModel.id);
        expect(repoEntity.title, sourceModel.title);
        expect(repoEntity.description, sourceModel.description);
        expect(repoEntity.likes, sourceModel.likes);
        expect(repoEntity.shares, sourceModel.shares);
        expect(repoEntity.comments, sourceModel.comments);
      });

      test('should maintain data integrity through full flow', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();

        // Act
        final videos1 = await getVideosUseCase();
        final videos2 = await getVideosUseCase();

        // Assert - Multiple calls should return consistent data
        expect(videos1.length, videos2.length);
        expect(videos1.first.id, videos2.first.id);
      });

      test('should handle products data through all layers', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();

        // Act
        final videos = await getVideosUseCase();
        final videosWithProducts = videos.where((v) => v.hasProducts).toList();

        // Assert
        if (videosWithProducts.isNotEmpty) {
          final video = videosWithProducts.first;
          expect(video.products, isNotEmpty);
          expect(video.productCount, greaterThan(0));
          expect(video.products.first.name, isNotEmpty);
          expect(video.products.first.price, greaterThan(0));
        }
      });

      test('should handle user data through all layers', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();

        // Act
        final videos = await getVideosUseCase();
        final firstVideo = videos.first;

        // Assert
        expect(firstVideo.user.name, isNotEmpty);
        expect(firstVideo.user.avatarUrl, isNotEmpty);
      });
    });

    group('state mutations', () {
      test('should apply like state within same session', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();
        final toggleLikeUseCase = sl<ToggleLikeUseCase>();

        final initialVideos = await getVideosUseCase();
        final videoId = initialVideos.first.id;
        final initialLikeStatus = initialVideos.first.isLiked;

        // Act - Toggle like
        final updatedVideo = await toggleLikeUseCase(videoId);

        // Assert - Like should be toggled in returned video
        expect(updatedVideo.isLiked, !initialLikeStatus);
        expect(updatedVideo.id, videoId);
      });

      test('should apply share count increment within same session', () async {
        // Arrange
        final incrementShareUseCase = sl<IncrementShareCountUseCase>();
        final getVideosUseCase = sl<GetVideosUseCase>();

        final initialVideos = await getVideosUseCase();
        final videoId = initialVideos.first.id;
        final initialShares = initialVideos.first.shares;

        // Act - Increment share
        final updatedVideo = await incrementShareUseCase(videoId);

        // Assert - Share count should be incremented in returned video
        expect(updatedVideo.shares, initialShares + 1);
        expect(updatedVideo.id, videoId);
      });

      test('should handle multiple mutations returning updated data', () async {
        // Arrange
        final getVideosUseCase = sl<GetVideosUseCase>();
        final toggleLikeUseCase = sl<ToggleLikeUseCase>();
        final incrementShareUseCase = sl<IncrementShareCountUseCase>();

        final initialVideos = await getVideosUseCase();
        final videoId = initialVideos.first.id;
        final initialShares = initialVideos.first.shares;
        final initialLikeStatus = initialVideos.first.isLiked;

        // Act - Multiple mutations
        final likedVideo = await toggleLikeUseCase(videoId);
        final sharedVideo1 = await incrementShareUseCase(videoId);
        final sharedVideo2 = await incrementShareUseCase(videoId);

        // Assert - Each mutation returns updated data
        expect(likedVideo.isLiked, !initialLikeStatus);
        expect(sharedVideo1.shares, greaterThan(initialShares));
        expect(sharedVideo2.shares, greaterThanOrEqualTo(sharedVideo1.shares));
      });
    });

    group('error handling', () {
      test('should handle invalid video ID gracefully', () async {
        // Arrange
        final getVideoByIdUseCase = sl<GetVideoByIdUseCase>();

        // Act
        final result = await getVideoByIdUseCase('invalid-id-12345');

        // Assert
        expect(result, isNull);
      });

      test('should handle toggle like on invalid ID', () async {
        // Arrange
        final toggleLikeUseCase = sl<ToggleLikeUseCase>();

        // Act & Assert - Should throw or handle gracefully
        expect(
          () => toggleLikeUseCase('invalid-id-12345'),
          throwsException,
        );
      });

      test('should handle increment share on invalid ID', () async {
        // Arrange
        final incrementShareUseCase = sl<IncrementShareCountUseCase>();

        // Act & Assert - Should throw or handle gracefully
        expect(
          () => incrementShareUseCase('invalid-id-12345'),
          throwsException,
        );
      });
    });
  });
}
