import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

/// Unit tests for VideoEntity
///
/// Tests cover:
/// - Entity creation and properties
/// - Business logic: hasProducts getter
/// - Business logic: productCount getter
/// - CopyWith method for immutability
/// - Equality operator (based on id)
/// - HashCode consistency
void main() {
  group('VideoEntity', () {
    group('constructor', () {
      test('should create entity with all required fields', () {
        // Arrange & Act
        final video = createTestVideo();

        // Assert
        expect(video.id, 'video-1');
        expect(video.url, 'https://example.com/video.m3u8');
        expect(video.title, 'Test Video');
        expect(video.description, 'Test video description');
        expect(video.user.name, 'Test User');
        expect(video.likes, 100);
        expect(video.shares, 50);
        expect(video.comments, 25);
        expect(video.isLiked, false);
        expect(video.category, 'Entertainment');
        expect(video.duration, '0:30');
        expect(video.quality, '1080p');
        expect(video.format, 'HLS');
        expect(video.products, isEmpty);
      });

      test('should create entity with products', () {
        // Arrange
        final product = createTestProduct();

        // Act
        final video = createTestVideo(products: [product]);

        // Assert
        expect(video.products.length, 1);
        expect(video.products.first.id, 'product-1');
      });

      test('should create entity with custom values', () {
        // Arrange & Act
        final video = createTestVideo(
          id: 'custom-id',
          title: 'Custom Title',
          likes: 999,
          isLiked: true,
          category: 'Gaming',
          duration: '5:00',
          quality: '4K',
          format: 'MP4',
        );

        // Assert
        expect(video.id, 'custom-id');
        expect(video.title, 'Custom Title');
        expect(video.likes, 999);
        expect(video.isLiked, true);
        expect(video.category, 'Gaming');
        expect(video.duration, '5:00');
        expect(video.quality, '4K');
        expect(video.format, 'MP4');
      });
    });

    group('hasProducts', () {
      test('should return false when products list is empty', () {
        // Arrange
        final video = createTestVideo(products: []);

        // Act & Assert
        expect(video.hasProducts, false);
      });

      test('should return true when products list has items', () {
        // Arrange
        final video = createTestVideo(products: [createTestProduct()]);

        // Act & Assert
        expect(video.hasProducts, true);
      });

      test('should return true when products list has multiple items', () {
        // Arrange
        final video = createTestVideo(
          products: [
            createTestProduct(id: 'product-1'),
            createTestProduct(id: 'product-2'),
            createTestProduct(id: 'product-3'),
          ],
        );

        // Act & Assert
        expect(video.hasProducts, true);
      });
    });

    group('productCount', () {
      test('should return 0 when no products', () {
        // Arrange
        final video = createTestVideo(products: []);

        // Act & Assert
        expect(video.productCount, 0);
      });

      test('should return correct count when single product', () {
        // Arrange
        final video = createTestVideo(products: [createTestProduct()]);

        // Act & Assert
        expect(video.productCount, 1);
      });

      test('should return correct count when multiple products', () {
        // Arrange
        final video = createTestVideo(
          products: [
            createTestProduct(id: 'product-1'),
            createTestProduct(id: 'product-2'),
            createTestProduct(id: 'product-3'),
            createTestProduct(id: 'product-4'),
            createTestProduct(id: 'product-5'),
          ],
        );

        // Act & Assert
        expect(video.productCount, 5);
      });
    });

    group('copyWith', () {
      test('should return same values when no parameters provided', () {
        // Arrange
        final video = createTestVideo();

        // Act
        final copied = video.copyWith();

        // Assert
        expect(copied.id, video.id);
        expect(copied.url, video.url);
        expect(copied.title, video.title);
        expect(copied.description, video.description);
        expect(copied.likes, video.likes);
        expect(copied.shares, video.shares);
        expect(copied.comments, video.comments);
        expect(copied.isLiked, video.isLiked);
      });

      test('should update only provided fields', () {
        // Arrange
        final video = createTestVideo(likes: 100, shares: 50, isLiked: false);

        // Act
        final copied = video.copyWith(likes: 200, isLiked: true);

        // Assert
        expect(copied.likes, 200);
        expect(copied.isLiked, true);
        expect(copied.shares, 50); // unchanged
        expect(copied.id, video.id); // unchanged
      });

      test('should create new instance (not same reference)', () {
        // Arrange
        final video = createTestVideo();

        // Act
        final copied = video.copyWith();

        // Assert
        expect(identical(video, copied), false);
      });

      test('should allow updating all fields', () {
        // Arrange
        final video = createTestVideo();
        final newUser = createTestUser(name: 'New User');
        final newProduct = createTestProduct(id: 'new-product');

        // Act
        final copied = video.copyWith(
          id: 'new-id',
          url: 'https://new.com/video.m3u8',
          title: 'New Title',
          description: 'New Description',
          user: newUser,
          likes: 999,
          comments: 888,
          shares: 777,
          isLiked: true,
          category: 'New Category',
          duration: '10:00',
          quality: '8K',
          format: 'WebM',
          products: [newProduct],
        );

        // Assert
        expect(copied.id, 'new-id');
        expect(copied.url, 'https://new.com/video.m3u8');
        expect(copied.title, 'New Title');
        expect(copied.description, 'New Description');
        expect(copied.user.name, 'New User');
        expect(copied.likes, 999);
        expect(copied.comments, 888);
        expect(copied.shares, 777);
        expect(copied.isLiked, true);
        expect(copied.category, 'New Category');
        expect(copied.duration, '10:00');
        expect(copied.quality, '8K');
        expect(copied.format, 'WebM');
        expect(copied.products.length, 1);
        expect(copied.products.first.id, 'new-product');
      });
    });

    group('equality', () {
      test('should return true when comparing videos with same id', () {
        // Arrange
        final video1 = createTestVideo(id: 'same-id', title: 'Video 1');
        final video2 = createTestVideo(id: 'same-id', title: 'Video 2');

        // Act & Assert
        expect(video1 == video2, true);
        expect(video1.hashCode == video2.hashCode, true);
      });

      test('should return false when comparing videos with different ids', () {
        // Arrange
        final video1 = createTestVideo(id: 'id-1');
        final video2 = createTestVideo(id: 'id-2');

        // Act & Assert
        expect(video1 == video2, false);
      });

      test('should return true when comparing video with itself', () {
        // Arrange
        final video = createTestVideo();

        // Act & Assert
        expect(video == video, true);
        expect(identical(video, video), true);
      });

      test('should return false when comparing with different type', () {
        // Arrange
        final video = createTestVideo();
        const other = 'not a video';

        // Act & Assert
        expect(video == other, false);
      });
    });

    group('hashCode', () {
      test('should be consistent for same entity', () {
        // Arrange
        final video = createTestVideo();

        // Act
        final hashCode1 = video.hashCode;
        final hashCode2 = video.hashCode;

        // Assert
        expect(hashCode1, hashCode2);
      });

      test('should be same for videos with same id', () {
        // Arrange
        final video1 = createTestVideo(id: 'same-id');
        final video2 = createTestVideo(id: 'same-id');

        // Act & Assert
        expect(video1.hashCode, video2.hashCode);
      });

      test('should be different for videos with different ids', () {
        // Arrange
        final video1 = createTestVideo(id: 'id-1');
        final video2 = createTestVideo(id: 'id-2');

        // Act & Assert
        expect(video1.hashCode, isNot(video2.hashCode));
      });
    });

    group('edge cases', () {
      test('should handle zero engagement counts', () {
        // Arrange & Act
        final video = createTestVideo(likes: 0, shares: 0, comments: 0);

        // Assert
        expect(video.likes, 0);
        expect(video.shares, 0);
        expect(video.comments, 0);
      });

      test('should handle very large engagement counts', () {
        // Arrange & Act
        final video = createTestVideo(
          likes: 1000000,
          shares: 500000,
          comments: 250000,
        );

        // Assert
        expect(video.likes, 1000000);
        expect(video.shares, 500000);
        expect(video.comments, 250000);
      });

      test('should handle empty string values', () {
        // Arrange & Act
        final video = createTestVideo(
          id: '',
          title: '',
          description: '',
          category: '',
          duration: '',
          quality: '',
          format: '',
        );

        // Assert
        expect(video.id, '');
        expect(video.title, '');
        expect(video.description, '');
        expect(video.category, '');
        expect(video.duration, '');
        expect(video.quality, '');
        expect(video.format, '');
      });

      test('should handle very long description', () {
        // Arrange
        final longDescription = 'A' * 1000;

        // Act
        final video = createTestVideo(description: longDescription);

        // Assert
        expect(video.description.length, 1000);
      });
    });
  });
}
