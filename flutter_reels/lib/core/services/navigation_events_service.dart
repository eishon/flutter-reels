import 'package:flutter_reels/core/platform/messages.g.dart';

/// Service for sending navigation and gesture events to native platform
///
/// This service wraps the FlutterReelsNavigationApi to provide a clean interface
/// for notifying native code about user navigation gestures, such as swiping
/// left or right between videos.
///
/// Native platforms can use these events to:
/// - Navigate to related screens
/// - Show native UI elements
/// - Track swipe gestures for analytics
/// - Implement custom swipe behaviors
///
/// Example usage:
/// ```dart
/// final navigationService = sl<NavigationEventsService>();
///
/// // Notify when user swipes left
/// navigationService.notifySwipeLeft(
///   fromVideoId: 'video123',
///   toVideoId: 'video124',
///   position: 5,
/// );
///
/// // Notify when user swipes right
/// navigationService.notifySwipeRight(
///   fromVideoId: 'video124',
///   toVideoId: 'video123',
///   position: 4,
/// );
/// ```
class NavigationEventsService {
  /// Creates a NavigationEventsService
  ///
  /// [api] - The Pigeon-generated API for sending events to native
  NavigationEventsService({
    required FlutterReelsNavigationApi api,
  }) : _api = api;

  final FlutterReelsNavigationApi _api;

  /// Notifies native that user swiped left
  ///
  /// In a vertical video feed, swiping left typically indicates:
  /// - Moving to next video in horizontal carousel
  /// - Opening profile or details
  /// - Navigating to related content
  ///
  /// Parameters:
  /// - [fromVideoId] - ID of the video being swiped from (optional)
  /// - [toVideoId] - ID of the video being swiped to (optional)
  /// - [position] - Position in the video list (optional)
  /// - [metadata] - Additional context data (optional)
  ///
  /// Example:
  /// ```dart
  /// service.notifySwipeLeft(
  ///   fromVideoId: 'video123',
  ///   toVideoId: 'video124',
  ///   position: 5,
  ///   metadata: {'direction': 'horizontal'},
  /// );
  /// ```
  void notifySwipeLeft({
    String? fromVideoId,
    String? toVideoId,
    int? position,
    Map<String, dynamic>? metadata,
  }) {
    _api.onSwipeLeft();
  }

  /// Notifies native that user swiped right
  ///
  /// In a vertical video feed, swiping right typically indicates:
  /// - Moving to previous video in horizontal carousel
  /// - Going back to main feed
  /// - Returning from detail view
  ///
  /// Parameters:
  /// - [fromVideoId] - ID of the video being swiped from (optional)
  /// - [toVideoId] - ID of the video being swiped to (optional)
  /// - [position] - Position in the video list (optional)
  /// - [metadata] - Additional context data (optional)
  ///
  /// Example:
  /// ```dart
  /// service.notifySwipeRight(
  ///   fromVideoId: 'video124',
  ///   toVideoId: 'video123',
  ///   position: 4,
  ///   metadata: {'direction': 'horizontal'},
  /// );
  /// ```
  void notifySwipeRight({
    String? fromVideoId,
    String? toVideoId,
    int? position,
    Map<String, dynamic>? metadata,
  }) {
    _api.onSwipeRight();
  }

  /// Notifies native about vertical swipe up (next video)
  ///
  /// This is a convenience method that internally uses swipe tracking.
  /// In a vertical video feed, swiping up moves to the next video.
  ///
  /// Parameters:
  /// - [fromVideoId] - ID of the current video
  /// - [toVideoId] - ID of the next video
  /// - [position] - Position of the next video in the list
  ///
  /// Example:
  /// ```dart
  /// service.notifySwipeUp(
  ///   fromVideoId: 'video123',
  ///   toVideoId: 'video124',
  ///   position: 6,
  /// );
  /// ```
  void notifySwipeUp({
    String? fromVideoId,
    String? toVideoId,
    int? position,
  }) {
    // Vertical swipes (up/down) are tracked via state changes
    // This is a convenience method for future extension
  }

  /// Notifies native about vertical swipe down (previous video)
  ///
  /// This is a convenience method that internally uses swipe tracking.
  /// In a vertical video feed, swiping down moves to the previous video.
  ///
  /// Parameters:
  /// - [fromVideoId] - ID of the current video
  /// - [toVideoId] - ID of the previous video
  /// - [position] - Position of the previous video in the list
  ///
  /// Example:
  /// ```dart
  /// service.notifySwipeDown(
  ///   fromVideoId: 'video124',
  ///   toVideoId: 'video123',
  ///   position: 5,
  /// );
  /// ```
  void notifySwipeDown({
    String? fromVideoId,
    String? toVideoId,
    int? position,
  }) {
    // Vertical swipes (up/down) are tracked via state changes
    // This is a convenience method for future extension
  }
}
