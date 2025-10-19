import 'dart:convert';

import 'package:flutter_reels/data/models/user_model.dart';
import 'package:flutter_reels/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for UserModel
///
/// Tests cover:
/// - fromJson: deserialization from JSON (userName, userAvatar fields)
/// - toJson: serialization to JSON
/// - toEntity: conversion to domain entity
/// - Edge cases and field mapping
void main() {
  group('UserModel', () {
    final testUserJson = {
      'userName': 'Test User',
      'userAvatar': 'https://example.com/avatar.jpg',
    };

    group('fromJson', () {
      test('should create model from valid JSON', () {
        // Act
        final model = UserModel.fromJson(testUserJson);

        // Assert
        expect(model.name, 'Test User');
        expect(model.avatarUrl, 'https://example.com/avatar.jpg');
      });

      test('should correctly map userName to name', () {
        // Arrange
        final json = {
          'userName': 'John Doe',
          'userAvatar': 'https://example.com/john.jpg',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.name, 'John Doe');
      });

      test('should correctly map userAvatar to avatarUrl', () {
        // Arrange
        final json = {
          'userName': 'Jane Doe',
          'userAvatar': 'https://example.com/jane.jpg',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.avatarUrl, 'https://example.com/jane.jpg');
      });

      test('should handle empty strings', () {
        // Arrange
        final json = {
          'userName': '',
          'userAvatar': '',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.name, '');
        expect(model.avatarUrl, '');
      });

      test('should handle special characters in name', () {
        // Arrange
        final json = {
          'userName': '👤 User @123 #test',
          'userAvatar': 'https://example.com/avatar.jpg',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.name, '👤 User @123 #test');
      });

      test('should handle URLs with query parameters', () {
        // Arrange
        final json = {
          'userName': 'Test User',
          'userAvatar': 'https://example.com/avatar.jpg?size=large&format=webp',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.avatarUrl,
            'https://example.com/avatar.jpg?size=large&format=webp');
      });

      test('should handle very long names', () {
        // Arrange
        final longName = 'A' * 500;
        final json = {
          'userName': longName,
          'userAvatar': 'https://example.com/avatar.jpg',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.name.length, 500);
        expect(model.name, longName);
      });
    });

    group('toJson', () {
      test('should convert model to JSON', () {
        // Arrange
        final model = UserModel(
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['userName'], 'Test User');
        expect(json['userAvatar'], 'https://example.com/avatar.jpg');
      });

      test('should map name to userName', () {
        // Arrange
        final model = UserModel(
          name: 'John Doe',
          avatarUrl: 'https://example.com/john.jpg',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json.containsKey('userName'), true);
        expect(json.containsKey('name'), false);
        expect(json['userName'], 'John Doe');
      });

      test('should map avatarUrl to userAvatar', () {
        // Arrange
        final model = UserModel(
          name: 'Jane Doe',
          avatarUrl: 'https://example.com/jane.jpg',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json.containsKey('userAvatar'), true);
        expect(json.containsKey('avatarUrl'), false);
        expect(json['userAvatar'], 'https://example.com/jane.jpg');
      });

      test('should handle empty strings', () {
        // Arrange
        final model = UserModel(
          name: '',
          avatarUrl: '',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['userName'], '');
        expect(json['userAvatar'], '');
      });

      test('should preserve special characters', () {
        // Arrange
        final model = UserModel(
          name: '👤 User @123',
          avatarUrl: 'https://example.com/avatar.jpg?size=large',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['userName'], '👤 User @123');
        expect(json['userAvatar'], 'https://example.com/avatar.jpg?size=large');
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        // Arrange
        final model = UserModel(
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity, isA<UserEntity>());
        expect(entity.name, 'Test User');
        expect(entity.avatarUrl, 'https://example.com/avatar.jpg');
      });

      test('should create independent entity instance', () {
        // Arrange
        final model = UserModel(
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(identical(model, entity), false);
        expect(entity.name, model.name);
        expect(entity.avatarUrl, model.avatarUrl);
      });

      test('should preserve all data in conversion', () {
        // Arrange
        final model = UserModel(
          name: '👤 Special User @test',
          avatarUrl: 'https://example.com/avatar.jpg?size=large&v=2',
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.name, '👤 Special User @test');
        expect(entity.avatarUrl, 'https://example.com/avatar.jpg?size=large&v=2');
      });
    });

    group('JSON round-trip', () {
      test('should maintain data integrity through fromJson -> toJson', () {
        // Arrange
        final originalJson = Map<String, dynamic>.from(testUserJson);

        // Act
        final model = UserModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson['userName'], originalJson['userName']);
        expect(resultJson['userAvatar'], originalJson['userAvatar']);
      });

      test('should handle JSON string parsing', () {
        // Arrange
        const jsonString = '''
        {
          "userName": "Test User",
          "userAvatar": "https://example.com/avatar.jpg"
        }
        ''';

        // Act
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final model = UserModel.fromJson(jsonMap);

        // Assert
        expect(model.name, 'Test User');
        expect(model.avatarUrl, 'https://example.com/avatar.jpg');
      });

      test('should maintain data through full cycle: JSON -> Model -> Entity -> Model -> JSON', () {
        // Arrange
        final originalJson = testUserJson;

        // Act
        final model1 = UserModel.fromJson(originalJson);
        final entity = model1.toEntity();
        final model2 = UserModel(
          name: entity.name,
          avatarUrl: entity.avatarUrl,
        );
        final finalJson = model2.toJson();

        // Assert
        expect(finalJson['userName'], originalJson['userName']);
        expect(finalJson['userAvatar'], originalJson['userAvatar']);
      });
    });

    group('inheritance', () {
      test('should be a UserEntity', () {
        // Arrange
        final model = UserModel.fromJson(testUserJson);

        // Assert
        expect(model, isA<UserEntity>());
      });

      test('should access entity properties', () {
        // Arrange
        final model = UserModel(
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
        );

        // Assert - Can access UserEntity properties
        expect(model.name, 'Test User');
        expect(model.avatarUrl, 'https://example.com/avatar.jpg');
      });
    });
  });
}
