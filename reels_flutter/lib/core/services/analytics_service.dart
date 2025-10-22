import '../pigeon_generated.dart';

/// Service for sending analytics events to native platform
class AnalyticsService {
  AnalyticsService({required this.api});

  final ReelsFlutterAnalyticsApi api;

  /// Track an analytics event
  void trackEvent(String type, Map<String?, Object?> data) {
    try {
      // Convert all values to String? for the Pigeon API
      final properties = data.map(
        (key, value) => MapEntry(key, value?.toString()),
      );
      final event = AnalyticsEvent(
        eventName: type,
        eventProperties: properties,
      );
      api.trackEvent(event);
      print('[ReelsFlutter] Analytics: $type - $data');
    } catch (e) {
      print('[ReelsFlutter] Error tracking event: $e');
    }
  }

  /// Track video view event
  void trackVideoView(String videoId, int position) {
    trackEvent('video_view', {
      'video_id': videoId,
      'position': position,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track page view event
  void trackPageView(String screenName) {
    trackEvent('page_view', {
      'screen': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track element click event
  void trackClick(String element, Map<String?, Object?>? additionalData) {
    final data = <String?, Object?>{
      'element': element,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    if (additionalData != null) {
      data.addAll(additionalData);
    }
    trackEvent('click', data);
  }

  /// Track like event
  void trackLike({
    required String videoId,
    required bool isLiked,
    int? likeCount,
  }) {
    trackEvent('like', {
      'video_id': videoId,
      'is_liked': isLiked,
      if (likeCount != null) 'like_count': likeCount,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track share event
  void trackShare({required String videoId}) {
    trackEvent('share', {
      'video_id': videoId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Track error event
  void trackError({
    required String error,
    String? context,
    Map<String?, Object?>? additionalData,
  }) {
    final data = <String?, Object?>{
      'error': error,
      if (context != null) 'context': context,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    if (additionalData != null) {
      data.addAll(additionalData);
    }
    trackEvent('error', data);
  }

  /// Track video appear event (when video becomes visible)
  void trackVideoAppear({
    required String videoId,
    int? position,
    String? screenName,
  }) {
    trackEvent('appear', {
      'video_id': videoId,
      if (position != null) 'position': position,
      if (screenName != null) 'screen': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
