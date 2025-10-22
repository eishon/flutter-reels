/// Test helper utilities for setting up test environment and common test data
///
/// This file provides:
/// - Mock data factories for creating test entities
/// - Common test fixtures
/// - Utility functions for test assertions

import 'package:reels_flutter/domain/entities/product_entity.dart';
import 'package:reels_flutter/domain/entities/user_entity.dart';
import 'package:reels_flutter/domain/entities/video_entity.dart';

/// Creates a test ProductEntity with default or custom values
ProductEntity createTestProduct({
  String id = 'product-1',
  String name = 'Test Product',
  String description = 'Test Description',
  double price = 99.99,
  String currency = 'USD',
  String imageUrl = 'https://example.com/product.jpg',
  String category = 'Electronics',
  double rating = 4.5,
  bool isAvailable = true,
  String? discountPrice,
}) {
  return ProductEntity(
    id: id,
    name: name,
    description: description,
    price: price,
    currency: currency,
    imageUrl: imageUrl,
    category: category,
    rating: rating,
    isAvailable: isAvailable,
    discountPrice: discountPrice,
  );
}

/// Creates a test UserEntity with default or custom values
UserEntity createTestUser({
  String name = 'Test User',
  String avatarUrl = 'https://example.com/avatar.jpg',
}) {
  return UserEntity(
    name: name,
    avatarUrl: avatarUrl,
  );
}

/// Creates a test VideoEntity with default or custom values
VideoEntity createTestVideo({
  String id = 'video-1',
  String url = 'https://example.com/video.m3u8',
  String title = 'Test Video',
  String description = 'Test video description',
  UserEntity? user,
  int likes = 100,
  int shares = 50,
  int comments = 25,
  bool isLiked = false,
  String category = 'Entertainment',
  String duration = '0:30',
  String quality = '1080p',
  String format = 'HLS',
  List<ProductEntity>? products,
}) {
  return VideoEntity(
    id: id,
    url: url,
    title: title,
    description: description,
    user: user ?? createTestUser(),
    likes: likes,
    shares: shares,
    comments: comments,
    isLiked: isLiked,
    category: category,
    duration: duration,
    quality: quality,
    format: format,
    products: products ?? [],
  );
}

/// Creates a list of test videos for testing list operations
List<VideoEntity> createTestVideoList({int count = 3}) {
  return List.generate(
    count,
    (index) => createTestVideo(
      id: 'video-${index + 1}',
      title: 'Test Video ${index + 1}',
      likes: 100 * (index + 1),
      shares: 50 * (index + 1),
      comments: 25 * (index + 1),
      products: index % 2 == 0
          ? [
              createTestProduct(id: 'product-${index + 1}'),
            ]
          : [],
    ),
  );
}

/// Sample JSON data for testing JSON serialization
const String sampleProductJson = '''
{
  "id": "product-1",
  "name": "Sample Product",
  "description": "Sample description",
  "price": 299.99,
  "currency": "USD",
  "imageUrl": "https://example.com/product.jpg",
  "category": "Fashion",
  "rating": 4.8,
  "isAvailable": true,
  "discountPrice": 249.99
}
''';

const String sampleUserJson = '''
{
  "name": "Sample User",
  "avatarUrl": "https://example.com/avatar.jpg"
}
''';

const String sampleVideoJson = '''
{
  "id": "video-1",
  "url": "https://example.com/video.m3u8",
  "thumbnailUrl": "https://example.com/thumb.jpg",
  "title": "Sample Video",
  "description": "Sample description",
  "user": {
    "name": "Sample User",
    "avatarUrl": "https://example.com/avatar.jpg"
  },
  "likesCount": 1000,
  "sharesCount": 500,
  "commentsCount": 250,
  "isLiked": false,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "products": []
}
''';

/// Sample JSON array of videos for testing list operations
const String sampleVideosJson = '''
[
  {
    "id": "video-1",
    "url": "https://example.com/video1.m3u8",
    "thumbnailUrl": "https://example.com/thumb1.jpg",
    "title": "Video 1",
    "description": "Description 1",
    "user": {
      "name": "User 1",
      "avatarUrl": "https://example.com/avatar1.jpg"
    },
    "likesCount": 100,
    "sharesCount": 50,
    "commentsCount": 25,
    "isLiked": false,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "products": []
  },
  {
    "id": "video-2",
    "url": "https://example.com/video2.m3u8",
    "thumbnailUrl": "https://example.com/thumb2.jpg",
    "title": "Video 2",
    "description": "Description 2",
    "user": {
      "name": "User 2",
      "avatarUrl": "https://example.com/avatar2.jpg"
    },
    "likesCount": 200,
    "sharesCount": 100,
    "commentsCount": 50,
    "isLiked": true,
    "createdAt": "2024-01-02T00:00:00.000Z",
    "products": [
      {
        "id": "product-1",
        "name": "Product 1",
        "description": "Product description",
        "price": 99.99,
        "currency": "USD",
        "imageUrl": "https://example.com/product1.jpg",
        "category": "Electronics",
        "rating": 4.5,
        "isAvailable": true
      }
    ]
  }
]
''';
