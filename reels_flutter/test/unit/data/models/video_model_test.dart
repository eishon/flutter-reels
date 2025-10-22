import 'dart:convert';

import 'package:reels_flutter/data/models/video_model.dart';
import 'package:reels_flutter/domain/entities/video_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for VideoModel
///
/// Tests cover:
/// - fromJson: deserialization with nested user and products
/// - toJson: serialization with all nested objects
/// - toEntity: conversion to domain entity
/// - Edge cases: empty products, null handling
void main() {
  group('VideoModel', () {
    final testVideoJson = {
      'id': 'video-1',
      'url': 'https://example.com/video.m3u8',
      'title': 'Test Video',
      'description': 'Test Description',
      'userName': 'Test User',
      'userAvatar': 'https://example.com/avatar.jpg',
      'likes': 100,
      'comments': 50,
      'shares': 25,
      'isLiked': false,
      'category': 'Entertainment',
      'duration': '0:30',
      'quality': '1080p',
      'format': 'HLS',
      'products': [
        {
          'id': 'product-1',
          'name': 'Product 1',
          'description': 'Product Description',
          'price': 99.99,
          'currency': 'USD',
          'imageUrl': 'https://example.com/product.jpg',
          'category': 'Electronics',
          'rating': 4.5,
          'isAvailable': true,
        }
      ],
    };

    group('fromJson', () {
      test('should create model from valid JSON with all fields', () {
        // Act
        final model = VideoModel.fromJson(testVideoJson);

        // Assert
        expect(model.id, 'video-1');
        expect(model.url, 'https://example.com/video.m3u8');
        expect(model.title, 'Test Video');
        expect(model.description, 'Test Description');
        expect(model.user.name, 'Test User');
        expect(model.user.avatarUrl, 'https://example.com/avatar.jpg');
        expect(model.likes, 100);
        expect(model.comments, 50);
        expect(model.shares, 25);
        expect(model.isLiked, false);
        expect(model.category, 'Entertainment');
        expect(model.duration, '0:30');
        expect(model.quality, '1080p');
        expect(model.format, 'HLS');
        expect(model.products.length, 1);
        expect(model.products.first.id, 'product-1');
      });

      test('should create model from JSON without products', () {
        // Arrange
        final jsonWithoutProducts = Map<String, dynamic>.from(testVideoJson)
          ..remove('products');

        // Act
        final model = VideoModel.fromJson(jsonWithoutProducts);

        // Assert
        expect(model.products, isEmpty);
        expect(model.hasProducts, false);
        expect(model.productCount, 0);
      });

      test('should create model with empty products array', () {
        // Arrange
        final jsonWithEmptyProducts = Map<String, dynamic>.from(testVideoJson)
          ..['products'] = [];

        // Act
        final model = VideoModel.fromJson(jsonWithEmptyProducts);

        // Assert
        expect(model.products, isEmpty);
        expect(model.hasProducts, false);
      });

      test('should parse nested user data correctly', () {
        // Arrange
        final json = Map<String, dynamic>.from(testVideoJson)
          ..['userName'] = 'Custom User'
          ..['userAvatar'] = 'https://custom.com/avatar.png';

        // Act
        final model = VideoModel.fromJson(json);

        // Assert
        expect(model.user.name, 'Custom User');
        expect(model.user.avatarUrl, 'https://custom.com/avatar.png');
      });

      test('should parse multiple products correctly', () {
        // Arrange
        final jsonWithMultipleProducts =
            Map<String, dynamic>.from(testVideoJson)
              ..['products'] = [
                {
                  'id': 'product-1',
                  'name': 'Product 1',
                  'description': 'Description 1',
                  'price': 99.99,
                  'currency': 'USD',
                  'imageUrl': 'url1',
                  'category': 'Cat1',
                  'rating': 4.5,
                  'isAvailable': true,
                },
                {
                  'id': 'product-2',
                  'name': 'Product 2',
                  'description': 'Description 2',
                  'price': 199.99,
                  'currency': 'EUR',
                  'imageUrl': 'url2',
                  'category': 'Cat2',
                  'rating': 5.0,
                  'isAvailable': false,
                },
              ];

        // Act
        final model = VideoModel.fromJson(jsonWithMultipleProducts);

        // Assert
        expect(model.products.length, 2);
        expect(model.products[0].id, 'product-1');
        expect(model.products[1].id, 'product-2');
        expect(model.hasProducts, true);
        expect(model.productCount, 2);
      });

      test('should handle isLiked true', () {
        // Arrange
        final jsonLiked = Map<String, dynamic>.from(testVideoJson)
          ..['isLiked'] = true;

        // Act
        final model = VideoModel.fromJson(jsonLiked);

        // Assert
        expect(model.isLiked, true);
      });

      test('should handle zero engagement counts', () {
        // Arrange
        final jsonZeroCounts = Map<String, dynamic>.from(testVideoJson)
          ..['likes'] = 0
          ..['comments'] = 0
          ..['shares'] = 0;

        // Act
        final model = VideoModel.fromJson(jsonZeroCounts);

        // Assert
        expect(model.likes, 0);
        expect(model.comments, 0);
        expect(model.shares, 0);
      });

      test('should handle large engagement counts', () {
        // Arrange
        final jsonLargeCounts = Map<String, dynamic>.from(testVideoJson)
          ..['likes'] = 1000000
          ..['comments'] = 500000
          ..['shares'] = 250000;

        // Act
        final model = VideoModel.fromJson(jsonLargeCounts);

        // Assert
        expect(model.likes, 1000000);
        expect(model.comments, 500000);
        expect(model.shares, 250000);
      });

      test('should handle different video qualities and formats', () {
        // Arrange
        final jsonCustomFormat = Map<String, dynamic>.from(testVideoJson)
          ..['quality'] = '4K'
          ..['format'] = 'MP4'
          ..['duration'] = '10:00';

        // Act
        final model = VideoModel.fromJson(jsonCustomFormat);

        // Assert
        expect(model.quality, '4K');
        expect(model.format, 'MP4');
        expect(model.duration, '10:00');
      });
    });

    group('toJson', () {
      test('should convert model to JSON with all fields', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['id'], 'video-1');
        expect(json['url'], 'https://example.com/video.m3u8');
        expect(json['title'], 'Test Video');
        expect(json['description'], 'Test Description');
        expect(json['userName'], 'Test User');
        expect(json['userAvatar'], 'https://example.com/avatar.jpg');
        expect(json['likes'], 100);
        expect(json['comments'], 50);
        expect(json['shares'], 25);
        expect(json['isLiked'], false);
        expect(json['category'], 'Entertainment');
        expect(json['duration'], '0:30');
        expect(json['quality'], '1080p');
        expect(json['format'], 'HLS');
        expect(json['products'], isA<List>());
        expect((json['products'] as List).length, 1);
      });

      test('should serialize nested user data correctly', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['userName'], 'Test User');
        expect(json['userAvatar'], 'https://example.com/avatar.jpg');
        expect(
            json.containsKey('user'), false); // Should not have 'user' object
      });

      test('should serialize products array correctly', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final json = model.toJson();

        // Assert
        final products = json['products'] as List;
        expect(products.length, 1);
        expect(products[0]['id'], 'product-1');
        expect(products[0]['name'], 'Product 1');
        expect(products[0]['price'], 99.99);
      });

      test('should serialize empty products array', () {
        // Arrange
        final jsonWithoutProducts = Map<String, dynamic>.from(testVideoJson)
          ..remove('products');
        final model = VideoModel.fromJson(jsonWithoutProducts);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['products'], isEmpty);
        expect(json['products'], isA<List>());
      });

      test('should omit discountPrice in products when null', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final json = model.toJson();

        // Assert
        final products = json['products'] as List;
        expect(products[0].containsKey('discountPrice'), false);
      });

      test('should include discountPrice in products when present', () {
        // Arrange
        final jsonWithDiscount = Map<String, dynamic>.from(testVideoJson);
        (jsonWithDiscount['products'] as List)[0]['discountPrice'] = '79.99';
        final model = VideoModel.fromJson(jsonWithDiscount);

        // Act
        final json = model.toJson();

        // Assert
        final products = json['products'] as List;
        expect(products[0]['discountPrice'], '79.99');
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity, isA<VideoEntity>());
        expect(entity.id, 'video-1');
        expect(entity.title, 'Test Video');
        expect(entity.user.name, 'Test User');
        expect(entity.products.length, 1);
      });

      test('should create independent entity instance', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final entity = model.toEntity();

        // Assert
        expect(identical(model, entity), false);
        expect(entity.id, model.id);
      });

      test('should preserve all data in conversion', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.id, model.id);
        expect(entity.url, model.url);
        expect(entity.title, model.title);
        expect(entity.description, model.description);
        expect(entity.user.name, model.user.name);
        expect(entity.likes, model.likes);
        expect(entity.comments, model.comments);
        expect(entity.shares, model.shares);
        expect(entity.isLiked, model.isLiked);
        expect(entity.category, model.category);
        expect(entity.duration, model.duration);
        expect(entity.quality, model.quality);
        expect(entity.format, model.format);
        expect(entity.products.length, model.products.length);
      });

      test('should maintain business logic from entity', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Act
        final entity = model.toEntity();

        // Assert - Entity business logic should work
        expect(entity.hasProducts, true);
        expect(entity.productCount, 1);
      });
    });

    group('JSON round-trip', () {
      test('should maintain data integrity through fromJson -> toJson', () {
        // Arrange
        final originalJson = Map<String, dynamic>.from(testVideoJson);

        // Act
        final model = VideoModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson['id'], originalJson['id']);
        expect(resultJson['url'], originalJson['url']);
        expect(resultJson['title'], originalJson['title']);
        expect(resultJson['likes'], originalJson['likes']);
        expect(resultJson['userName'], originalJson['userName']);
      });

      test('should handle JSON string parsing', () {
        // Arrange
        const jsonString = '''
        {
          "id": "video-1",
          "url": "https://example.com/video.m3u8",
          "title": "Test Video",
          "description": "Test Description",
          "userName": "Test User",
          "userAvatar": "https://example.com/avatar.jpg",
          "likes": 100,
          "comments": 50,
          "shares": 25,
          "isLiked": false,
          "category": "Entertainment",
          "duration": "0:30",
          "quality": "1080p",
          "format": "HLS",
          "products": []
        }
        ''';

        // Act
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final model = VideoModel.fromJson(jsonMap);

        // Assert
        expect(model.id, 'video-1');
        expect(model.title, 'Test Video');
        expect(model.likes, 100);
      });

      test('should handle complex nested data round-trip', () {
        // Arrange
        final complexJson = {
          'id': 'video-complex',
          'url': 'https://example.com/video.m3u8',
          'title': 'Complex Video',
          'description': 'Complex Description',
          'userName': 'Complex User',
          'userAvatar': 'https://example.com/avatar.jpg',
          'likes': 999,
          'comments': 888,
          'shares': 777,
          'isLiked': true,
          'category': 'Gaming',
          'duration': '5:00',
          'quality': '4K',
          'format': 'MP4',
          'products': [
            {
              'id': 'p1',
              'name': 'Product 1',
              'description': 'Desc 1',
              'price': 100.0,
              'currency': 'USD',
              'imageUrl': 'url1',
              'category': 'Cat1',
              'rating': 5.0,
              'isAvailable': true,
              'discountPrice': '80.0',
            },
            {
              'id': 'p2',
              'name': 'Product 2',
              'description': 'Desc 2',
              'price': 200.0,
              'currency': 'EUR',
              'imageUrl': 'url2',
              'category': 'Cat2',
              'rating': 4.0,
              'isAvailable': false,
            },
          ],
        };

        // Act
        final model = VideoModel.fromJson(complexJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson['id'], complexJson['id']);
        expect(resultJson['likes'], complexJson['likes']);
        expect((resultJson['products'] as List).length, 2);
        expect((resultJson['products'] as List)[0]['discountPrice'], '80.0');
      });
    });

    group('inheritance', () {
      test('should be a VideoEntity', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Assert
        expect(model, isA<VideoEntity>());
      });

      test('should use entity equality rules', () {
        // Arrange
        final json1 = Map<String, dynamic>.from(testVideoJson)
          ..['id'] = 'same-id';
        final json2 = Map<String, dynamic>.from(testVideoJson)
          ..['id'] = 'same-id'
          ..['title'] = 'Different Title'
          ..['likes'] = 999;

        final model1 = VideoModel.fromJson(json1);
        final model2 = VideoModel.fromJson(json2);

        // Assert - Entities are equal based on id only
        expect(model1 == model2, true);
        expect(model1.hashCode, model2.hashCode);
      });

      test('should access entity business logic methods', () {
        // Arrange
        final model = VideoModel.fromJson(testVideoJson);

        // Assert - Can use VideoEntity methods
        expect(model.hasProducts, true);
        expect(model.productCount, 1);

        // Test copyWith from entity
        final copied = model.copyWith(title: 'New Title');
        expect(copied.title, 'New Title');
        expect(copied.id, model.id);
      });
    });
  });
}
