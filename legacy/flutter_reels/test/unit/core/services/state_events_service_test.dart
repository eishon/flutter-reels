import 'package:flutter_reels/core/platform/messages.g.dart';
import 'package:flutter_reels/core/services/state_events_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'state_events_service_test.mocks.dart';

@GenerateMocks([FlutterReelsStateApi])
void main() {
  late StateEventsService service;
  late MockFlutterReelsStateApi mockApi;

  setUp(() {
    mockApi = MockFlutterReelsStateApi();
    service = StateEventsService(api: mockApi);
  });

  group('StateEventsService - Screen State Events', () {
    test('notifyScreenStateChanged sends correct data to native', () {
      // Arrange
      const screenName = 'test_screen';
      const state = 'focused';
      final metadata = {'key': 'value'};

      // Act
      service.notifyScreenStateChanged(
        screenName: screenName,
        state: state,
        metadata: metadata,
      );

      // Assert
      final captured = verify(mockApi.onScreenStateChanged(captureAny))
          .captured
          .single as ScreenStateData;

      expect(captured.screenName, screenName);
      expect(captured.state, state);
      expect(captured.metadata, metadata);
    });

    test('notifyScreenStateChanged works without metadata', () {
      // Arrange
      const screenName = 'test_screen';
      const state = 'focused';

      // Act
      service.notifyScreenStateChanged(
        screenName: screenName,
        state: state,
      );

      // Assert
      final captured = verify(mockApi.onScreenStateChanged(captureAny))
          .captured
          .single as ScreenStateData;

      expect(captured.screenName, screenName);
      expect(captured.state, state);
      expect(captured.metadata, isNull);
    });

    test('notifyScreenFocused sends focused state', () {
      // Arrange
      const screenName = 'reels_screen';

      // Act
      service.notifyScreenFocused(screenName: screenName);

      // Assert
      final captured = verify(mockApi.onScreenStateChanged(captureAny))
          .captured
          .single as ScreenStateData;

      expect(captured.screenName, screenName);
      expect(captured.state, 'focused');
      expect(captured.metadata, isNull);
    });

    test('notifyScreenFocused includes metadata when provided', () {
      // Arrange
      const screenName = 'reels_screen';
      final metadata = {'source': 'navigation'};

      // Act
      service.notifyScreenFocused(
        screenName: screenName,
        metadata: metadata,
      );

      // Assert
      final captured = verify(mockApi.onScreenStateChanged(captureAny))
          .captured
          .single as ScreenStateData;

      expect(captured.screenName, screenName);
      expect(captured.state, 'focused');
      expect(captured.metadata, metadata);
    });

    test('notifyScreenUnfocused sends unfocused state', () {
      // Arrange
      const screenName = 'reels_screen';

      // Act
      service.notifyScreenUnfocused(screenName: screenName);

      // Assert
      final captured = verify(mockApi.onScreenStateChanged(captureAny))
          .captured
          .single as ScreenStateData;

      expect(captured.screenName, screenName);
      expect(captured.state, 'unfocused');
      expect(captured.metadata, isNull);
    });

    test('notifyScreenUnfocused includes metadata when provided', () {
      // Arrange
      const screenName = 'reels_screen';
      final metadata = {'reason': 'app_background'};

      // Act
      service.notifyScreenUnfocused(
        screenName: screenName,
        metadata: metadata,
      );

      // Assert
      final captured = verify(mockApi.onScreenStateChanged(captureAny))
          .captured
          .single as ScreenStateData;

      expect(captured.screenName, screenName);
      expect(captured.state, 'unfocused');
      expect(captured.metadata, metadata);
    });
  });

  group('StateEventsService - Video State Events', () {
    test('notifyVideoStateChanged sends correct data to native', () {
      // Arrange
      const videoId = 'video123';
      const state = 'playing';
      const position = 5.0;
      const duration = 60.0;

      // Act
      service.notifyVideoStateChanged(
        videoId: videoId,
        state: state,
        position: position,
        duration: duration,
      );

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, state);
      expect(captured.position, position);
      expect(captured.duration, duration);
    });

    test('notifyVideoStateChanged works without position and duration', () {
      // Arrange
      const videoId = 'video123';
      const state = 'stopped';

      // Act
      service.notifyVideoStateChanged(
        videoId: videoId,
        state: state,
      );

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, state);
      expect(captured.position, isNull);
      expect(captured.duration, isNull);
    });

    test('notifyVideoPlaying sends playing state', () {
      // Arrange
      const videoId = 'video123';
      const position = 10.0;
      const duration = 120.0;

      // Act
      service.notifyVideoPlaying(
        videoId: videoId,
        position: position,
        duration: duration,
      );

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, 'playing');
      expect(captured.position, position);
      expect(captured.duration, duration);
    });

    test('notifyVideoPlaying works without position and duration', () {
      // Arrange
      const videoId = 'video123';

      // Act
      service.notifyVideoPlaying(videoId: videoId);

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, 'playing');
      expect(captured.position, isNull);
      expect(captured.duration, isNull);
    });

    test('notifyVideoPaused sends paused state', () {
      // Arrange
      const videoId = 'video456';
      const position = 30.0;
      const duration = 90.0;

      // Act
      service.notifyVideoPaused(
        videoId: videoId,
        position: position,
        duration: duration,
      );

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, 'paused');
      expect(captured.position, position);
      expect(captured.duration, duration);
    });

    test('notifyVideoStopped sends stopped state', () {
      // Arrange
      const videoId = 'video789';

      // Act
      service.notifyVideoStopped(videoId: videoId);

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, 'stopped');
      expect(captured.position, isNull);
      expect(captured.duration, isNull);
    });

    test('notifyVideoBuffering sends buffering state', () {
      // Arrange
      const videoId = 'video101';
      const position = 15.0;
      const duration = 60.0;

      // Act
      service.notifyVideoBuffering(
        videoId: videoId,
        position: position,
        duration: duration,
      );

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, 'buffering');
      expect(captured.position, position);
      expect(captured.duration, duration);
    });

    test('notifyVideoCompleted sends completed state', () {
      // Arrange
      const videoId = 'video202';
      const duration = 45.0;

      // Act
      service.notifyVideoCompleted(
        videoId: videoId,
        duration: duration,
      );

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, 'completed');
      expect(captured.position, duration); // Position = duration for completed
      expect(captured.duration, duration);
    });

    test('notifyVideoCompleted works without duration', () {
      // Arrange
      const videoId = 'video303';

      // Act
      service.notifyVideoCompleted(videoId: videoId);

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny))
          .captured
          .single as VideoStateData;

      expect(captured.videoId, videoId);
      expect(captured.state, 'completed');
      expect(captured.position, isNull);
      expect(captured.duration, isNull);
    });
  });

  group('StateEventsService - Multiple Events', () {
    test('can send multiple screen state events in sequence', () {
      // Act
      service.notifyScreenFocused(screenName: 'screen1');
      service.notifyScreenUnfocused(screenName: 'screen1');
      service.notifyScreenFocused(screenName: 'screen2');

      // Assert
      final captured =
          verify(mockApi.onScreenStateChanged(captureAny)).captured;
      expect(captured.length, 3);

      expect((captured[0] as ScreenStateData).state, 'focused');
      expect((captured[0] as ScreenStateData).screenName, 'screen1');

      expect((captured[1] as ScreenStateData).state, 'unfocused');
      expect((captured[1] as ScreenStateData).screenName, 'screen1');

      expect((captured[2] as ScreenStateData).state, 'focused');
      expect((captured[2] as ScreenStateData).screenName, 'screen2');
    });

    test('can send multiple video state events in sequence', () {
      // Act
      service.notifyVideoPlaying(videoId: 'video1', position: 0.0);
      service.notifyVideoBuffering(videoId: 'video1', position: 5.0);
      service.notifyVideoPlaying(videoId: 'video1', position: 5.0);
      service.notifyVideoPaused(videoId: 'video1', position: 10.0);

      // Assert
      final captured = verify(mockApi.onVideoStateChanged(captureAny)).captured;
      expect(captured.length, 4);

      expect((captured[0] as VideoStateData).state, 'playing');
      expect((captured[0] as VideoStateData).position, 0.0);

      expect((captured[1] as VideoStateData).state, 'buffering');
      expect((captured[1] as VideoStateData).position, 5.0);

      expect((captured[2] as VideoStateData).state, 'playing');
      expect((captured[2] as VideoStateData).position, 5.0);

      expect((captured[3] as VideoStateData).state, 'paused');
      expect((captured[3] as VideoStateData).position, 10.0);
    });
  });
}
