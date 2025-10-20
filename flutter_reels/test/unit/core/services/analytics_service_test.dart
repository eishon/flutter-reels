import 'package:flutter_reels/core/platform/messages.g.dart';
import 'package:flutter_reels/core/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'analytics_service_test.mocks.dart';

// Generate mock for FlutterReelsAnalyticsApi
@GenerateMocks([FlutterReelsAnalyticsApi])
void main() {
  late AnalyticsService service;
  late MockFlutterReelsAnalyticsApi mockApi;

  setUp(() {
    mockApi = MockFlutterReelsAnalyticsApi();
    service = AnalyticsService(api: mockApi);
  });

  group('AnalyticsService', () {
    group('trackEvent', () {
      test('should call API with correct event type and data', () {
        // Arrange
        const eventType = 'test_event';
        final data = {'key': 'value', 'number': 42};

        // Act
        service.trackEvent(eventType, data: data);

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == eventType && 
                   event.data['key'] == 'value' &&
                   event.data['number'] == 42;
          }),
        ))).called(1);
      });

      test('should use empty map if no data provided', () {
        // Act
        service.trackEvent('test');

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'test' && event.data.isEmpty;
          }),
        ))).called(1);
      });
    });

    group('trackVideoAppear', () {
      test('should track appear event with video ID', () {
        // Act
        service.trackVideoAppear(videoId: 'video123');

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'appear' && 
                   event.data['video_id'] == 'video123' &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should include position and screen name when provided', () {
        // Act
        service.trackVideoAppear(
          videoId: 'video123',
          position: 5,
          screenName: 'reels_screen',
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'appear' && 
                   event.data['video_id'] == 'video123' &&
                   event.data['position'] == 5 &&
                   event.data['screen'] == 'reels_screen';
          }),
        ))).called(1);
      });

      test('should not include position or screen if null', () {
        // Act
        service.trackVideoAppear(videoId: 'video123');

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'appear' && 
                   !event.data.containsKey('position') &&
                   !event.data.containsKey('screen');
          }),
        ))).called(1);
      });
    });

    group('trackVideoClick', () {
      test('should track click event with required fields', () {
        // Act
        service.trackVideoClick(
          videoId: 'video123',
          element: 'product_button',
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'click' && 
                   event.data['video_id'] == 'video123' &&
                   event.data['element'] == 'product_button' &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should include position when provided', () {
        // Act
        service.trackVideoClick(
          videoId: 'video123',
          element: 'like_button',
          position: 3,
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.data['position'] == 3;
          }),
        ))).called(1);
      });
    });

    group('trackPageView', () {
      test('should track page view with screen name', () {
        // Act
        service.trackPageView(screenName: 'reels_screen');

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'page_view' && 
                   event.data['screen'] == 'reels_screen' &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should include metadata when provided', () {
        // Act
        service.trackPageView(
          screenName: 'reels_screen',
          metadata: {'source': 'deep_link', 'campaign': 'promo'},
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.data['screen'] == 'reels_screen' &&
                   event.data['source'] == 'deep_link' &&
                   event.data['campaign'] == 'promo';
          }),
        ))).called(1);
      });
    });

    group('trackLike', () {
      test('should track like event with all required fields', () {
        // Act
        service.trackLike(
          videoId: 'video123',
          isLiked: true,
          likeCount: 42,
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'like' && 
                   event.data['video_id'] == 'video123' &&
                   event.data['is_liked'] == true &&
                   event.data['like_count'] == 42 &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should track unlike action', () {
        // Act
        service.trackLike(
          videoId: 'video123',
          isLiked: false,
          likeCount: 41,
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.data['is_liked'] == false &&
                   event.data['like_count'] == 41;
          }),
        ))).called(1);
      });
    });

    group('trackShare', () {
      test('should track share event with video ID', () {
        // Act
        service.trackShare(videoId: 'video123');

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'share' && 
                   event.data['video_id'] == 'video123' &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should include share type when provided', () {
        // Act
        service.trackShare(
          videoId: 'video123',
          shareType: 'native_share',
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.data['share_type'] == 'native_share';
          }),
        ))).called(1);
      });
    });

    group('trackVideoStart', () {
      test('should track video start event', () {
        // Act
        service.trackVideoStart(videoId: 'video123');

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'video_start' && 
                   event.data['video_id'] == 'video123' &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should include duration when provided', () {
        // Act
        service.trackVideoStart(
          videoId: 'video123',
          duration: 30.5,
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.data['duration'] == 30.5;
          }),
        ))).called(1);
      });
    });

    group('trackVideoComplete', () {
      test('should track video complete event', () {
        // Act
        service.trackVideoComplete(videoId: 'video123');

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'video_complete' && 
                   event.data['video_id'] == 'video123' &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should include duration and completion rate when provided', () {
        // Act
        service.trackVideoComplete(
          videoId: 'video123',
          duration: 30.0,
          completionRate: 0.95,
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.data['duration'] == 30.0 &&
                   event.data['completion_rate'] == 0.95;
          }),
        ))).called(1);
      });
    });

    group('trackError', () {
      test('should track error event with required fields', () {
        // Act
        service.trackError(
          errorType: 'network_error',
          errorMessage: 'Failed to load video',
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.type == 'error' && 
                   event.data['error_type'] == 'network_error' &&
                   event.data['error_message'] == 'Failed to load video' &&
                   event.data.containsKey('timestamp');
          }),
        ))).called(1);
      });

      test('should include video ID when provided', () {
        // Act
        service.trackError(
          errorType: 'playback_error',
          errorMessage: 'Video failed to play',
          videoId: 'video123',
        );

        // Assert
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            return event.data['video_id'] == 'video123';
          }),
        ))).called(1);
      });
    });

    group('timestamps', () {
      test('should add timestamp to all events', () {
        // Act
        service.trackVideoAppear(videoId: 'video123');
        service.trackLike(videoId: 'video123', isLiked: true, likeCount: 1);
        service.trackShare(videoId: 'video123');

        // Assert - all should have timestamps
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) => event.data.containsKey('timestamp')),
        ))).called(3);
      });

      test('should use current time for timestamp', () {
        // Arrange
        final beforeTime = DateTime.now().millisecondsSinceEpoch;

        // Act
        service.trackVideoAppear(videoId: 'video123');

        // Assert
        final afterTime = DateTime.now().millisecondsSinceEpoch;
        verify(mockApi.trackEvent(argThat(
          predicate<AnalyticsEvent>((event) {
            final timestamp = event.data['timestamp'] as int;
            return timestamp >= beforeTime && timestamp <= afterTime;
          }),
        ))).called(1);
      });
    });
  });
}
