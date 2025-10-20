import 'package:flutter_reels/core/platform/messages.g.dart';

/// Service for tracking analytics events to native platform
///
/// This service wraps the FlutterReelsAnalyticsApi to send analytics
/// events to the native platform's analytics SDK (Firebase, Mixpanel, etc.)
class AnalyticsService {
  /// Creates an analytics service
  ///
  /// [api] The native analytics API implementation
  AnalyticsService({required FlutterReelsAnalyticsApi api}) : _api = api;

  final FlutterReelsAnalyticsApi _api;

  /// Track a generic event
  ///
  /// [eventType] The type of the event
  /// [data] Optional event data/parameters
  void trackEvent(String eventType, {Map<String?, Object?>? data}) {
    final event = AnalyticsEvent(
      type: eventType,
      data: data ?? {},
    );
    _api.trackEvent(event);
  }

  /// Track video appearance (when video becomes visible)
  ///
  /// [videoId] The ID of the video that appeared
  /// [position] The position in the list
  /// [screenName] The name of the screen
  void trackVideoAppear({
    required String videoId,
    int? position,
    String? screenName,
  }) {
    trackEvent('appear', data: {
      'video_id': videoId,
      if (position != null) 'position': position,
      if (screenName != null) 'screen': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track video click/tap
  ///
  /// [videoId] The ID of the video that was clicked
  /// [element] The element that was clicked (e.g., 'video', 'product', 'avatar')
  /// [position] The position in the list
  void trackVideoClick({
    required String videoId,
    required String element,
    int? position,
  }) {
    trackEvent('click', data: {
      'video_id': videoId,
      'element': element,
      if (position != null) 'position': position,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track page view
  ///
  /// [screenName] The name of the screen/page
  /// [metadata] Optional additional metadata
  void trackPageView({
    required String screenName,
    Map<String?, Object?>? metadata,
  }) {
    trackEvent('page_view', data: {
      'screen': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      if (metadata != null) ...metadata,
    });
  }

  /// Track like button click
  ///
  /// [videoId] The ID of the video
  /// [isLiked] Whether the video is liked after the action
  /// [likeCount] The updated like count
  void trackLike({
    required String videoId,
    required bool isLiked,
    required int likeCount,
  }) {
    trackEvent('like', data: {
      'video_id': videoId,
      'is_liked': isLiked,
      'like_count': likeCount,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track share button click
  ///
  /// [videoId] The ID of the video
  /// [shareType] The type of share (e.g., 'native_share', 'copy_link')
  void trackShare({
    required String videoId,
    String? shareType,
  }) {
    trackEvent('share', data: {
      'video_id': videoId,
      if (shareType != null) 'share_type': shareType,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track video playback start
  ///
  /// [videoId] The ID of the video
  /// [duration] The total duration of the video
  void trackVideoStart({
    required String videoId,
    double? duration,
  }) {
    trackEvent('video_start', data: {
      'video_id': videoId,
      if (duration != null) 'duration': duration,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track video playback completion
  ///
  /// [videoId] The ID of the video
  /// [duration] The total duration watched
  /// [completionRate] The percentage of video watched (0.0 - 1.0)
  void trackVideoComplete({
    required String videoId,
    double? duration,
    double? completionRate,
  }) {
    trackEvent('video_complete', data: {
      'video_id': videoId,
      if (duration != null) 'duration': duration,
      if (completionRate != null) 'completion_rate': completionRate,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track error
  ///
  /// [errorType] The type/category of error
  /// [errorMessage] The error message
  /// [videoId] Optional video ID if error is related to a video
  void trackError({
    required String errorType,
    required String errorMessage,
    String? videoId,
  }) {
    trackEvent('error', data: {
      'error_type': errorType,
      'error_message': errorMessage,
      if (videoId != null) 'video_id': videoId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
