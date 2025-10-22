import '../pigeon_generated.dart';

/// Service for navigation event communication with native platform
class NavigationEventsService {
  NavigationEventsService({required this.api});

  final ReelsFlutterNavigationApi api;

  /// Called when user swipes left (navigate back)
  void onSwipeLeft() {
    try {
      api.onSwipeLeft();
      print('[ReelsFlutter] Swipe left detected - navigating back');
    } catch (e) {
      print('[ReelsFlutter] Error on swipe left: $e');
    }
  }

  /// Called when user swipes right (open detail/profile)
  void onSwipeRight() {
    try {
      api.onSwipeRight();
      print('[ReelsFlutter] Swipe right detected - opening detail');
    } catch (e) {
      print('[ReelsFlutter] Error on swipe right: $e');
    }
  }

  // Legacy compatibility wrapper methods

  /// Notify swipe left (legacy method name)
  void notifySwipeLeft({int? currentIndex}) {
    onSwipeLeft();
  }

  /// Notify swipe right (legacy method name)
  void notifySwipeRight({int? currentIndex}) {
    onSwipeRight();
  }
}
