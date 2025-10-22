import '../pigeon_generated.dart';

/// Service for state event communication with native platform
class StateEventsService {
  StateEventsService({required this.api});

  final ReelsFlutterStateApi api;

  /// Notify native about screen state changes
  void onScreenStateChanged({
    required String state,
    required String screenName,
    int? timestamp,
  }) {
    try {
      final stateData = ScreenStateData(
        state: state,
        screenName: screenName,
        timestamp: timestamp,
      );
      api.onScreenStateChanged(stateData);
      print('[ReelsFlutter] Screen state changed: $screenName - $state');
    } catch (e) {
      print('[ReelsFlutter] Error on screen state change: $e');
    }
  }

  /// Notify native about video state changes
  void onVideoStateChanged({
    required String videoId,
    required String state,
    double? position,
    double? duration,
  }) {
    try {
      final stateData = VideoStateData(
        videoId: videoId,
        state: state,
        position: position?.toInt(),
        duration: duration?.toInt(),
      );
      api.onVideoStateChanged(stateData);
      print('[ReelsFlutter] Video state changed: $videoId - $state');
    } catch (e) {
      print('[ReelsFlutter] Error on video state change: $e');
    }
  }

  /// Helper: Screen appeared
  void screenAppeared(String screenName) {
    onScreenStateChanged(
      state: 'appeared',
      screenName: screenName,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Helper: Screen disappeared
  void screenDisappeared(String screenName) {
    onScreenStateChanged(state: 'disappeared', screenName: screenName);
  }

  /// Helper: Screen focused
  void screenFocused(String screenName) {
    onScreenStateChanged(state: 'focused', screenName: screenName);
  }

  /// Helper: Screen unfocused
  void screenUnfocused(String screenName) {
    onScreenStateChanged(state: 'unfocused', screenName: screenName);
  }

  /// Helper: Video playing
  void videoPlaying(String videoId, {double? position, double? duration}) {
    onVideoStateChanged(
      videoId: videoId,
      state: 'playing',
      position: position,
      duration: duration,
    );
  }

  /// Helper: Video paused
  void videoPaused(String videoId, {double? position, double? duration}) {
    onVideoStateChanged(
      videoId: videoId,
      state: 'paused',
      position: position,
      duration: duration,
    );
  }

  /// Helper: Video stopped
  void videoStopped(String videoId) {
    onVideoStateChanged(videoId: videoId, state: 'stopped');
  }

  /// Helper: Video buffering
  void videoBuffering(String videoId) {
    onVideoStateChanged(videoId: videoId, state: 'buffering');
  }

  /// Helper: Video completed
  void videoCompleted(String videoId, double duration) {
    onVideoStateChanged(
      videoId: videoId,
      state: 'completed',
      duration: duration,
    );
  }

  // Legacy compatibility wrapper methods

  /// Notify screen focused (legacy method name)
  void notifyScreenFocused({required String screenName}) {
    screenFocused(screenName);
  }

  /// Notify screen unfocused (legacy method name)
  void notifyScreenUnfocused({required String screenName}) {
    screenUnfocused(screenName);
  }
}
