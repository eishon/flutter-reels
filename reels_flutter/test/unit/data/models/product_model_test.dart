import 'dart:convert';

import 'package:reels_flutter/data/models/product_model.dart';
import 'package:reels_flutter/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for ProductModel
///
/// Tests cover:
/// - fromJson: deserialization from JSON
/// - toJson: serialization to JSON
/// - toEntity: conversion to domain entity
/// - Edge cases: null values, missing fields, invalid data
void main() {
  group('ProductModel', () {
    final testProductJson = {
      'id': 'product-1',
      'name': 'Test Product',
      'description': 'Test Description',
      'price': 99.99,
      'currency': 'USD',
      'imageUrl': 'https://example.com/product.jpg',
      'category': 'Electronics',
      'rating': 4.5,
      'isAvailable': true,
      'discountPrice': '79.99',
    };

    group('fromJson', () {
      test('should create model from valid JSON with all fields', () {
        // Act
        final model = ProductModel.fromJson(testProductJson);

        // Assert
        expect(model.id, 'product-1');
        expect(model.name, 'Test Product');
        expect(model.description, 'Test Description');
        expect(model.price, 99.99);
        expect(model.currency, 'USD');
        expect(model.imageUrl, 'https://example.com/product.jpg');
        expect(model.category, 'Electronics');
        expect(model.rating, 4.5);
        expect(model.isAvailable, true);
        expect(model.discountPrice, '79.99');
      });

      test('should create model from JSON without discountPrice', () {
        // Arrange
        final jsonWithoutDiscount = Map<String, dynamic>.from(testProductJson)
          ..remove('discountPrice');

        // Act
        final model = ProductModel.fromJson(jsonWithoutDiscount);

        // Assert
        expect(model.discountPrice, null);
        expect(model.id, 'product-1');
        expect(model.name, 'Test Product');
      });

      test('should handle integer price as double', () {
        // Arrange
        final jsonWithIntPrice = Map<String, dynamic>.from(testProductJson)
          ..['price'] = 100;

        // Act
        final model = ProductModel.fromJson(jsonWithIntPrice);

        // Assert
        expect(model.price, 100.0);
        expect(model.price, isA<double>());
      });

      test('should handle integer rating as double', () {
        // Arrange
        final jsonWithIntRating = Map<String, dynamic>.from(testProductJson)
          ..['rating'] = 5;

        // Act
        final model = ProductModel.fromJson(jsonWithIntRating);

        // Assert
        expect(model.rating, 5.0);
        expect(model.rating, isA<double>());
      });

      test('should handle zero price', () {
        // Arrange
        final jsonWithZeroPrice = Map<String, dynamic>.from(testProductJson)
          ..['price'] = 0;

        // Act
        final model = ProductModel.fromJson(jsonWithZeroPrice);

        // Assert
        expect(model.price, 0.0);
      });

      test('should handle false isAvailable', () {
        // Arrange
        final jsonUnavailable = Map<String, dynamic>.from(testProductJson)
          ..['isAvailable'] = false;

        // Act
        final model = ProductModel.fromJson(jsonUnavailable);

        // Assert
        expect(model.isAvailable, false);
      });

      test('should handle empty strings', () {
        // Arrange
        final jsonWithEmptyStrings = {
          'id': '',
          'name': '',
          'description': '',
          'price': 0.0,
          'currency': '',
          'imageUrl': '',
          'category': '',
          'rating': 0.0,
          'isAvailable': true,
        };

        // Act
        final model = ProductModel.fromJson(jsonWithEmptyStrings);

        // Assert
        expect(model.id, '');
        expect(model.name, '');
        expect(model.description, '');
      });
    });

    group('toJson', () {
      test('should convert model to JSON with all fields', () {
        // Arrange
        final model = ProductModel(
          id: 'product-1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          currency: 'USD',
          imageUrl: 'https://example.com/product.jpg',
          category: 'Electronics',
          rating: 4.5,
          isAvailable: true,
          discountPrice: '79.99',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['id'], 'product-1');
        expect(json['name'], 'Test Product');
        expect(json['description'], 'Test Description');
        expect(json['price'], 99.99);
        expect(json['currency'], 'USD');
        expect(json['imageUrl'], 'https://example.com/product.jpg');
        expect(json['category'], 'Electronics');
        expect(json['rating'], 4.5);
        expect(json['isAvailable'], true);
        expect(json['discountPrice'], '79.99');
      });

      test('should omit discountPrice when null', () {
        // Arrange
        final model = ProductModel(
          id: 'product-1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          currency: 'USD',
          imageUrl: 'https://example.com/product.jpg',
          category: 'Electronics',
          rating: 4.5,
          isAvailable: true,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json.containsKey('discountPrice'), false);
      });

      test('should handle zero values', () {
        // Arrange
        final model = ProductModel(
          id: 'product-1',
          name: 'Test Product',
          description: 'Test Description',
          price: 0.0,
          currency: 'USD',
          imageUrl: 'https://example.com/product.jpg',
          category: 'Electronics',
          rating: 0.0,
          isAvailable: true,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['price'], 0.0);
        expect(json['rating'], 0.0);
      });
    });

    group('toEntity', () {
      test('should convert model to entity with all fields', () {
        // Arrange
        final model = ProductModel(
          id: 'product-1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          currency: 'USD',
          imageUrl: 'https://example.com/product.jpg',
          category: 'Electronics',
          rating: 4.5,
          isAvailable: true,
          discountPrice: '79.99',
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity, isA<ProductEntity>());
        expect(entity.id, 'product-1');
        expect(entity.name, 'Test Product');
        expect(entity.description, 'Test Description');
        expect(entity.price, 99.99);
        expect(entity.currency, 'USD');
        expect(entity.imageUrl, 'https://example.com/product.jpg');
        expect(entity.category, 'Electronics');
        expect(entity.rating, 4.5);
        expect(entity.isAvailable, true);
        expect(entity.discountPrice, '79.99');
      });

      test('should maintain equality through conversion', () {
        // Arrange
        final model = ProductModel(
          id: 'product-1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          currency: 'USD',
          imageUrl: 'https://example.com/product.jpg',
          category: 'Electronics',
          rating: 4.5,
          isAvailable: true,
        );

        // Act
        final entity = model.toEntity();

        // Assert - Entity equality is based on id
        expect(entity.id, model.id);
      });
    });

    group('JSON round-trip', () {
      test('should maintain data integrity through fromJson -> toJson', () {
        // Arrange
        final originalJson = Map<String, dynamic>.from(testProductJson);

        // Act
        final model = ProductModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson['id'], originalJson['id']);
        expect(resultJson['name'], originalJson['name']);
        expect(resultJson['description'], originalJson['description']);
        expect(resultJson['price'], originalJson['price']);
        expect(resultJson['currency'], originalJson['currency']);
        expect(resultJson['imageUrl'], originalJson['imageUrl']);
        expect(resultJson['category'], originalJson['category']);
        expect(resultJson['rating'], originalJson['rating']);
        expect(resultJson['isAvailable'], originalJson['isAvailable']);
        expect(resultJson['discountPrice'], originalJson['discountPrice']);
      });

      test('should handle JSON string parsing', () {
        // Arrange
        const jsonString = '''
        {
          "id": "product-1",
          "name": "Test Product",
          "description": "Test Description",
          "price": 99.99,
          "currency": "USD",
          "imageUrl": "https://example.com/product.jpg",
          "category": "Electronics",
          "rating": 4.5,
          "isAvailable": true
        }
        ''';

        // Act
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final model = ProductModel.fromJson(jsonMap);

        // Assert
        expect(model.id, 'product-1');
        expect(model.name, 'Test Product');
        expect(model.price, 99.99);
      });
    });

    group('inheritance', () {
      test('should be a ProductEntity', () {
        // Arrange
        final model = ProductModel.fromJson(testProductJson);

        // Assert
        expect(model, isA<ProductEntity>());
      });

      test('should maintain entity equality rules', () {
        // Arrange
        final model1 = ProductModel(
          id: 'same-id',
          name: 'Product 1',
          description: 'Description 1',
          price: 99.99,
          currency: 'USD',
          imageUrl: 'url1',
          category: 'Cat1',
          rating: 4.5,
          isAvailable: true,
        );

        final model2 = ProductModel(
          id: 'same-id',
          name: 'Product 2',
          description: 'Description 2',
          price: 199.99,
          currency: 'EUR',
          imageUrl: 'url2',
          category: 'Cat2',
          rating: 3.5,
          isAvailable: false,
        );

        // Assert - Entities are equal based on id only
        expect(model1 == model2, true);
        expect(model1.hashCode, model2.hashCode);
      });
    });
  });
}
