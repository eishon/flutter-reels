import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reels_flutter/core/pigeon_generated.dart';
import 'package:reels_flutter/core/services/analytics_service.dart';

import '../../../helpers/test_mocks.dart';

void main() {
  group('AnalyticsService', () {
    late AnalyticsService service;
    late MockReelsFlutterAnalyticsApi mockApi;

    setUp(() {
      mockApi = MockReelsFlutterAnalyticsApi();
      service = AnalyticsService(api: mockApi);
    });

    group('trackEvent', () {
      test('should call api.trackEvent with correct AnalyticsEvent', () {
        // Arrange
        const eventType = 'test_event';
        final eventData = <String?, Object?>{'key': 'value', 'count': 42};

        // Act
        service.trackEvent(eventType, eventData);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', eventType)
                  .having(
                    (e) => e.eventProperties,
                    'eventProperties',
                    {'key': 'value', 'count': '42'},
                  ),
            ),
          ),
        ).called(1);
      });

      test('should convert all values to String', () {
        // Arrange
        const eventType = 'conversion_test';
        final eventData = <String?, Object?>{
          'string': 'text',
          'int': 123,
          'double': 45.67,
          'bool': true,
          'null': null,
        };

        // Act
        service.trackEvent(eventType, eventData);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>().having(
                (e) => e.eventProperties,
                'eventProperties',
                {
                  'string': 'text',
                  'int': '123',
                  'double': '45.67',
                  'bool': 'true',
                  'null': null,
                },
              ),
            ),
          ),
        ).called(1);
      });

      test('should not throw when api call fails', () {
        // Arrange
        when(mockApi.trackEvent(any)).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => service.trackEvent('test', {'key': 'value'}),
          returnsNormally,
        );
      });
    });

    group('trackVideoView', () {
      test('should track video view with correct data', () {
        // Arrange
        const videoId = 'video_123';
        const position = 5;

        // Act
        service.trackVideoView(videoId, position);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'video_view')
                  .having(
                    (e) => e.eventProperties['video_id'],
                    'video_id',
                    videoId,
                  )
                  .having(
                    (e) => e.eventProperties['position'],
                    'position',
                    position.toString(),
                  ),
            ),
          ),
        ).called(1);
      });
    });

    group('trackPageView', () {
      test('should track page view with screen name', () {
        // Arrange
        const screenName = 'reels_screen';

        // Act
        service.trackPageView(screenName);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'page_view')
                  .having(
                    (e) => e.eventProperties['screen'],
                    'screen',
                    screenName,
                  ),
            ),
          ),
        ).called(1);
      });
    });

    group('trackClick', () {
      test('should track click with element name', () {
        // Arrange
        const element = 'like_button';

        // Act
        service.trackClick(element, null);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'click')
                  .having(
                    (e) => e.eventProperties['element'],
                    'element',
                    element,
                  ),
            ),
          ),
        ).called(1);
      });

      test('should merge additional data', () {
        // Arrange
        const element = 'share_button';
        final additionalData = <String?, Object?>{'video_id': 'vid_456'};

        // Act
        service.trackClick(element, additionalData);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'click')
                  .having(
                    (e) => e.eventProperties['element'],
                    'element',
                    element,
                  )
                  .having(
                    (e) => e.eventProperties['video_id'],
                    'video_id',
                    'vid_456',
                  ),
            ),
          ),
        ).called(1);
      });
    });

    group('trackLike', () {
      test('should track like event with all parameters', () {
        // Arrange
        const videoId = 'video_789';
        const isLiked = true;
        const likeCount = 100;

        // Act
        service.trackLike(
          videoId: videoId,
          isLiked: isLiked,
          likeCount: likeCount,
        );

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'like')
                  .having(
                    (e) => e.eventProperties['video_id'],
                    'video_id',
                    videoId,
                  )
                  .having(
                    (e) => e.eventProperties['is_liked'],
                    'is_liked',
                    'true',
                  )
                  .having(
                    (e) => e.eventProperties['like_count'],
                    'like_count',
                    likeCount.toString(),
                  ),
            ),
          ),
        ).called(1);
      });

      test('should work without optional likeCount', () {
        // Arrange
        const videoId = 'video_999';
        const isLiked = false;

        // Act
        service.trackLike(videoId: videoId, isLiked: isLiked);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'like')
                  .having(
                    (e) => e.eventProperties['video_id'],
                    'video_id',
                    videoId,
                  )
                  .having(
                    (e) => e.eventProperties['is_liked'],
                    'is_liked',
                    'false',
                  ),
            ),
          ),
        ).called(1);
      });
    });

    group('trackShare', () {
      test('should track share event with video id', () {
        // Arrange
        const videoId = 'video_share_123';

        // Act
        service.trackShare(videoId: videoId);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'share')
                  .having(
                    (e) => e.eventProperties['video_id'],
                    'video_id',
                    videoId,
                  ),
            ),
          ),
        ).called(1);
      });
    });

    group('trackError', () {
      test('should track error with all parameters', () {
        // Arrange
        const error = 'Network failure';
        const context = 'video_loading';
        final additionalData = <String?, Object?>{'code': '500'};

        // Act
        service.trackError(
          error: error,
          context: context,
          additionalData: additionalData,
        );

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'error')
                  .having((e) => e.eventProperties['error'], 'error', error)
                  .having(
                    (e) => e.eventProperties['context'],
                    'context',
                    context,
                  )
                  .having((e) => e.eventProperties['code'], 'code', '500'),
            ),
          ),
        ).called(1);
      });

      test('should work with minimal parameters', () {
        // Arrange
        const error = 'Simple error';

        // Act
        service.trackError(error: error);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'error')
                  .having((e) => e.eventProperties['error'], 'error', error),
            ),
          ),
        ).called(1);
      });
    });

    group('trackVideoAppear', () {
      test('should track video appear with all parameters', () {
        // Arrange
        const videoId = 'video_appear_123';
        const position = 3;
        const screenName = 'reels_screen';

        // Act
        service.trackVideoAppear(
          videoId: videoId,
          position: position,
          screenName: screenName,
        );

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'appear')
                  .having(
                    (e) => e.eventProperties['video_id'],
                    'video_id',
                    videoId,
                  )
                  .having(
                    (e) => e.eventProperties['position'],
                    'position',
                    position.toString(),
                  )
                  .having(
                    (e) => e.eventProperties['screen'],
                    'screen',
                    screenName,
                  ),
            ),
          ),
        ).called(1);
      });

      test('should work with only video id', () {
        // Arrange
        const videoId = 'video_minimal';

        // Act
        service.trackVideoAppear(videoId: videoId);

        // Assert
        verify(
          mockApi.trackEvent(
            argThat(
              isA<AnalyticsEvent>()
                  .having((e) => e.eventName, 'eventName', 'appear')
                  .having(
                    (e) => e.eventProperties['video_id'],
                    'video_id',
                    videoId,
                  ),
            ),
          ),
        ).called(1);
      });
    });
  });
}
