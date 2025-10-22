import 'product_entity.dart';
import 'user_entity.dart';

/// Domain Entity: Video
///
/// Represents a video in the application.
/// This is a pure Dart class with no external dependencies.
/// Contains all business logic related to a video.
class VideoEntity {
  final String id;
  final String url;
  final String title;
  final String description;
  final UserEntity user;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final String category;
  final String duration;
  final String quality;
  final String format;
  final List<ProductEntity> products;

  const VideoEntity({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.user,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isLiked,
    required this.category,
    required this.duration,
    required this.quality,
    required this.format,
    this.products = const [],
  });

  /// Check if video has products (shoppable)
  bool get hasProducts => products.isNotEmpty;

  /// Get number of products
  int get productCount => products.length;

  /// Copy with method for immutability
  VideoEntity copyWith({
    String? id,
    String? url,
    String? title,
    String? description,
    UserEntity? user,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    String? category,
    String? duration,
    String? quality,
    String? format,
    List<ProductEntity>? products,
  }) {
    return VideoEntity(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      user: user ?? this.user,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      quality: quality ?? this.quality,
      format: format ?? this.format,
      products: products ?? this.products,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
