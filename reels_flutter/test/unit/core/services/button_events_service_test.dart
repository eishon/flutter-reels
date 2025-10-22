import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reels_flutter/core/pigeon_generated.dart';
import 'package:reels_flutter/core/services/button_events_service.dart';

import '../../../helpers/test_mocks.dart';

void main() {
  group('ButtonEventsService', () {
    late ButtonEventsService service;
    late MockReelsFlutterButtonEventsApi mockApi;

    setUp(() {
      mockApi = MockReelsFlutterButtonEventsApi();
      service = ButtonEventsService(api: mockApi);
    });

    group('onBeforeLikeButtonClick', () {
      test('should call api with video id', () {
        // Arrange
        const videoId = 'video_123';

        // Act
        service.onBeforeLikeButtonClick(videoId);

        // Assert
        verify(mockApi.onBeforeLikeButtonClick(videoId)).called(1);
      });

      test('should not throw when api fails', () {
        // Arrange
        const videoId = 'video_error';
        when(
          mockApi.onBeforeLikeButtonClick(any),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => service.onBeforeLikeButtonClick(videoId), returnsNormally);
      });
    });

    group('onAfterLikeButtonClick', () {
      test('should call api with video id, like status, and count', () {
        // Arrange
        const videoId = 'video_456';
        const isLiked = true;
        const likeCount = 42;

        // Act
        service.onAfterLikeButtonClick(videoId, isLiked, likeCount);

        // Assert
        verify(
          mockApi.onAfterLikeButtonClick(videoId, isLiked, likeCount),
        ).called(1);
      });

      test('should handle unlike scenario', () {
        // Arrange
        const videoId = 'video_789';
        const isLiked = false;
        const likeCount = 41;

        // Act
        service.onAfterLikeButtonClick(videoId, isLiked, likeCount);

        // Assert
        verify(
          mockApi.onAfterLikeButtonClick(videoId, isLiked, likeCount),
        ).called(1);
      });

      test('should not throw when api fails', () {
        // Arrange
        when(
          mockApi.onAfterLikeButtonClick(any, any, any),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => service.onAfterLikeButtonClick('vid', true, 10),
          returnsNormally,
        );
      });
    });

    group('onShareButtonClick', () {
      test('should call api with complete ShareData', () {
        // Arrange
        const videoId = 'video_share_123';
        const videoUrl = 'https://example.com/video/123';
        const title = 'Amazing Video';
        const description = 'Check out this video';
        const thumbnailUrl = 'https://example.com/thumb/123.jpg';

        // Act
        service.onShareButtonClick(
          videoId: videoId,
          videoUrl: videoUrl,
          title: title,
          description: description,
          thumbnailUrl: thumbnailUrl,
        );

        // Assert
        verify(
          mockApi.onShareButtonClick(
            argThat(
              isA<ShareData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.videoUrl, 'videoUrl', videoUrl)
                  .having((d) => d.title, 'title', title)
                  .having((d) => d.description, 'description', description)
                  .having((d) => d.thumbnailUrl, 'thumbnailUrl', thumbnailUrl),
            ),
          ),
        ).called(1);
      });

      test('should work without optional thumbnailUrl', () {
        // Arrange
        const videoId = 'video_share_456';
        const videoUrl = 'https://example.com/video/456';
        const title = 'Simple Video';
        const description = 'Basic share';

        // Act
        service.onShareButtonClick(
          videoId: videoId,
          videoUrl: videoUrl,
          title: title,
          description: description,
        );

        // Assert
        verify(
          mockApi.onShareButtonClick(
            argThat(
              isA<ShareData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.videoUrl, 'videoUrl', videoUrl)
                  .having((d) => d.title, 'title', title)
                  .having((d) => d.description, 'description', description)
                  .having((d) => d.thumbnailUrl, 'thumbnailUrl', isNull),
            ),
          ),
        ).called(1);
      });

      test('should not throw when api fails', () {
        // Arrange
        when(mockApi.onShareButtonClick(any)).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => service.onShareButtonClick(
            videoId: 'vid',
            videoUrl: 'url',
            title: 'title',
            description: 'desc',
          ),
          returnsNormally,
        );
      });
    });

    group('legacy compatibility methods', () {
      test('notifyBeforeLikeClick should call onBeforeLikeButtonClick', () {
        // Arrange
        const videoId = 'legacy_video_123';

        // Act
        service.notifyBeforeLikeClick(videoId);

        // Assert
        verify(mockApi.onBeforeLikeButtonClick(videoId)).called(1);
      });

      test('notifyAfterLikeClick should call onAfterLikeButtonClick', () {
        // Arrange
        const videoId = 'legacy_video_456';
        const isLiked = true;
        const likeCount = 99;

        // Act
        service.notifyAfterLikeClick(videoId, isLiked, likeCount);

        // Assert
        verify(
          mockApi.onAfterLikeButtonClick(videoId, isLiked, likeCount),
        ).called(1);
      });

      test('notifyShareClick should call onShareButtonClick', () {
        // Arrange
        const videoId = 'legacy_video_789';
        const videoUrl = 'https://legacy.com/video';
        const title = 'Legacy Title';
        const description = 'Legacy Description';

        // Act
        service.notifyShareClick(
          videoId: videoId,
          videoUrl: videoUrl,
          title: title,
          description: description,
        );

        // Assert
        verify(
          mockApi.onShareButtonClick(
            argThat(
              isA<ShareData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.videoUrl, 'videoUrl', videoUrl)
                  .having((d) => d.title, 'title', title)
                  .having((d) => d.description, 'description', description),
            ),
          ),
        ).called(1);
      });
    });
  });
}
