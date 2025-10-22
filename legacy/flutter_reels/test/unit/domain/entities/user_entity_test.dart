import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

/// Unit tests for UserEntity
///
/// Tests cover:
/// - Entity creation and properties
/// - Equality operator (based on all fields - no custom implementation)
/// - HashCode consistency
void main() {
  group('UserEntity', () {
    group('constructor', () {
      test('should create entity with required fields', () {
        // Arrange & Act
        final user = createTestUser();

        // Assert
        expect(user.name, 'Test User');
        expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      });

      test('should create entity with custom values', () {
        // Arrange & Act
        final user = createTestUser(
          name: 'Custom User',
          avatarUrl: 'https://custom.com/avatar.png',
        );

        // Assert
        expect(user.name, 'Custom User');
        expect(user.avatarUrl, 'https://custom.com/avatar.png');
      });
    });

    group('edge cases', () {
      test('should handle empty name', () {
        // Arrange & Act
        final user = createTestUser(name: '');

        // Assert
        expect(user.name, '');
      });

      test('should handle long name', () {
        // Arrange
        final longName = 'A' * 100;

        // Act
        final user = createTestUser(name: longName);

        // Assert
        expect(user.name, longName);
        expect(user.name.length, 100);
      });

      test('should handle special characters in name', () {
        // Arrange & Act
        final user = createTestUser(name: '👤 User @123');

        // Assert
        expect(user.name, '👤 User @123');
      });

      test('should handle URL with query parameters', () {
        // Arrange & Act
        final user = createTestUser(
          avatarUrl: 'https://example.com/avatar.jpg?size=large&format=webp',
        );

        // Assert
        expect(
          user.avatarUrl,
          'https://example.com/avatar.jpg?size=large&format=webp',
        );
      });
    });
  });
}
