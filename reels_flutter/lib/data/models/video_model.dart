import 'package:reels_flutter/data/models/product_model.dart';
import 'package:reels_flutter/data/models/user_model.dart';
import 'package:reels_flutter/domain/entities/video_entity.dart';

/// Data model for Video that extends VideoEntity.
///
/// Adds JSON serialization/deserialization capabilities
/// while inheriting all business logic from VideoEntity.
class VideoModel extends VideoEntity {
  VideoModel({
    required super.id,
    required super.url,
    required super.title,
    required super.description,
    required super.user,
    required super.likes,
    required super.comments,
    required super.shares,
    required super.isLiked,
    required super.category,
    required super.duration,
    required super.quality,
    required super.format,
    required super.products,
  });

  /// Creates a VideoModel from JSON data.
  ///
  /// Parses the complete video object including nested
  /// user and products data from mock_videos.json structure.
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    // Parse user data
    final userModel = UserModel.fromJson(json);

    // Parse products list
    final List<ProductModel> productModels = [];
    if (json['products'] != null) {
      final productsJson = json['products'] as List;
      productModels.addAll(
        productsJson.map(
          (productJson) =>
              ProductModel.fromJson(productJson as Map<String, dynamic>),
        ),
      );
    }

    return VideoModel(
      id: json['id'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      user: userModel.toEntity(),
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      shares: json['shares'] as int,
      isLiked: json['isLiked'] as bool,
      category: json['category'] as String,
      duration: json['duration'] as String,
      quality: json['quality'] as String,
      format: json['format'] as String,
      products: productModels.map((model) => model.toEntity()).toList(),
    );
  }

  /// Converts this VideoModel to a JSON map.
  ///
  /// Useful for caching or API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'description': description,
      'userName': user.name,
      'userAvatar': user.avatarUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
      'category': category,
      'duration': duration,
      'quality': quality,
      'format': format,
      'products': products.map((product) {
        return {
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'currency': product.currency,
          'imageUrl': product.imageUrl,
          'category': product.category,
          'rating': product.rating,
          'isAvailable': product.isAvailable,
          if (product.discountPrice != null)
            'discountPrice': product.discountPrice,
        };
      }).toList(),
    };
  }

  /// Creates a VideoEntity from this model.
  VideoEntity toEntity() {
    return VideoEntity(
      id: id,
      url: url,
      title: title,
      description: description,
      user: user,
      likes: likes,
      comments: comments,
      shares: shares,
      isLiked: isLiked,
      category: category,
      duration: duration,
      quality: quality,
      format: format,
      products: products,
    );
  }
}
