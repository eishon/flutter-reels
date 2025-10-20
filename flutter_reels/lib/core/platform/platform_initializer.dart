import 'package:flutter/services.dart';
import 'package:flutter_reels/core/services/access_token_service.dart';
import 'package:flutter_reels/core/services/analytics_service.dart';
import 'package:flutter_reels/core/platform/messages.g.dart';

/// Platform initialization result
class PlatformServices {
  const PlatformServices({
    required this.accessTokenService,
    required this.analyticsService,
  });

  final AccessTokenService accessTokenService;
  final AnalyticsService analyticsService;
}

/// Implementation of FlutterReelsAnalyticsApi that sends events to native
class _FlutterAnalyticsApiImpl extends FlutterReelsAnalyticsApi {
  static const MessageCodec<Object?> _codec = FlutterReelsAnalyticsApi.pigeonChannelCodec;
  static const String _channelName = 'dev.flutter.pigeon.flutter_reels.FlutterReelsAnalyticsApi.trackEvent';

  @override
  void trackEvent(AnalyticsEvent event) {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
      _channelName,
      _codec,
    );

    channel.send(<Object?>[event]);
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
    );
  }
}
