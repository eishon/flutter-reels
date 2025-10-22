import 'package:flutter/services.dart';
import '../pigeon_generated.dart';
import '../services/access_token_service.dart';
import '../services/analytics_service.dart';
import '../services/button_events_service.dart';
import '../services/navigation_events_service.dart';
import '../services/state_events_service.dart';

/// Platform initialization result
class PlatformServices {
  const PlatformServices({
    required this.accessTokenService,
    required this.analyticsService,
    required this.buttonEventsService,
    required this.stateEventsService,
    required this.navigationEventsService,
  });

  final AccessTokenService accessTokenService;
  final AnalyticsService analyticsService;
  final ButtonEventsService buttonEventsService;
  final StateEventsService stateEventsService;
  final NavigationEventsService navigationEventsService;
}

/// Implementation of ReelsFlutterAnalyticsApi that sends events to native
class _ReelsAnalyticsApiImpl extends ReelsFlutterAnalyticsApi {
  static const MessageCodec<Object?> _codec =
      ReelsFlutterAnalyticsApi.pigeonChannelCodec;
  static const String _channelName =
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterAnalyticsApi.trackEvent';

  @override
  void trackEvent(AnalyticsEvent event) {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
      _channelName,
      _codec,
    );

    channel.send(<Object?>[event]);
  }
}

/// Implementation of ReelsFlutterButtonEventsApi that sends events to native
class _ReelsButtonEventsApiImpl extends ReelsFlutterButtonEventsApi {
  static const MessageCodec<Object?> _codec =
      ReelsFlutterButtonEventsApi.pigeonChannelCodec;

  @override
  void onBeforeLikeButtonClick(String videoId) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterButtonEventsApi.onBeforeLikeButtonClick',
      _codec,
    );
    channel.send(<Object?>[videoId]);
  }

  @override
  void onAfterLikeButtonClick(String videoId, bool isLiked, int likeCount) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterButtonEventsApi.onAfterLikeButtonClick',
      _codec,
    );
    channel.send(<Object?>[videoId, isLiked, likeCount]);
  }

  @override
  void onShareButtonClick(ShareData shareData) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterButtonEventsApi.onShareButtonClick',
      _codec,
    );
    channel.send(<Object?>[shareData]);
  }
}

/// Implementation of ReelsFlutterStateApi that sends state events to native
class _ReelsStateApiImpl extends ReelsFlutterStateApi {
  static const MessageCodec<Object?> _codec =
      ReelsFlutterStateApi.pigeonChannelCodec;

  @override
  void onScreenStateChanged(ScreenStateData state) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterStateApi.onScreenStateChanged',
      _codec,
    );
    channel.send(<Object?>[state]);
  }

  @override
  void onVideoStateChanged(VideoStateData state) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterStateApi.onVideoStateChanged',
      _codec,
    );
    channel.send(<Object?>[state]);
  }
}

/// Implementation of ReelsFlutterNavigationApi that sends navigation events to native
class _ReelsNavigationApiImpl extends ReelsFlutterNavigationApi {
  static const MessageCodec<Object?> _codec =
      ReelsFlutterNavigationApi.pigeonChannelCodec;

  @override
  void onSwipeLeft() {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterNavigationApi.onSwipeLeft',
      _codec,
    );
    channel.send(null);
  }

  @override
  void onSwipeRight() {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.reels_flutter.ReelsFlutterNavigationApi.onSwipeRight',
      _codec,
    );
    channel.send(null);
  }
}

/// Initializes platform communication channels
///
/// This sets up the Pigeon APIs that handle communication between
/// Flutter and native platforms (Android/iOS).
class PlatformInitializer {
  /// Initialize all platform APIs
  ///
  /// This should be called once during app initialization, before
  /// any other platform communication occurs.
  ///
  /// Returns [PlatformServices] with configured services.
  static PlatformServices initializePlatformAPIs() {
    print('[ReelsFlutter] Initializing platform APIs...');

    // Create access token service with callback to native
    final accessTokenService = AccessTokenService(
      getTokenCallback: () async {
        try {
          // Call native platform directly via method channel
          // This matches the Pigeon-generated channel name for ReelsFlutterTokenApi
          const channel = BasicMessageChannel<Object?>(
            'dev.flutter.pigeon.reels_flutter.ReelsFlutterTokenApi.getAccessToken',
            StandardMessageCodec(),
          );

          final result = await channel.send(null);
          print(
            '[ReelsFlutter] Access token retrieved: ${result != null ? "yes" : "no"}',
          );
          return result as String?;
        } catch (e) {
          print('[ReelsFlutter] Error getting access token from native: $e');
          return null;
        }
      },
    );

    // Create analytics service
    final analyticsApi = _ReelsAnalyticsApiImpl();
    final analyticsService = AnalyticsService(api: analyticsApi);
    print('[ReelsFlutter] Analytics service initialized');

    // Create button events service
    final buttonEventsApi = _ReelsButtonEventsApiImpl();
    final buttonEventsService = ButtonEventsService(api: buttonEventsApi);
    print('[ReelsFlutter] Button events service initialized');

    // Create state events service
    final stateEventsApi = _ReelsStateApiImpl();
    final stateEventsService = StateEventsService(api: stateEventsApi);
    print('[ReelsFlutter] State events service initialized');

    // Create navigation events service
    final navigationEventsApi = _ReelsNavigationApiImpl();
    final navigationEventsService = NavigationEventsService(
      api: navigationEventsApi,
    );
    print('[ReelsFlutter] Navigation events service initialized');

    print('[ReelsFlutter] Platform APIs initialization complete');

    return PlatformServices(
      accessTokenService: accessTokenService,
      analyticsService: analyticsService,
      buttonEventsService: buttonEventsService,
      stateEventsService: stateEventsService,
      navigationEventsService: navigationEventsService,
    );
  }
}
