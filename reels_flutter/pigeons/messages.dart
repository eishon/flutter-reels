import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/pigeon_generated.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/eishon/reels_flutter/PigeonGenerated.kt',
    kotlinOptions: KotlinOptions(package: 'com.eishon.reels_flutter'),
    swiftOut: 'ios/Classes/PigeonGenerated.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'reels_flutter',
  ),
)
// ============================================================================
// DATA MODELS
// ============================================================================
/// Analytics event data
class AnalyticsEvent {
  const AnalyticsEvent({
    required this.eventName,
    required this.eventProperties,
  });

  final String eventName;
  final Map<String?, String?> eventProperties;
}

/// Share data for social sharing
class ShareData {
  const ShareData({
    required this.videoId,
    required this.videoUrl,
    required this.title,
    required this.description,
    this.thumbnailUrl,
  });

  final String videoId;
  final String videoUrl;
  final String title;
  final String description;
  final String? thumbnailUrl;
}

/// Screen state data for native tracking
class ScreenStateData {
  const ScreenStateData({
    required this.screenName,
    required this.state,
    this.timestamp,
  });

  final String screenName;
  final String state; // appeared, disappeared, focused, unfocused
  final int? timestamp;
}

/// Video state data for playback tracking
class VideoStateData {
  const VideoStateData({
    required this.videoId,
    required this.state,
    this.position,
    this.duration,
    this.timestamp,
  });

  final String videoId;
  final String state; // playing, paused, stopped, buffering, completed
  final int? position; // in seconds
  final int? duration; // in seconds
  final int? timestamp;
}

// ============================================================================
// HOST APIs (Flutter calls Native)
// ============================================================================

/// API for accessing user authentication token from native
@HostApi()
abstract class ReelsFlutterTokenApi {
  /// Get the current access token from native platform
  String? getAccessToken();
}

/// API for sending analytics events to native analytics SDK
@FlutterApi()
abstract class ReelsFlutterAnalyticsApi {
  /// Track a custom analytics event
  void trackEvent(AnalyticsEvent event);
}

/// API for notifying native about button interactions
@FlutterApi()
abstract class ReelsFlutterButtonEventsApi {
  /// Called before like button is clicked (for optimistic UI)
  void onBeforeLikeButtonClick(String videoId);

  /// Called after like button click completes (with updated state)
  void onAfterLikeButtonClick(String videoId, bool isLiked, int likeCount);

  /// Called when share button is clicked
  void onShareButtonClick(ShareData shareData);
}

/// API for notifying native about screen and video state changes
@FlutterApi()
abstract class ReelsFlutterStateApi {
  /// Notify native when screen state changes
  void onScreenStateChanged(ScreenStateData state);

  /// Notify native when video state changes
  void onVideoStateChanged(VideoStateData state);
}

/// API for handling navigation gestures
@FlutterApi()
abstract class ReelsFlutterNavigationApi {
  /// Called when user swipes left
  void onSwipeLeft();

  /// Called when user swipes right
  void onSwipeRight();
}
