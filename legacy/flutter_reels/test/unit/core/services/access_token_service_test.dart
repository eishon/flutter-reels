import 'package:flutter_reels/core/services/access_token_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccessTokenService', () {
    test('should return token from callback', () async {
      // Arrange
      const expectedToken = 'test_token_123';
      final service = AccessTokenService(
        getTokenCallback: () async => expectedToken,
      );

      // Act
      final token = await service.getToken();

      // Assert
      expect(token, expectedToken);
    });

    test('should return null when callback returns null', () async {
      // Arrange
      final service = AccessTokenService(
        getTokenCallback: () async => null,
      );

      // Act
      final token = await service.getToken();

      // Assert
      expect(token, isNull);
    });

    test('should throw error when callback throws error', () async {
      // Arrange
      final service = AccessTokenService(
        getTokenCallback: () async => throw Exception('Token error'),
      );

      // Act & Assert
      expect(
        () async => await service.getToken(),
        throwsException,
      );
    });

    test('hasValidToken should return true when token is available', () async {
      // Arrange
      final service = AccessTokenService(
        getTokenCallback: () async => 'valid_token',
      );

      // Act
      final hasToken = await service.hasValidToken();

      // Assert
      expect(hasToken, isTrue);
    });

    test('hasValidToken should return false when token is null', () async {
      // Arrange
      final service = AccessTokenService(
        getTokenCallback: () async => null,
      );

      // Act
      final hasToken = await service.hasValidToken();

      // Assert
      expect(hasToken, isFalse);
    });

    test('hasValidToken should return false when token is empty', () async {
      // Arrange
      final service = AccessTokenService(
        getTokenCallback: () async => '',
      );

      // Act
      final hasToken = await service.hasValidToken();

      // Assert
      expect(hasToken, isFalse);
    });

    test('should call callback multiple times for multiple requests', () async {
      // Arrange
      var callCount = 0;
      final service = AccessTokenService(
        getTokenCallback: () async {
          callCount++;
          return 'token_$callCount';
        },
      );

      // Act
      final token1 = await service.getToken();
      final token2 = await service.getToken();
      final token3 = await service.getToken();

      // Assert
      expect(token1, 'token_1');
      expect(token2, 'token_2');
      expect(token3, 'token_3');
      expect(callCount, 3);
    });
  });
}
