import 'package:flutter_reels/core/platform/messages.g.dart';
import 'package:flutter_reels/core/services/button_events_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'button_events_service_test.mocks.dart';

// Generate mock for FlutterReelsButtonEventsApi
@GenerateMocks([FlutterReelsButtonEventsApi])
void main() {
  late ButtonEventsService service;
  late MockFlutterReelsButtonEventsApi mockApi;

  setUp(() {
    mockApi = MockFlutterReelsButtonEventsApi();
    service = ButtonEventsService(api: mockApi);
  });

  group('ButtonEventsService', () {
    group('notifyBeforeLikeClick', () {
      test('should call API with video ID', () {
        // Arrange
        const videoId = 'video123';

        // Act
        service.notifyBeforeLikeClick(videoId);

        // Assert
        verify(mockApi.onBeforeLikeButtonClick(videoId)).called(1);
      });

      test('should handle different video IDs', () {
        // Act
        service.notifyBeforeLikeClick('video1');
        service.notifyBeforeLikeClick('video2');
        service.notifyBeforeLikeClick('video3');

        // Assert
        verify(mockApi.onBeforeLikeButtonClick('video1')).called(1);
        verify(mockApi.onBeforeLikeButtonClick('video2')).called(1);
        verify(mockApi.onBeforeLikeButtonClick('video3')).called(1);
      });

      test('should handle empty video ID', () {
        // Act
        service.notifyBeforeLikeClick('');

        // Assert
        verify(mockApi.onBeforeLikeButtonClick('')).called(1);
      });
    });

    group('notifyAfterLikeClick', () {
      test('should call API with all required parameters', () {
        // Arrange
        const videoId = 'video123';
        const isLiked = true;
        const likeCount = 42;

        // Act
        service.notifyAfterLikeClick(
          videoId: videoId,
          isLiked: isLiked,
          likeCount: likeCount,
        );

        // Assert
        verify(mockApi.onAfterLikeButtonClick(videoId, isLiked, likeCount))
            .called(1);
      });

      test('should handle liked state (true)', () {
        // Act
        service.notifyAfterLikeClick(
          videoId: 'video123',
          isLiked: true,
          likeCount: 100,
        );

        // Assert
        verify(mockApi.onAfterLikeButtonClick('video123', true, 100)).called(1);
      });

      test('should handle unliked state (false)', () {
        // Act
        service.notifyAfterLikeClick(
          videoId: 'video123',
          isLiked: false,
          likeCount: 99,
        );

        // Assert
        verify(mockApi.onAfterLikeButtonClick('video123', false, 99)).called(1);
      });

      test('should handle zero like count', () {
        // Act
        service.notifyAfterLikeClick(
          videoId: 'video123',
          isLiked: false,
          likeCount: 0,
        );

        // Assert
        verify(mockApi.onAfterLikeButtonClick('video123', false, 0)).called(1);
      });

      test('should handle large like count', () {
        // Act
        service.notifyAfterLikeClick(
          videoId: 'video123',
          isLiked: true,
          likeCount: 1000000,
        );

        // Assert
        verify(mockApi.onAfterLikeButtonClick('video123', true, 1000000))
            .called(1);
      });
    });

    group('notifyShareClick', () {
      test('should call API with all required parameters', () {
        // Arrange
        const videoId = 'video123';
        const videoUrl = 'https://example.com/video123';
        const title = 'Amazing Video';
        const description = 'Check out this video!';

        // Act
        service.notifyShareClick(
          videoId: videoId,
          videoUrl: videoUrl,
          title: title,
          description: description,
        );

        // Assert
        verify(mockApi.onShareButtonClick(argThat(
          predicate<ShareData>((data) {
            return data.videoId == videoId &&
                data.videoUrl == videoUrl &&
                data.title == title &&
                data.description == description &&
                data.thumbnailUrl == null;
          }),
        ))).called(1);
      });

      test('should include thumbnail URL when provided', () {
        // Arrange
        const thumbnailUrl = 'https://example.com/thumb.jpg';

        // Act
        service.notifyShareClick(
          videoId: 'video123',
          videoUrl: 'https://example.com/video',
          title: 'Title',
          description: 'Description',
          thumbnailUrl: thumbnailUrl,
        );

        // Assert
        verify(mockApi.onShareButtonClick(argThat(
          predicate<ShareData>((data) {
            return data.thumbnailUrl == thumbnailUrl;
          }),
        ))).called(1);
      });

      test('should handle null thumbnail URL', () {
        // Act
        service.notifyShareClick(
          videoId: 'video123',
          videoUrl: 'https://example.com/video',
          title: 'Title',
          description: 'Description',
          thumbnailUrl: null,
        );

        // Assert
        verify(mockApi.onShareButtonClick(argThat(
          predicate<ShareData>((data) {
            return data.thumbnailUrl == null;
          }),
        ))).called(1);
      });

      test('should create ShareData with correct structure', () {
        // Act
        service.notifyShareClick(
          videoId: 'video123',
          videoUrl: 'https://example.com/video123',
          title: 'My Video',
          description: 'This is my video',
          thumbnailUrl: 'https://example.com/thumb.jpg',
        );

        // Assert - verify ShareData has all fields
        verify(mockApi.onShareButtonClick(argThat(
          predicate<ShareData>((data) {
            return data.videoId == 'video123' &&
                data.videoUrl == 'https://example.com/video123' &&
                data.title == 'My Video' &&
                data.description == 'This is my video' &&
                data.thumbnailUrl == 'https://example.com/thumb.jpg';
          }),
        ))).called(1);
      });

      test('should handle empty strings', () {
        // Act
        service.notifyShareClick(
          videoId: '',
          videoUrl: '',
          title: '',
          description: '',
        );

        // Assert
        verify(mockApi.onShareButtonClick(argThat(
          predicate<ShareData>((data) {
            return data.videoId == '' &&
                data.videoUrl == '' &&
                data.title == '' &&
                data.description == '';
          }),
        ))).called(1);
      });

      test('should handle special characters in strings', () {
        // Act
        service.notifyShareClick(
          videoId: 'video_123-test',
          videoUrl: 'https://example.com/video?id=123&ref=share',
          title: 'Title with "quotes" and \'apostrophes\'',
          description: 'Description with <html> & special chars',
        );

        // Assert
        verify(mockApi.onShareButtonClick(argThat(
          predicate<ShareData>((data) {
            return data.videoId == 'video_123-test' &&
                data.videoUrl == 'https://example.com/video?id=123&ref=share' &&
                data.title == 'Title with "quotes" and \'apostrophes\'' &&
                data.description == 'Description with <html> & special chars';
          }),
        ))).called(1);
      });
    });

    group('multiple calls', () {
      test('should handle before and after like in sequence', () {
        // Arrange
        const videoId = 'video123';

        // Act
        service.notifyBeforeLikeClick(videoId);
        service.notifyAfterLikeClick(
          videoId: videoId,
          isLiked: true,
          likeCount: 42,
        );

        // Assert
        verifyInOrder([
          mockApi.onBeforeLikeButtonClick(videoId),
          mockApi.onAfterLikeButtonClick(videoId, true, 42),
        ]);
      });

      test('should handle multiple like sequences', () {
        // Act
        service.notifyBeforeLikeClick('video1');
        service.notifyAfterLikeClick(
          videoId: 'video1',
          isLiked: true,
          likeCount: 10,
        );

        service.notifyBeforeLikeClick('video2');
        service.notifyAfterLikeClick(
          videoId: 'video2',
          isLiked: false,
          likeCount: 5,
        );

        // Assert
        verify(mockApi.onBeforeLikeButtonClick('video1')).called(1);
        verify(mockApi.onAfterLikeButtonClick('video1', true, 10)).called(1);
        verify(mockApi.onBeforeLikeButtonClick('video2')).called(1);
        verify(mockApi.onAfterLikeButtonClick('video2', false, 5)).called(1);
      });

      test('should handle mix of like and share events', () {
        // Act
        service.notifyBeforeLikeClick('video1');
        service.notifyShareClick(
          videoId: 'video2',
          videoUrl: 'url',
          title: 'title',
          description: 'desc',
        );
        service.notifyAfterLikeClick(
          videoId: 'video1',
          isLiked: true,
          likeCount: 1,
        );

        // Assert
        verify(mockApi.onBeforeLikeButtonClick('video1')).called(1);
        verify(mockApi.onShareButtonClick(any)).called(1);
        verify(mockApi.onAfterLikeButtonClick('video1', true, 1)).called(1);
      });
    });
  });
}
