import 'package:flutter/services.dart';
import 'package:flutter_reels/core/services/access_token_service.dart';
import 'package:flutter_reels/core/services/analytics_service.dart';
import 'package:flutter_reels/core/services/button_events_service.dart';
import 'package:flutter_reels/core/services/navigation_events_service.dart';
import 'package:flutter_reels/core/services/state_events_service.dart';
import 'package:flutter_reels/core/platform/messages.g.dart';

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

/// Implementation of FlutterReelsAnalyticsApi that sends events to native
class _FlutterAnalyticsApiImpl extends FlutterReelsAnalyticsApi {
  static const MessageCodec<Object?> _codec =
      FlutterReelsAnalyticsApi.pigeonChannelCodec;
  static const String _channelName =
      'dev.flutter.pigeon.flutter_reels.FlutterReelsAnalyticsApi.trackEvent';

  @override
  void trackEvent(AnalyticsEvent event) {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
      _channelName,
      _codec,
    );

    channel.send(<Object?>[event]);
  }
}

/// Implementation of FlutterReelsButtonEventsApi that sends events to native
class _FlutterButtonEventsApiImpl extends FlutterReelsButtonEventsApi {
  static const MessageCodec<Object?> _codec =
      FlutterReelsButtonEventsApi.pigeonChannelCodec;

  @override
  void onBeforeLikeButtonClick(String videoId) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.flutter_reels.FlutterReelsButtonEventsApi.onBeforeLikeButtonClick',
      _codec,
    );
    channel.send(<Object?>[videoId]);
  }

  @override
  void onAfterLikeButtonClick(String videoId, bool isLiked, int likeCount) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.flutter_reels.FlutterReelsButtonEventsApi.onAfterLikeButtonClick',
      _codec,
    );
    channel.send(<Object?>[videoId, isLiked, likeCount]);
  }

  @override
  void onShareButtonClick(ShareData shareData) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.flutter_reels.FlutterReelsButtonEventsApi.onShareButtonClick',
      _codec,
    );
    channel.send(<Object?>[shareData]);
  }
}

/// Implementation of FlutterReelsStateApi that sends state events to native
class _FlutterStateApiImpl extends FlutterReelsStateApi {
  static const MessageCodec<Object?> _codec =
      FlutterReelsStateApi.pigeonChannelCodec;

  @override
  void onScreenStateChanged(ScreenStateData state) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.flutter_reels.FlutterReelsStateApi.onScreenStateChanged',
      _codec,
    );
    channel.send(<Object?>[state]);
  }

  @override
  void onVideoStateChanged(VideoStateData state) {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.flutter_reels.FlutterReelsStateApi.onVideoStateChanged',
      _codec,
    );
    channel.send(<Object?>[state]);
  }
}

/// Implementation of FlutterReelsNavigationApi that sends navigation events to native
class _FlutterNavigationApiImpl extends FlutterReelsNavigationApi {
  static const MessageCodec<Object?> _codec =
      FlutterReelsNavigationApi.pigeonChannelCodec;

  @override
  void onSwipeLeft() {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.flutter_reels.FlutterReelsNavigationApi.onSwipeLeft',
      _codec,
    );
    channel.send(null);
  }

  @override
  void onSwipeRight() {
    const channel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.flutter_reels.FlutterReelsNavigationApi.onSwipeRight',
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
    // Create access token service with callback to native
    final accessTokenService = AccessTokenService(
      getTokenCallback: () async {
        try {
          // Call native platform directly via method channel
          // This matches the Pigeon-generated channel name for FlutterReelsTokenApi
          const channel = BasicMessageChannel<Object?>(
            'dev.flutter.pigeon.flutter_reels.FlutterReelsTokenApi.getAccessToken',
            StandardMessageCodec(),
          );

          final result = await channel.send(null);
          return result as String?;
        } catch (e) {
          // Log error or handle as needed
          print('Error getting access token from native: $e');
          return null;
        }
      },
    );

    // Create analytics service
    // Native must call FlutterReelsAnalyticsApi.setup() to receive events
    final analyticsApi = _FlutterAnalyticsApiImpl();
    final analyticsService = AnalyticsService(api: analyticsApi);

    // Create button events service
    // Native must call FlutterReelsButtonEventsApi.setup() to receive events
    final buttonEventsApi = _FlutterButtonEventsApiImpl();
    final buttonEventsService = ButtonEventsService(api: buttonEventsApi);

    // Create state events service
    // Native must call FlutterReelsStateApi.setup() to receive events
    final stateEventsApi = _FlutterStateApiImpl();
    final stateEventsService = StateEventsService(api: stateEventsApi);

    // Create navigation events service
    // Native must call FlutterReelsNavigationApi.setup() to receive events
    final navigationEventsApi = _FlutterNavigationApiImpl();
    final navigationEventsService =
        NavigationEventsService(api: navigationEventsApi);

    // Note: Other APIs are set up by native platforms
    // Native side must call:
    // - FlutterReelsHostApi.setup() to handle pause/resume
    // - FlutterReelsTokenApi.setup() to provide token
    // - FlutterReelsAnalyticsApi.setup() to receive analytics
    // - FlutterReelsButtonEventsApi.setup() to receive button events
    // - FlutterReelsStateApi.setup() to receive state changes
    // - FlutterReelsNavigationApi.setup() to handle navigation

    return PlatformServices(
      accessTokenService: accessTokenService,
      analyticsService: analyticsService,
      buttonEventsService: buttonEventsService,
      stateEventsService: stateEventsService,
      navigationEventsService: navigationEventsService,
    );
  }
}
