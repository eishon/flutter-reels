import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reels_flutter/core/pigeon_generated.dart';
import 'package:reels_flutter/core/services/state_events_service.dart';

import '../../../helpers/test_mocks.dart';

void main() {
  group('StateEventsService', () {
    late StateEventsService service;
    late MockReelsFlutterStateApi mockApi;

    setUp(() {
      mockApi = MockReelsFlutterStateApi();
      service = StateEventsService(api: mockApi);
    });

    group('onScreenStateChanged', () {
      test('should call api with ScreenStateData', () {
        // Arrange
        const state = 'focused';
        const screenName = 'reels_screen';
        const timestamp = 1234567890;

        // Act
        service.onScreenStateChanged(
          state: state,
          screenName: screenName,
          timestamp: timestamp,
        );

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', state)
                  .having((d) => d.screenName, 'screenName', screenName)
                  .having((d) => d.timestamp, 'timestamp', timestamp),
            ),
          ),
        ).called(1);
      });

      test('should work without timestamp', () {
        // Arrange
        const state = 'appeared';
        const screenName = 'video_list';

        // Act
        service.onScreenStateChanged(state: state, screenName: screenName);

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', state)
                  .having((d) => d.screenName, 'screenName', screenName),
            ),
          ),
        ).called(1);
      });

      test('should not throw when api fails', () {
        // Arrange
        when(mockApi.onScreenStateChanged(any))
            .thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => service.onScreenStateChanged(
            state: 'test',
            screenName: 'test_screen',
          ),
          returnsNormally,
        );
      });
    });

    group('onVideoStateChanged', () {
      test('should call api with VideoStateData', () {
        // Arrange
        const videoId = 'video_123';
        const state = 'playing';
        const position = 15.5;
        const duration = 60.0;

        // Act
        service.onVideoStateChanged(
          videoId: videoId,
          state: state,
          position: position,
          duration: duration,
        );

        // Assert
        verify(
          mockApi.onVideoStateChanged(
            argThat(
              isA<VideoStateData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.state, 'state', state)
                  .having((d) => d.position, 'position', 15)
                  .having((d) => d.duration, 'duration', 60),
            ),
          ),
        ).called(1);
      });

      test('should work without position and duration', () {
        // Arrange
        const videoId = 'video_456';
        const state = 'buffering';

        // Act
        service.onVideoStateChanged(videoId: videoId, state: state);

        // Assert
        verify(
          mockApi.onVideoStateChanged(
            argThat(
              isA<VideoStateData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.state, 'state', state),
            ),
          ),
        ).called(1);
      });

      test('should not throw when api fails', () {
        // Arrange
        when(mockApi.onVideoStateChanged(any))
            .thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => service.onVideoStateChanged(videoId: 'vid', state: 'test'),
          returnsNormally,
        );
      });
    });

    group('screen helper methods', () {
      test('screenAppeared should call onScreenStateChanged', () {
        // Arrange
        const screenName = 'home_screen';

        // Act
        service.screenAppeared(screenName);

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', 'appeared')
                  .having((d) => d.screenName, 'screenName', screenName)
                  .having((d) => d.timestamp, 'timestamp', isNotNull),
            ),
          ),
        ).called(1);
      });

      test('screenDisappeared should call onScreenStateChanged', () {
        // Arrange
        const screenName = 'detail_screen';

        // Act
        service.screenDisappeared(screenName);

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', 'disappeared')
                  .having((d) => d.screenName, 'screenName', screenName),
            ),
          ),
        ).called(1);
      });

      test('screenFocused should call onScreenStateChanged', () {
        // Arrange
        const screenName = 'reels_screen';

        // Act
        service.screenFocused(screenName);

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', 'focused')
                  .having((d) => d.screenName, 'screenName', screenName),
            ),
          ),
        ).called(1);
      });

      test('screenUnfocused should call onScreenStateChanged', () {
        // Arrange
        const screenName = 'settings_screen';

        // Act
        service.screenUnfocused(screenName);

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', 'unfocused')
                  .having((d) => d.screenName, 'screenName', screenName),
            ),
          ),
        ).called(1);
      });
    });

    group('video helper methods', () {
      test('videoPlaying should call onVideoStateChanged', () {
        // Arrange
        const videoId = 'video_play_123';
        const position = 10.0;
        const duration = 120.0;

        // Act
        service.videoPlaying(
          videoId,
          position: position,
          duration: duration,
        );

        // Assert
        verify(
          mockApi.onVideoStateChanged(
            argThat(
              isA<VideoStateData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.state, 'state', 'playing')
                  .having((d) => d.position, 'position', 10)
                  .having((d) => d.duration, 'duration', 120),
            ),
          ),
        ).called(1);
      });

      test('videoPaused should call onVideoStateChanged', () {
        // Arrange
        const videoId = 'video_pause_456';
        const position = 45.5;

        // Act
        service.videoPaused(videoId, position: position);

        // Assert
        verify(
          mockApi.onVideoStateChanged(
            argThat(
              isA<VideoStateData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.state, 'state', 'paused')
                  .having((d) => d.position, 'position', 45),
            ),
          ),
        ).called(1);
      });

      test('videoStopped should call onVideoStateChanged', () {
        // Arrange
        const videoId = 'video_stop_789';

        // Act
        service.videoStopped(videoId);

        // Assert
        verify(
          mockApi.onVideoStateChanged(
            argThat(
              isA<VideoStateData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.state, 'state', 'stopped'),
            ),
          ),
        ).called(1);
      });

      test('videoBuffering should call onVideoStateChanged', () {
        // Arrange
        const videoId = 'video_buffer_101';

        // Act
        service.videoBuffering(videoId);

        // Assert
        verify(
          mockApi.onVideoStateChanged(
            argThat(
              isA<VideoStateData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.state, 'state', 'buffering'),
            ),
          ),
        ).called(1);
      });

      test('videoCompleted should call onVideoStateChanged', () {
        // Arrange
        const videoId = 'video_complete_202';
        const duration = 180.0;

        // Act
        service.videoCompleted(videoId, duration);

        // Assert
        verify(
          mockApi.onVideoStateChanged(
            argThat(
              isA<VideoStateData>()
                  .having((d) => d.videoId, 'videoId', videoId)
                  .having((d) => d.state, 'state', 'completed')
                  .having((d) => d.duration, 'duration', 180),
            ),
          ),
        ).called(1);
      });
    });

    group('legacy compatibility methods', () {
      test('notifyScreenFocused should call screenFocused', () {
        // Arrange
        const screenName = 'legacy_screen';

        // Act
        service.notifyScreenFocused(screenName: screenName);

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', 'focused')
                  .having((d) => d.screenName, 'screenName', screenName),
            ),
          ),
        ).called(1);
      });

      test('notifyScreenUnfocused should call screenUnfocused', () {
        // Arrange
        const screenName = 'legacy_unfocused';

        // Act
        service.notifyScreenUnfocused(screenName: screenName);

        // Assert
        verify(
          mockApi.onScreenStateChanged(
            argThat(
              isA<ScreenStateData>()
                  .having((d) => d.state, 'state', 'unfocused')
                  .having((d) => d.screenName, 'screenName', screenName),
            ),
          ),
        ).called(1);
      });
    });
  });
}
