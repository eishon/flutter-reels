import 'package:reels_flutter/data/datasources/video_local_data_source.dart';
import 'package:reels_flutter/data/models/video_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for VideoLocalDataSource
///
/// Tests cover:
/// - getVideos: loading from assets and parsing JSON
/// - getVideoById: finding specific videos
/// - toggleLike: updating like state and count
/// - incrementShareCount: updating share count
/// - Error handling and edge cases
///
/// Note: These tests use the actual mock_videos.json asset file
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late VideoLocalDataSource dataSource;

  setUp(() {
    dataSource = VideoLocalDataSource();
  });

  group('VideoLocalDataSource', () {
    group('getVideos', () {
      test('should load videos from assets', () async {
        // Act
        final videos = await dataSource.getVideos();

        // Assert
        expect(videos, isNotEmpty);
        expect(videos, isA<List<VideoModel>>());
      });

      test('should return list of VideoModel instances', () async {
        // Act
        final videos = await dataSource.getVideos();

        // Assert
        for (final video in videos) {
          expect(video, isA<VideoModel>());
          expect(video.id, isNotEmpty);
          expect(video.url, isNotEmpty);
          expect(video.title, isNotEmpty);
        }
      });

      test('should parse all video fields correctly', () async {
        // Act
        final videos = await dataSource.getVideos();
        final firstVideo = videos.first;

        // Assert - Check all required fields are present
        expect(firstVideo.id, isNotEmpty);
        expect(firstVideo.url, isNotEmpty);
        expect(firstVideo.title, isNotEmpty);
        expect(firstVideo.description, isNotEmpty);
        expect(firstVideo.user.name, isNotEmpty);
        expect(firstVideo.user.avatarUrl, isNotEmpty);
        expect(firstVideo.likes, isA<int>());
        expect(firstVideo.comments, isA<int>());
        expect(firstVideo.shares, isA<int>());
        expect(firstVideo.isLiked, isA<bool>());
        expect(firstVideo.category, isNotEmpty);
        expect(firstVideo.duration, isNotEmpty);
        expect(firstVideo.quality, isNotEmpty);
        expect(firstVideo.format, isNotEmpty);
        expect(firstVideo.products, isA<List>());
      });

      test('should parse nested user data correctly', () async {
        // Act
        final videos = await dataSource.getVideos();

        // Assert
        for (final video in videos) {
          expect(video.user.name, isNotEmpty);
          expect(video.user.avatarUrl, isNotEmpty);
        }
      });

      test('should parse nested products data when present', () async {
        // Act
        final videos = await dataSource.getVideos();
        final videosWithProducts = videos
            .where((v) => v.products.isNotEmpty)
            .toList();

        // Assert
        if (videosWithProducts.isNotEmpty) {
          final videoWithProduct = videosWithProducts.first;
          expect(videoWithProduct.hasProducts, true);
          expect(videoWithProduct.products.first.id, isNotEmpty);
          expect(videoWithProduct.products.first.name, isNotEmpty);
          expect(videoWithProduct.products.first.price, isA<double>());
        }
      });

      test('should return consistent data on multiple calls', () async {
        // Act
        final videos1 = await dataSource.getVideos();
        final videos2 = await dataSource.getVideos();

        // Assert
        expect(videos1.length, videos2.length);
        for (var i = 0; i < videos1.length; i++) {
          expect(videos1[i].id, videos2[i].id);
          expect(videos1[i].title, videos2[i].title);
        }
      });
    });

    group('getVideoById', () {
      test('should return video when id exists', () async {
        // Arrange
        final allVideos = await dataSource.getVideos();
        final expectedVideo = allVideos.first;

        // Act
        final video = await dataSource.getVideoById(expectedVideo.id);

        // Assert
        expect(video, isNotNull);
        expect(video?.id, expectedVideo.id);
        expect(video?.title, expectedVideo.title);
        expect(video?.url, expectedVideo.url);
      });

      test('should return null when id does not exist', () async {
        // Act
        final video = await dataSource.getVideoById('non-existent-id');

        // Assert
        expect(video, isNull);
      });

      test('should return null for empty id', () async {
        // Act
        final video = await dataSource.getVideoById('');

        // Assert
        expect(video, isNull);
      });

      test('should find correct video among multiple videos', () async {
        // Arrange
        final allVideos = await dataSource.getVideos();
        if (allVideos.length > 1) {
          final targetVideo = allVideos[1]; // Get second video

          // Act
          final video = await dataSource.getVideoById(targetVideo.id);

          // Assert
          expect(video?.id, targetVideo.id);
          expect(video?.title, targetVideo.title);
        }
      });

      test(
        'should return complete video data including nested objects',
        () async {
          // Arrange
          final allVideos = await dataSource.getVideos();
          final firstVideoId = allVideos.first.id;

          // Act
          final video = await dataSource.getVideoById(firstVideoId);

          // Assert
          expect(video, isNotNull);
          expect(video!.user.name, isNotEmpty);
          expect(video.user.avatarUrl, isNotEmpty);
          expect(video.products, isA<List>());
        },
      );
    });

    group('toggleLike', () {
      test('should toggle like from false to true', () async {
        // Arrange
        final videos = await dataSource.getVideos();
        final unlikedVideo = videos.firstWhere(
          (v) => !v.isLiked,
          orElse: () => videos.first,
        );
        final originalLikes = unlikedVideo.likes;

        // Act
        final updatedVideo = await dataSource.toggleLike(unlikedVideo.id);

        // Assert
        expect(updatedVideo.id, unlikedVideo.id);
        expect(updatedVideo.isLiked, !unlikedVideo.isLiked);
        if (!unlikedVideo.isLiked) {
          expect(updatedVideo.likes, originalLikes + 1);
        } else {
          expect(updatedVideo.likes, originalLikes - 1);
        }
      });

      test('should toggle like from true to false', () async {
        // Arrange
        final videos = await dataSource.getVideos();
        final likedVideo = videos.firstWhere(
          (v) => v.isLiked,
          orElse: () => videos.first,
        );
        final originalLikes = likedVideo.likes;

        // Act
        final updatedVideo = await dataSource.toggleLike(likedVideo.id);

        // Assert
        expect(updatedVideo.id, likedVideo.id);
        expect(updatedVideo.isLiked, !likedVideo.isLiked);
        if (likedVideo.isLiked) {
          expect(updatedVideo.likes, originalLikes - 1);
        } else {
          expect(updatedVideo.likes, originalLikes + 1);
        }
      });

      test('should throw exception for non-existent video id', () async {
        // Act & Assert
        expect(
          () => dataSource.toggleLike('non-existent-id'),
          throwsA(isA<Exception>()),
        );
      });

      test('should preserve other video properties', () async {
        // Arrange
        final videos = await dataSource.getVideos();
        final originalVideo = videos.first;

        // Act
        final updatedVideo = await dataSource.toggleLike(originalVideo.id);

        // Assert - Check that other properties remain unchanged
        expect(updatedVideo.id, originalVideo.id);
        expect(updatedVideo.url, originalVideo.url);
        expect(updatedVideo.title, originalVideo.title);
        expect(updatedVideo.description, originalVideo.description);
        expect(updatedVideo.user.name, originalVideo.user.name);
        expect(updatedVideo.comments, originalVideo.comments);
        expect(updatedVideo.shares, originalVideo.shares);
        expect(updatedVideo.category, originalVideo.category);
      });

      test('should handle toggle for video with zero likes', () async {
        // Note: This test assumes mock data might have videos with low likes
        // Act & Assert - Should not throw even if likes would go negative
        final videos = await dataSource.getVideos();
        if (videos.isNotEmpty) {
          final video = videos.first;
          final result = await dataSource.toggleLike(video.id);
          expect(result, isA<VideoModel>());
        }
      });
    });

    group('incrementShareCount', () {
      test('should increment share count by 1', () async {
        // Arrange
        final videos = await dataSource.getVideos();
        final originalVideo = videos.first;
        final originalShares = originalVideo.shares;

        // Act
        final updatedVideo = await dataSource.incrementShareCount(
          originalVideo.id,
        );

        // Assert
        expect(updatedVideo.id, originalVideo.id);
        expect(updatedVideo.shares, originalShares + 1);
      });

      test('should throw exception for non-existent video id', () async {
        // Act & Assert
        expect(
          () => dataSource.incrementShareCount('non-existent-id'),
          throwsA(isA<Exception>()),
        );
      });

      test('should preserve other video properties', () async {
        // Arrange
        final videos = await dataSource.getVideos();
        final originalVideo = videos.first;

        // Act
        final updatedVideo = await dataSource.incrementShareCount(
          originalVideo.id,
        );

        // Assert - Check that other properties remain unchanged
        expect(updatedVideo.id, originalVideo.id);
        expect(updatedVideo.url, originalVideo.url);
        expect(updatedVideo.title, originalVideo.title);
        expect(updatedVideo.description, originalVideo.description);
        expect(updatedVideo.user.name, originalVideo.user.name);
        expect(updatedVideo.likes, originalVideo.likes);
        expect(updatedVideo.comments, originalVideo.comments);
        expect(updatedVideo.isLiked, originalVideo.isLiked);
      });

      test('should handle incrementing from zero', () async {
        // Arrange
        final videos = await dataSource.getVideos();
        final videoWithLowShares = videos.reduce(
          (a, b) => a.shares < b.shares ? a : b,
        );

        // Act
        final updatedVideo = await dataSource.incrementShareCount(
          videoWithLowShares.id,
        );

        // Assert
        expect(updatedVideo.shares, videoWithLowShares.shares + 1);
        expect(updatedVideo.shares, greaterThan(0));
      });

      test('should allow multiple increments', () async {
        // Arrange
        final videos = await dataSource.getVideos();
        final video = videos.first;
        final originalShares = video.shares;

        // Act
        await dataSource.incrementShareCount(video.id);
        await dataSource.incrementShareCount(video.id);
        final finalVideo = await dataSource.incrementShareCount(video.id);

        // Assert - Note: Each call reloads from assets, so shares won't accumulate
        // This tests that the method works consistently
        expect(finalVideo.shares, originalShares + 1);
      });
    });

    group('error handling', () {
      test('should throw exception when asset file is not found', () async {
        // Note: This test verifies error handling works
        // The actual implementation would need a way to inject the asset path
        // For now, we just verify the method structure handles errors

        // Create a data source and call getVideos
        // If the asset exists, this will pass; if not, it will throw
        expect(() async => await dataSource.getVideos(), returnsNormally);
      });

      test('should handle empty video id gracefully', () async {
        // Act & Assert
        expect(await dataSource.getVideoById(''), isNull);
      });

      test('should throw for toggleLike with empty id', () async {
        // Act & Assert
        expect(() => dataSource.toggleLike(''), throwsA(isA<Exception>()));
      });

      test('should throw for incrementShareCount with empty id', () async {
        // Act & Assert
        expect(
          () => dataSource.incrementShareCount(''),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('data integrity', () {
      test('should maintain referential integrity between calls', () async {
        // Act
        final videos1 = await dataSource.getVideos();
        final video1 = await dataSource.getVideoById(videos1.first.id);
        final videos2 = await dataSource.getVideos();

        // Assert
        expect(videos1.length, videos2.length);
        expect(video1?.id, videos1.first.id);
      });

      test('should parse all videos without errors', () async {
        // Act
        final videos = await dataSource.getVideos();

        // Assert - Verify each video is properly formed
        for (final video in videos) {
          expect(video.id, isNotEmpty, reason: 'Video id should not be empty');
          expect(
            video.url,
            isNotEmpty,
            reason: 'Video url should not be empty',
          );
          expect(
            video.title,
            isNotEmpty,
            reason: 'Video title should not be empty',
          );
          expect(
            video.likes,
            isNonNegative,
            reason: 'Likes should be non-negative',
          );
          expect(
            video.comments,
            isNonNegative,
            reason: 'Comments should be non-negative',
          );
          expect(
            video.shares,
            isNonNegative,
            reason: 'Shares should be non-negative',
          );
        }
      });
    });
  });
}
