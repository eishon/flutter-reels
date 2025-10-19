import 'package:flutter_reels/data/models/video_model.dart';
import 'package:flutter_reels/data/repositories/video_repository_impl.dart';
import 'package:flutter_reels/domain/entities/user_entity.dart';
import 'package:flutter_reels/domain/entities/video_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_mocks.mocks.dart';

/// Unit tests for VideoRepositoryImpl
///
/// Tests focus on:
/// - Delegation to data source
/// - Model to entity conversion
/// - Error handling
/// - Method call verification
void main() {
  late VideoRepositoryImpl repository;
  late MockVideoLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockVideoLocalDataSource();
    repository = VideoRepositoryImpl(localDataSource: mockDataSource);
  });

  /// Helper to create test VideoModel
  VideoModel createTestVideoModel({
    String id = 'video-1',
    String title = 'Test Video',
    int likes = 100,
    int shares = 50,
    bool isLiked = false,
  }) {
    return VideoModel(
      id: id,
      url: 'https://example.com/video.m3u8',
      title: title,
      description: 'Description',
      user: UserEntity(name: 'User', avatarUrl: 'https://avatar.jpg'),
      likes: likes,
      shares: shares,
      comments: 25,
      isLiked: isLiked,
      category: 'Entertainment',
      duration: '0:30',
      quality: '1080p',
      format: 'HLS',
      products: [],
    );
  }

  group('Video Repository Impl', () {
    group('getVideos', () {
      test('should call data source and convert models to entities', () async {
        // Arrange
        final models = [
          createTestVideoModel(id: 'v1'),
          createTestVideoModel(id: 'v2'),
        ];
        when(mockDataSource.getVideos()).thenAnswer((_) async => models);

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result, isA<List<VideoEntity>>());
        expect(result.length, 2);
        expect(result[0].id, 'v1');
        expect(result[1].id, 'v2');
        verify(mockDataSource.getVideos()).called(1);
      });

      test('should return empty list when data source returns empty', () async {
        // Arrange
        when(mockDataSource.getVideos()).thenAnswer((_) async => []);

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result, isEmpty);
        verify(mockDataSource.getVideos()).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        when(mockDataSource.getVideos()).thenThrow(Exception('Data error'));

        // Act & Assert
        expect(() => repository.getVideos(), throwsA(isA<Exception>()));
        verify(mockDataSource.getVideos()).called(1);
      });
    });

    group('getVideoById', () {
      test('should call data source and convert model to entity', () async {
        // Arrange
        const id = 'video-1';
        final model = createTestVideoModel(id: id);
        when(mockDataSource.getVideoById(id)).thenAnswer((_) async => model);

        // Act
        final result = await repository.getVideoById(id);

        // Assert
        expect(result, isA<VideoEntity>());
        expect(result?.id, id);
        verify(mockDataSource.getVideoById(id)).called(1);
      });

      test('should return null when video not found', () async {
        // Arrange
        when(mockDataSource.getVideoById('id')).thenAnswer((_) async => null);

        // Act
        final result = await repository.getVideoById('id');

        // Assert
        expect(result, isNull);
        verify(mockDataSource.getVideoById('id')).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        when(mockDataSource.getVideoById('id')).thenThrow(Exception('Error'));

        // Act & Assert
        expect(() => repository.getVideoById('id'), throwsA(isA<Exception>()));
      });
    });

    group('toggleLike', () {
      test('should call data source and convert updated model to entity',
          () async {
        // Arrange
        const id = 'video-1';
        final model = createTestVideoModel(id: id, isLiked: true, likes: 101);
        when(mockDataSource.toggleLike(id)).thenAnswer((_) async => model);

        // Act
        final result = await repository.toggleLike(id);

        // Assert
        expect(result, isA<VideoEntity>());
        expect(result.id, id);
        expect(result.isLiked, true);
        expect(result.likes, 101);
        verify(mockDataSource.toggleLike(id)).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        when(mockDataSource.toggleLike('id')).thenThrow(Exception('Error'));

        // Act & Assert
        expect(() => repository.toggleLike('id'), throwsA(isA<Exception>()));
      });
    });

    group('incrementShareCount', () {
      test('should call data source and convert updated model to entity',
          () async {
        // Arrange
        const id = 'video-1';
        final model = createTestVideoModel(id: id, shares: 51);
        when(mockDataSource.incrementShareCount(id))
            .thenAnswer((_) async => model);

        // Act
        final result = await repository.incrementShareCount(id);

        // Assert
        expect(result, isA<VideoEntity>());
        expect(result.id, id);
        expect(result.shares, 51);
        verify(mockDataSource.incrementShareCount(id)).called(1);
      });

      test('should propagate exception from data source', () async {
        // Arrange
        when(mockDataSource.incrementShareCount('id'))
            .thenThrow(Exception('Error'));

        // Act & Assert
        expect(() => repository.incrementShareCount('id'),
            throwsA(isA<Exception>()));
      });
    });

    group('data layer separation', () {
      test('should not expose models, only entities', () async {
        // Arrange
        final models = [createTestVideoModel()];
        when(mockDataSource.getVideos()).thenAnswer((_) async => models);

        // Act
        final result = await repository.getVideos();

        // Assert - Result should be entities
        expect(result, isA<List<VideoEntity>>());
        expect(result.first, isA<VideoEntity>());
      });

      test('should maintain data integrity during conversion', () async {
        // Arrange
        final model = createTestVideoModel(
          id: 'test-id',
          title: 'Test Title',
          likes: 999,
        );
        when(mockDataSource.getVideos()).thenAnswer((_) async => [model]);

        // Act
        final result = await repository.getVideos();

        // Assert - All data preserved
        expect(result.first.id, 'test-id');
        expect(result.first.title, 'Test Title');
        expect(result.first.likes, 999);
      });
    });
  });
}
