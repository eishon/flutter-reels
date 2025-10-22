import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

/// Unit tests for ProductEntity
///
/// Tests cover:
/// - Entity creation and properties
/// - Equality operator (based on id)
/// - HashCode consistency
/// - Optional discountPrice field
void main() {
  group('ProductEntity', () {
    group('constructor', () {
      test('should create entity with all required fields', () {
        // Arrange & Act
        final product = createTestProduct();

        // Assert
        expect(product.id, 'product-1');
        expect(product.name, 'Test Product');
        expect(product.description, 'Test Description');
        expect(product.price, 99.99);
        expect(product.currency, 'USD');
        expect(product.imageUrl, 'https://example.com/product.jpg');
        expect(product.category, 'Electronics');
        expect(product.rating, 4.5);
        expect(product.isAvailable, true);
        expect(product.discountPrice, null);
      });

      test('should create entity with optional discountPrice', () {
        // Arrange & Act
        final product = createTestProduct(discountPrice: '79.99');

        // Assert
        expect(product.discountPrice, '79.99');
      });

      test('should create entity with custom values', () {
        // Arrange & Act
        final product = createTestProduct(
          id: 'custom-id',
          name: 'Custom Product',
          price: 199.99,
          isAvailable: false,
        );

        // Assert
        expect(product.id, 'custom-id');
        expect(product.name, 'Custom Product');
        expect(product.price, 199.99);
        expect(product.isAvailable, false);
      });
    });

    group('equality', () {
      test('should return true when comparing entities with same id', () {
        // Arrange
        final product1 = createTestProduct(id: 'same-id', name: 'Product 1');
        final product2 = createTestProduct(id: 'same-id', name: 'Product 2');

        // Act & Assert
        expect(product1 == product2, true);
        expect(product1.hashCode == product2.hashCode, true);
      });

      test(
        'should return false when comparing entities with different ids',
        () {
          // Arrange
          final product1 = createTestProduct(id: 'id-1');
          final product2 = createTestProduct(id: 'id-2');

          // Act & Assert
          expect(product1 == product2, false);
        },
      );

      test('should return true when comparing entity with itself', () {
        // Arrange
        final product = createTestProduct();

        // Act & Assert
        expect(product == product, true);
        expect(identical(product, product), true);
      });

      test('should return false when comparing with different type', () {
        // Arrange
        final product = createTestProduct();
        const other = 'not a product';

        // Act & Assert
        expect(product == other, false);
      });
    });

    group('hashCode', () {
      test('should be consistent for same entity', () {
        // Arrange
        final product = createTestProduct();

        // Act
        final hashCode1 = product.hashCode;
        final hashCode2 = product.hashCode;

        // Assert
        expect(hashCode1, hashCode2);
      });

      test('should be same for entities with same id', () {
        // Arrange
        final product1 = createTestProduct(id: 'same-id');
        final product2 = createTestProduct(id: 'same-id');

        // Act & Assert
        expect(product1.hashCode, product2.hashCode);
      });

      test('should be different for entities with different ids', () {
        // Arrange
        final product1 = createTestProduct(id: 'id-1');
        final product2 = createTestProduct(id: 'id-2');

        // Act & Assert
        expect(product1.hashCode, isNot(product2.hashCode));
      });
    });

    group('edge cases', () {
      test('should handle empty strings', () {
        // Arrange & Act
        final product = createTestProduct(id: '', name: '', description: '');

        // Assert
        expect(product.id, '');
        expect(product.name, '');
        expect(product.description, '');
      });

      test('should handle zero price', () {
        // Arrange & Act
        final product = createTestProduct(price: 0.0);

        // Assert
        expect(product.price, 0.0);
      });

      test('should handle max rating', () {
        // Arrange & Act
        final product = createTestProduct(rating: 5.0);

        // Assert
        expect(product.rating, 5.0);
      });

      test('should handle min rating', () {
        // Arrange & Act
        final product = createTestProduct(rating: 0.0);

        // Assert
        expect(product.rating, 0.0);
      });
    });
  });
}
