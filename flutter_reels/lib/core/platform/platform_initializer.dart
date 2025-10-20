import 'package:flutter/services.dart';
import 'package:flutter_reels/core/services/access_token_service.dart';

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
  /// Returns an [AccessTokenService] configured to retrieve tokens from native.
  static AccessTokenService initializePlatformAPIs() {
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

    // Note: Other APIs are set up by native platforms
    // Native side must call:
    // - FlutterReelsHostApi.setup() to handle pause/resume
    // - FlutterReelsTokenApi.setup() to provide token
    // - FlutterReelsAnalyticsApi.setup() to receive analytics
    // - FlutterReelsButtonEventsApi.setup() to receive button events
    // - FlutterReelsStateApi.setup() to receive state changes
    // - FlutterReelsNavigationApi.setup() to handle navigation

    return accessTokenService;
  }
}
