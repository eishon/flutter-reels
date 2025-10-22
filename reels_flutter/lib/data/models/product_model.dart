import 'package:reels_flutter/domain/entities/product_entity.dart';

/// Data model for Product that extends ProductEntity.
///
/// Adds serialization capabilities (fromJson/toJson) while
/// inheriting all business logic from ProductEntity.
///
/// This separation keeps domain entities clean and
/// serialization logic in the data layer.
class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.currency,
    required super.imageUrl,
    required super.category,
    required super.rating,
    required super.isAvailable,
    super.discountPrice,
  });

  /// Creates a ProductModel from a JSON map.
  ///
  /// This method handles the deserialization from the JSON
  /// data structure used in mock_videos.json.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      discountPrice: json['discountPrice'] as String?,
    );
  }

  /// Converts this ProductModel to a JSON map.
  ///
  /// Useful for caching or sending data to a remote server.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'isAvailable': isAvailable,
      if (discountPrice != null) 'discountPrice': discountPrice,
    };
  }

  /// Creates a ProductEntity from this model.
  ///
  /// Useful when passing data from data layer to domain layer.
  ProductEntity toEntity() {
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
}
