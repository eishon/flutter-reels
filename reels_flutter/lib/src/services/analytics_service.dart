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
}
