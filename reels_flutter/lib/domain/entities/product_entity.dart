/// Domain Entity: Product
///
/// Represents a product that can be tagged in videos.
/// This is a pure Dart class with no external dependencies.
class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String imageUrl;
  final String category;
  final double rating;
  final bool isAvailable;
  final String? discountPrice;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.isAvailable,
    this.discountPrice,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
