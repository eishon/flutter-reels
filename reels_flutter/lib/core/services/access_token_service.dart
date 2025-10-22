/// Service for managing access token retrieval from native platform
class AccessTokenService {
  AccessTokenService({required this.getTokenCallback});

  /// Callback to get token from native
  final Future<String?> Function() getTokenCallback;

  /// Get current access token
  Future<String?> getAccessToken() async {
    try {
      return await getTokenCallback();
    } catch (e) {
      print('[ReelsFlutter] Error getting access token: $e');
      return null;
    }
  }

  /// Legacy method name - same as getAccessToken
  Future<String?> getToken() async {
    return await getAccessToken();
  }
}
