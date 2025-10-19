import 'package:flutter_reels/presentation/providers/video_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.dart';
import '../../../helpers/test_mocks.mocks.dart';

/// Unit tests for VideoProvider
///
/// Tests focus on:
/// - State management and changes
/// - Loading videos with different scenarios
/// - Error handling
/// - User interactions (like, share)
/// - Listener notifications
void main() {
  late VideoProvider provider;
  late MockGetVideosUseCase mockGetVideosUseCase;
  late MockToggleLikeUseCase mockToggleLikeUseCase;
  late MockIncrementShareCountUseCase mockIncrementShareCountUseCase;

  setUp(() {
    mockGetVideosUseCase = MockGetVideosUseCase();
    mockToggleLikeUseCase = MockToggleLikeUseCase();
    mockIncrementShareCountUseCase = MockIncrementShareCountUseCase();

    provider = VideoProvider(
      getVideosUseCase: mockGetVideosUseCase,
      toggleLikeUseCase: mockToggleLikeUseCase,
      incrementShareCountUseCase: mockIncrementShareCountUseCase,
    );
  });

  group('VideoProvider', () {
    group('initial state', () {
      test('should have empty videos list initially', () {
        expect(provider.videos, isEmpty);
        expect(provider.hasVideos, false);
      });

      test('should not be loading initially', () {
        expect(provider.isLoading, false);
      });

      test('should have no error initially', () {
        expect(provider.errorMessage, isNull);
        expect(provider.hasError, false);
      });
    });

    group('loadVideos', () {
      test('should set loading state before fetching', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 3);
        when(mockGetVideosUseCase()).thenAnswer((_) async {
          // Verify loading state is set before this completes
          return testVideos;
        });

        // Act
        final future = provider.loadVideos();

        // Assert - check loading state immediately
        expect(provider.isLoading, true);
        expect(provider.errorMessage, isNull);

        await future;
      });

      test('should load videos successfully and update state', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 3);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);

        // Act
        await provider.loadVideos();

        // Assert
        expect(provider.videos, testVideos);
        expect(provider.videos.length, 3);
        expect(provider.isLoading, false);
        expect(provider.hasVideos, true);
        expect(provider.errorMessage, isNull);
        verify(mockGetVideosUseCase()).called(1);
      });

      test('should handle empty video list', () async {
        // Arrange
        when(mockGetVideosUseCase()).thenAnswer((_) async => []);

        // Act
        await provider.loadVideos();

        // Assert
        expect(provider.videos, isEmpty);
        expect(provider.hasVideos, false);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, isNull);
      });

      test('should handle errors and set error message', () async {
        // Arrange
        when(mockGetVideosUseCase()).thenThrow(Exception('Network error'));

        // Act
        await provider.loadVideos();

        // Assert
        expect(provider.videos, isEmpty);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, isNotNull);
        expect(provider.errorMessage, contains('Failed to load videos'));
        expect(provider.hasError, true);
      });

      test('should clear previous error on new load', () async {
        // Arrange - first load fails
        when(mockGetVideosUseCase()).thenThrow(Exception('Error'));
        await provider.loadVideos();
        expect(provider.hasError, true);

        // Arrange - second load succeeds
        final testVideos = createTestVideoList(count: 2);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);

        // Act
        await provider.loadVideos();

        // Assert
        expect(provider.errorMessage, isNull);
        expect(provider.hasError, false);
        expect(provider.videos.length, 2);
      });

      test('should notify listeners on successful load', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 1);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);

        int notificationCount = 0;
        provider.addListener(() => notificationCount++);

        // Act
        await provider.loadVideos();

        // Assert - should notify at least twice (start loading, finished loading)
        expect(notificationCount, greaterThanOrEqualTo(2));
      });

      test('should notify listeners on error', () async {
        // Arrange
        when(mockGetVideosUseCase()).thenThrow(Exception('Error'));

        int notificationCount = 0;
        provider.addListener(() => notificationCount++);

        // Act
        await provider.loadVideos();

        // Assert - should notify at least twice
        expect(notificationCount, greaterThanOrEqualTo(2));
      });
    });

    group('toggleLike', () {
      test('should toggle like and update video in list', () async {
        // Arrange - load initial videos
        final testVideos = createTestVideoList(count: 3);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final videoId = testVideos[0].id;
        final updatedVideo = testVideos[0].copyWith(
          isLiked: !testVideos[0].isLiked,
          likes: testVideos[0].likes + 1,
        );
        when(mockToggleLikeUseCase(videoId))
            .thenAnswer((_) async => updatedVideo);

        // Act
        await provider.toggleLike(videoId);

        // Assert
        expect(provider.videos[0].isLiked, updatedVideo.isLiked);
        expect(provider.videos[0].likes, updatedVideo.likes);
        verify(mockToggleLikeUseCase(videoId)).called(1);
      });

      test('should notify listeners when like is toggled', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 1);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final videoId = testVideos[0].id;
        final updatedVideo = testVideos[0].copyWith(isLiked: true);
        when(mockToggleLikeUseCase(videoId))
            .thenAnswer((_) async => updatedVideo);

        int notificationCount = 0;
        provider.addListener(() => notificationCount++);

        // Act
        await provider.toggleLike(videoId);

        // Assert
        expect(notificationCount, greaterThanOrEqualTo(1));
      });

      test('should handle toggle like error gracefully', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 1);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final videoId = testVideos[0].id;
        when(mockToggleLikeUseCase(videoId))
            .thenThrow(Exception('Failed to like'));

        // Act - should not throw
        await provider.toggleLike(videoId);

        // Assert - video list should remain unchanged
        expect(provider.videos, testVideos);
      });

      test('should not update if video not found in list', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 2);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final nonExistentId = 'non-existent-id';
        final updatedVideo = createTestVideo(id: nonExistentId);
        when(mockToggleLikeUseCase(nonExistentId))
            .thenAnswer((_) async => updatedVideo);

        // Act
        await provider.toggleLike(nonExistentId);

        // Assert - list should remain unchanged
        expect(provider.videos.length, 2);
        expect(provider.videos, testVideos);
      });
    });

    group('shareVideo', () {
      test('should increment share count and update video in list', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 2);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final videoId = testVideos[1].id;
        final updatedVideo = testVideos[1].copyWith(
          shares: testVideos[1].shares + 1,
        );
        when(mockIncrementShareCountUseCase(videoId))
            .thenAnswer((_) async => updatedVideo);

        // Act
        await provider.shareVideo(videoId);

        // Assert
        expect(provider.videos[1].shares, updatedVideo.shares);
        verify(mockIncrementShareCountUseCase(videoId)).called(1);
      });

      test('should notify listeners when share count incremented', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 1);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final videoId = testVideos[0].id;
        final updatedVideo = testVideos[0].copyWith(shares: 100);
        when(mockIncrementShareCountUseCase(videoId))
            .thenAnswer((_) async => updatedVideo);

        int notificationCount = 0;
        provider.addListener(() => notificationCount++);

        // Act
        await provider.shareVideo(videoId);

        // Assert
        expect(notificationCount, greaterThanOrEqualTo(1));
      });

      test('should handle share error gracefully', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 1);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final videoId = testVideos[0].id;
        when(mockIncrementShareCountUseCase(videoId))
            .thenThrow(Exception('Failed to share'));

        // Act - should not throw
        await provider.shareVideo(videoId);

        // Assert - video list should remain unchanged
        expect(provider.videos, testVideos);
      });

      test('should not update if video not found in list', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 2);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final nonExistentId = 'non-existent-id';
        final updatedVideo = createTestVideo(id: nonExistentId);
        when(mockIncrementShareCountUseCase(nonExistentId))
            .thenAnswer((_) async => updatedVideo);

        // Act
        await provider.shareVideo(nonExistentId);

        // Assert - list should remain unchanged
        expect(provider.videos.length, 2);
        expect(provider.videos, testVideos);
      });
    });

    group('refresh', () {
      test('should reload videos', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 2);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);

        // Act
        await provider.refresh();

        // Assert
        expect(provider.videos, testVideos);
        verify(mockGetVideosUseCase()).called(1);
      });

      test('should clear old data and load fresh data', () async {
        // Arrange - load initial data
        final initialVideos = createTestVideoList(count: 3);
        when(mockGetVideosUseCase()).thenAnswer((_) async => initialVideos);
        await provider.loadVideos();

        // Arrange - refresh with new data
        final newVideos = createTestVideoList(count: 5);
        when(mockGetVideosUseCase()).thenAnswer((_) async => newVideos);

        // Act
        await provider.refresh();

        // Assert
        expect(provider.videos.length, 5);
        expect(provider.videos, newVideos);
      });
    });

    group('clearError', () {
      test('should clear error message', () async {
        // Arrange - create an error
        when(mockGetVideosUseCase()).thenThrow(Exception('Error'));
        await provider.loadVideos();
        expect(provider.hasError, true);

        // Act
        provider.clearError();

        // Assert
        expect(provider.errorMessage, isNull);
        expect(provider.hasError, false);
      });

      test('should notify listeners when error is cleared', () {
        // Arrange - create an error state manually
        int notificationCount = 0;
        provider.addListener(() => notificationCount++);

        // Act
        provider.clearError();

        // Assert
        expect(notificationCount, 1);
      });
    });

    group('state consistency', () {
      test('should maintain consistent state after multiple operations',
          () async {
        // Arrange
        final testVideos = createTestVideoList(count: 3);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);
        await provider.loadVideos();

        final videoId = testVideos[0].id;
        final likedVideo = testVideos[0].copyWith(isLiked: true, likes: 101);
        final sharedVideo = likedVideo.copyWith(shares: 51);

        when(mockToggleLikeUseCase(videoId))
            .thenAnswer((_) async => likedVideo);
        when(mockIncrementShareCountUseCase(videoId))
            .thenAnswer((_) async => sharedVideo);

        // Act - perform multiple operations
        await provider.toggleLike(videoId);
        await provider.shareVideo(videoId);

        // Assert
        expect(provider.videos[0].isLiked, true);
        expect(provider.videos[0].likes, 101);
        expect(provider.videos[0].shares, 51);
      });

      test('should handle rapid successive calls', () async {
        // Arrange
        final testVideos = createTestVideoList(count: 1);
        when(mockGetVideosUseCase()).thenAnswer((_) async => testVideos);

        // Act - rapid calls
        final futures = [
          provider.loadVideos(),
          provider.loadVideos(),
          provider.loadVideos(),
        ];
        await Future.wait(futures);

        // Assert - should have loaded successfully
        expect(provider.videos, isNotEmpty);
        expect(provider.isLoading, false);
      });
    });
  });
}
