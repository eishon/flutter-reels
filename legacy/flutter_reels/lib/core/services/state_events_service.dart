import 'package:flutter_reels/core/platform/messages.g.dart';

/// Service for notifying native platform about screen and video state changes
///
/// This service wraps the FlutterReelsStateApi to send state change events
/// to the native platform, enabling native to:
/// - Pause/resume videos based on screen lifecycle
/// - Update UI based on video playback state
/// - Track user engagement and viewing time
/// - Implement custom behaviors for different states
class StateEventsService {
  /// Creates a state events service
  ///
  /// [api] The native state events API implementation
  StateEventsService({required FlutterReelsStateApi api}) : _api = api;

  final FlutterReelsStateApi _api;

  /// Notify native that screen state changed
  ///
  /// Common states:
  /// - "focused" - Screen is active and visible
  /// - "unfocused" - Screen lost focus (navigated away)
  /// - "appeared" - Screen appeared on screen
  /// - "disappeared" - Screen removed from screen
  ///
  /// [state] The new screen state
  /// [screenName] The name of the screen (e.g., "reels_screen")
  /// [metadata] Optional additional metadata
  void notifyScreenStateChanged({
    required String state,
    required String screenName,
    Map<String?, Object?>? metadata,
  }) {
    final stateData = ScreenStateData(
      state: state,
      screenName: screenName,
      metadata: metadata,
    );
    _api.onScreenStateChanged(stateData);
  }

  /// Notify native that screen gained focus
  ///
  /// Use this when the screen becomes active and visible.
  /// Native can use this to resume videos or start tracking.
  ///
  /// [screenName] The name of the screen
  /// [metadata] Optional additional metadata
  void notifyScreenFocused({
    required String screenName,
    Map<String?, Object?>? metadata,
  }) {
    notifyScreenStateChanged(
      state: 'focused',
      screenName: screenName,
      metadata: metadata,
    );
  }

  /// Notify native that screen lost focus
  ///
  /// Use this when the screen becomes inactive (navigated away).
  /// Native can use this to pause videos or stop tracking.
  ///
  /// [screenName] The name of the screen
  /// [metadata] Optional additional metadata
  void notifyScreenUnfocused({
    required String screenName,
    Map<String?, Object?>? metadata,
  }) {
    notifyScreenStateChanged(
      state: 'unfocused',
      screenName: screenName,
      metadata: metadata,
    );
  }

  /// Notify native that video state changed
  ///
  /// Common states:
  /// - "playing" - Video is currently playing
  /// - "paused" - Video is paused
  /// - "stopped" - Video playback stopped
  /// - "buffering" - Video is buffering/loading
  /// - "completed" - Video finished playing
  ///
  /// [videoId] The ID of the video
  /// [state] The new video state
  /// [position] Optional current playback position in seconds
  /// [duration] Optional total video duration in seconds
  void notifyVideoStateChanged({
    required String videoId,
    required String state,
    double? position,
    double? duration,
  }) {
    final stateData = VideoStateData(
      videoId: videoId,
      state: state,
      position: position,
      duration: duration,
    );
    _api.onVideoStateChanged(stateData);
  }

  /// Notify native that video started playing
  ///
  /// [videoId] The ID of the video
  /// [position] Optional current playback position
  /// [duration] Optional total video duration
  void notifyVideoPlaying({
    required String videoId,
    double? position,
    double? duration,
  }) {
    notifyVideoStateChanged(
      videoId: videoId,
      state: 'playing',
      position: position,
      duration: duration,
    );
  }

  /// Notify native that video was paused
  ///
  /// [videoId] The ID of the video
  /// [position] Optional current playback position
  /// [duration] Optional total video duration
  void notifyVideoPaused({
    required String videoId,
    double? position,
    double? duration,
  }) {
    notifyVideoStateChanged(
      videoId: videoId,
      state: 'paused',
      position: position,
      duration: duration,
    );
  }

  /// Notify native that video stopped
  ///
  /// [videoId] The ID of the video
  /// [position] Optional final playback position
  /// [duration] Optional total video duration
  void notifyVideoStopped({
    required String videoId,
    double? position,
    double? duration,
  }) {
    notifyVideoStateChanged(
      videoId: videoId,
      state: 'stopped',
      position: position,
      duration: duration,
    );
  }

  /// Notify native that video is buffering
  ///
  /// [videoId] The ID of the video
  /// [position] Optional current playback position
  /// [duration] Optional total video duration
  void notifyVideoBuffering({
    required String videoId,
    double? position,
    double? duration,
  }) {
    notifyVideoStateChanged(
      videoId: videoId,
      state: 'buffering',
      position: position,
      duration: duration,
    );
  }

  /// Notify native that video playback completed
  ///
  /// [videoId] The ID of the video
  /// [duration] Optional total video duration
  void notifyVideoCompleted({
    required String videoId,
    double? duration,
  }) {
    notifyVideoStateChanged(
      videoId: videoId,
      state: 'completed',
      position: duration,
      duration: duration,
    );
  }
}
