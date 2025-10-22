/// Service for retrieving access tokens from native platforms
///
/// This service provides a mechanism to get valid access tokens on-demand
/// from the native side. The native platform is responsible for:
/// - Managing token storage and refresh
/// - Ensuring token validity
/// - Handling authentication state
///
/// Flutter side simply requests the token when needed (API calls, etc.)
class AccessTokenService {
  AccessTokenService({
    required this.getTokenCallback,
  });

  /// Callback to retrieve current valid token from native platform
  ///
  /// This should be provided by the native platform during initialization.
  /// The native side should:
  /// - Return current valid token
  /// - Return null if user is not authenticated
  /// - Handle token refresh if needed before returning
  final Future<String?> Function() getTokenCallback;

  /// Get the current valid access token
  ///
  /// This method calls the native platform to retrieve the current token.
  /// Use this whenever you need a token for API calls, analytics, etc.
  ///
  /// Returns:
  /// - A valid access token if user is authenticated
  /// - null if user is not authenticated or token is unavailable
  ///
  /// Example:
  /// ```dart
  /// final token = await accessTokenService.getToken();
  /// if (token != null) {
  ///   // Make authenticated API call
  ///   api.fetch(headers: {'Authorization': 'Bearer $token'});
  /// }
  /// ```
  Future<String?> getToken() async {
    return await getTokenCallback();
  }

  /// Check if a valid token is available
  ///
  /// This is a convenience method that checks if getToken() returns a non-null value.
  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
