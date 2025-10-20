// ignore_for_file: one_member_abstracts

import 'package:pigeon/pigeon.dart';

/// Configuration for Pigeon code generation
///
/// This file defines the interfaces for communication between
/// Flutter and native platforms (Android/iOS).
///
/// To generate platform code, run:
/// flutter pub run pigeon --input pigeon/messages.dart

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/core/platform/messages.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/src/main/kotlin/com/example/flutter_reels/Messages.g.kt',
  kotlinOptions: KotlinOptions(
    package: 'com.example.flutter_reels',
  ),
  swiftOut: 'ios/Classes/Messages.g.swift',
  swiftOptions: SwiftOptions(),
  dartPackageName: 'flutter_reels',
))

/// =============================================================================
/// HOST API (Native → Flutter)
/// Methods called BY native platforms TO Flutter
/// =============================================================================

/// Host API for native platforms to communicate with Flutter
///
/// This API allows native code to:
/// - Update access tokens
/// - Control video playback (pause/resume)
/// - Notify Flutter of native screen lifecycle events
@HostApi()
abstract class FlutterReelsHostApi {
  /// Update the access token used for API calls
  ///
  /// This should be called:
  /// - On app launch with initial token
  /// - When token is refreshed
  /// - Before token expires
  ///
  /// [token] The new access token
  void updateAccessToken(String token);

  /// Clear the stored access token
  ///
  /// This should be called:
  /// - On user logout
  /// - When token is invalidated
  void clearAccessToken();

  /// Pause all video playback
  ///
  /// This should be called when:
  /// - Native screen is opened on top of Flutter
  /// - App goes to background
  /// - User receives phone call
  void pauseVideos();

  /// Resume video playback
  ///
  /// This should be called when:
  /// - Native screen is closed
  /// - App returns to foreground
  void resumeVideos();
}

/// =============================================================================
/// FLUTTER API (Flutter → Native)
/// Methods called BY Flutter TO native platforms
/// =============================================================================

/// Analytics API for tracking user events
///
/// Flutter calls these methods to send analytics to native analytics SDK
/// (Firebase, Mixpanel, etc.)
@FlutterApi()
abstract class FlutterReelsAnalyticsApi {
  /// Track an analytics event
  ///
  /// [event] The event to track
  void trackEvent(AnalyticsEvent event);
}

/// Button events API for user interactions
///
/// Flutter calls these methods to notify native code about button clicks
@FlutterApi()
abstract class FlutterReelsButtonEventsApi {
  /// Called BEFORE like button is clicked
  ///
  /// Native can use this to:
  /// - Show loading indicator
  /// - Update UI optimistically
  /// - Log event
  ///
  /// [videoId] The ID of the video being liked
  void onBeforeLikeButtonClick(String videoId);

  /// Called AFTER like action is completed
  ///
  /// Native can use this to:
  /// - Hide loading indicator
  /// - Update final state
  /// - Show feedback
  ///
  /// [videoId] The ID of the video
  /// [isLiked] Whether the video is now liked
  /// [likeCount] The updated like count
  void onAfterLikeButtonClick(String videoId, bool isLiked, int likeCount);

  /// Called when share button is clicked
  ///
  /// Native can use this to:
  /// - Show native share sheet
  /// - Log share event
  /// - Track share source
  ///
  /// [shareData] Data needed for sharing
  void onShareButtonClick(ShareData shareData);
}

/// Screen state API for lifecycle events
///
/// Flutter calls these methods to notify native about screen and video states
@FlutterApi()
abstract class FlutterReelsStateApi {
  /// Called when screen state changes
  ///
  /// [state] The new screen state
  void onScreenStateChanged(ScreenStateData state);

  /// Called when video state changes
  ///
  /// [state] The new video state
  void onVideoStateChanged(VideoStateData state);
}

/// Navigation API for swipe gestures and navigation
///
/// Flutter calls these methods for navigation actions
@FlutterApi()
abstract class FlutterReelsNavigationApi {
  /// Called when user swipes left
  ///
  /// Native should:
  /// - Navigate back (pop current screen)
  void onSwipeLeft();

  /// Called when user swipes right
  ///
  /// Native should:
  /// - Open native detail/profile screen
  /// - Pause Flutter videos automatically
  void onSwipeRight();
}

/// =============================================================================
/// DATA CLASSES
/// =============================================================================

/// Analytics event data
class AnalyticsEvent {
  /// Creates an analytics event
  AnalyticsEvent({
    required this.type,
    required this.data,
  });

  /// Event type: "appear", "click", or "page_view"
  final String type;

  /// Event data as key-value pairs
  ///
  /// Common keys:
  /// - video_id: ID of the video
  /// - element: Name of the clicked element
  /// - screen: Name of the screen
  /// - position: Position in list
  /// - timestamp: Event timestamp
  final Map<String?, Object?> data;
}

/// Share data for native share sheet
class ShareData {
  /// Creates share data
  ShareData({
    required this.videoId,
    required this.videoUrl,
    required this.title,
    required this.description,
    this.thumbnailUrl,
  });

  /// Video ID
  final String videoId;

  /// URL to share
  final String videoUrl;

  /// Title for share
  final String title;

  /// Description for share
  final String description;

  /// Optional thumbnail URL
  final String? thumbnailUrl;
}

/// Screen state data
class ScreenStateData {
  /// Creates screen state data
  ScreenStateData({
    required this.state,
    required this.screenName,
    this.metadata,
  });

  /// State: "focused", "unfocused", "appeared", "disappeared"
  final String state;

  /// Name of the screen
  final String screenName;

  /// Additional metadata
  final Map<String?, Object?>? metadata;
}

/// Video state data
class VideoStateData {
  /// Creates video state data
  VideoStateData({
    required this.videoId,
    required this.state,
    this.position,
    this.duration,
  });

  /// Video ID
  final String videoId;

  /// State: "playing", "paused", "stopped", "buffering", "completed"
  final String state;

  /// Current playback position in seconds
  final double? position;

  /// Total duration in seconds
  final double? duration;
}
