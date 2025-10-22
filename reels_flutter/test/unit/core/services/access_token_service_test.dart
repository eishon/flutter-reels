import 'package:flutter_test/flutter_test.dart';
import 'package:reels_flutter/core/services/access_token_service.dart';

void main() {
  group('AccessTokenService', () {
    late AccessTokenService service;

    group('getAccessToken', () {
      test('should return token when callback succeeds', () async {
        // Arrange
        const expectedToken = 'test_token_12345';
        service = AccessTokenService(
          getTokenCallback: () async => expectedToken,
        );

        // Act
        final result = await service.getAccessToken();

        // Assert
        expect(result, expectedToken);
      });

      test('should return null when callback returns null', () async {
        // Arrange
        service = AccessTokenService(
          getTokenCallback: () async => null,
        );

        // Act
        final result = await service.getAccessToken();

        // Assert
        expect(result, isNull);
      });

      test('should return null when callback throws error', () async {
        // Arrange
        service = AccessTokenService(
          getTokenCallback: () async => throw Exception('Token error'),
        );

        // Act
        final result = await service.getAccessToken();

        // Assert
        expect(result, isNull);
      });

      test('should handle empty string token', () async {
        // Arrange
        service = AccessTokenService(
          getTokenCallback: () async => '',
        );

        // Act
        final result = await service.getAccessToken();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getToken (legacy method)', () {
      test('should return same result as getAccessToken', () async {
        // Arrange
        const expectedToken = 'legacy_token_67890';
        service = AccessTokenService(
          getTokenCallback: () async => expectedToken,
        );

        // Act
        final accessTokenResult = await service.getAccessToken();
        final getTokenResult = await service.getToken();

        // Assert
        expect(getTokenResult, accessTokenResult);
        expect(getTokenResult, expectedToken);
      });

      test('should return null when callback fails', () async {
        // Arrange
        service = AccessTokenService(
          getTokenCallback: () async => throw Exception('Token error'),
        );

        // Act
        final result = await service.getToken();

        // Assert
        expect(result, isNull);
      });
    });

    group('error handling', () {
      test('should not throw exception on error', () async {
        // Arrange
        service = AccessTokenService(
          getTokenCallback: () async => throw Exception('Critical error'),
        );

        // Act & Assert - should not throw
        expect(
          () async => await service.getAccessToken(),
          returnsNormally,
        );
      });

      test('should handle timeout error gracefully', () async {
        // Arrange
        service = AccessTokenService(
          getTokenCallback: () async {
            await Future.delayed(const Duration(milliseconds: 10));
            throw TimeoutException('Token timeout');
          },
        );

        // Act
        final result = await service.getAccessToken();

        // Assert
        expect(result, isNull);
      });
    });
  });
}

class TimeoutException implements Exception {
  TimeoutException(this.message);
  final String message;

  @override
  String toString() => 'TimeoutException: $message';
}
