import 'package:reels_flutter/domain/usecases/increment_share_count_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.dart';
import '../../../helpers/test_mocks.mocks.dart';

/// Unit tests for IncrementShareCountUseCase
///
/// Tests cover:
/// - Successfully incrementing share count
/// - Passing correct id to repository
/// - Verifying repository method called once
/// - Handling multiple increments
/// - Handling exceptions
void main() {
  late IncrementShareCountUseCase useCase;
  late MockVideoRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoRepository();
    useCase = IncrementShareCountUseCase(mockRepository);
  });

  group('IncrementShareCountUseCase', () {
    test('should increment share count', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(id: videoId, shares: 50);
      final sharedVideo = video.copyWith(shares: 51);

      when(
        mockRepository.incrementShareCount(videoId),
      ).thenAnswer((_) async => sharedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.id, videoId);
      expect(result.shares, 51);
      verify(mockRepository.incrementShareCount(videoId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct video id to repository', () async {
      // Arrange
      const videoId = 'specific-video-id';
      final video = createTestVideo(id: videoId);

      when(
        mockRepository.incrementShareCount(videoId),
      ).thenAnswer((_) async => video);

      // Act
      await useCase(videoId);

      // Assert
      verify(mockRepository.incrementShareCount(videoId)).called(1);
    });

    test('should increment from zero shares', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(id: videoId, shares: 0);
      final sharedVideo = video.copyWith(shares: 1);

      when(
        mockRepository.incrementShareCount(videoId),
      ).thenAnswer((_) async => sharedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.shares, 1);
      verify(mockRepository.incrementShareCount(videoId)).called(1);
    });

    test('should increment from large share count', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(id: videoId, shares: 999999);
      final sharedVideo = video.copyWith(shares: 1000000);

      when(
        mockRepository.incrementShareCount(videoId),
      ).thenAnswer((_) async => sharedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.shares, 1000000);
      verify(mockRepository.incrementShareCount(videoId)).called(1);
    });

    test('should not affect other video properties', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(
        id: videoId,
        title: 'Test Video',
        likes: 100,
        comments: 50,
        shares: 25,
        isLiked: true,
      );
      final sharedVideo = video.copyWith(shares: 26);

      when(
        mockRepository.incrementShareCount(videoId),
      ).thenAnswer((_) async => sharedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.title, 'Test Video');
      expect(result.likes, 100);
      expect(result.comments, 50);
      expect(result.shares, 26);
      expect(result.isLiked, true);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      const videoId = 'video-123';
      when(
        mockRepository.incrementShareCount(videoId),
      ).thenThrow(Exception('Failed to increment share'));

      // Act & Assert
      expect(() => useCase(videoId), throwsA(isA<Exception>()));
      verify(mockRepository.incrementShareCount(videoId)).called(1);
    });

    test('should throw exception when id is empty', () async {
      // Arrange
      const videoId = '';

      // Act & Assert
      expect(() => useCase(videoId), throwsA(isA<ArgumentError>()));
    });

    test('should allow multiple share increments', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(id: videoId);

      when(
        mockRepository.incrementShareCount(videoId),
      ).thenAnswer((_) async => video);

      // Act
      await useCase(videoId);
      await useCase(videoId);
      await useCase(videoId);

      // Assert
      verify(mockRepository.incrementShareCount(videoId)).called(3);
    });

    test('should handle sharing different videos', () async {
      // Arrange
      final video1 = createTestVideo(id: 'video-1', shares: 10);
      final video2 = createTestVideo(id: 'video-2', shares: 20);
      final sharedVideo1 = video1.copyWith(shares: 11);
      final sharedVideo2 = video2.copyWith(shares: 21);

      when(
        mockRepository.incrementShareCount('video-1'),
      ).thenAnswer((_) async => sharedVideo1);
      when(
        mockRepository.incrementShareCount('video-2'),
      ).thenAnswer((_) async => sharedVideo2);

      // Act
      final result1 = await useCase('video-1');
      final result2 = await useCase('video-2');

      // Assert
      expect(result1.id, 'video-1');
      expect(result1.shares, 11);
      expect(result2.id, 'video-2');
      expect(result2.shares, 21);
      verify(mockRepository.incrementShareCount('video-1')).called(1);
      verify(mockRepository.incrementShareCount('video-2')).called(1);
    });

    test('should handle rapid successive shares', () async {
      // Arrange
      const videoId = 'video-123';
      var shares = 100;
      when(mockRepository.incrementShareCount(videoId)).thenAnswer((_) async {
        shares++;
        return createTestVideo(id: videoId, shares: shares);
      });

      // Act
      final result1 = await useCase(videoId);
      final result2 = await useCase(videoId);
      final result3 = await useCase(videoId);

      // Assert
      expect(result1.shares, 101);
      expect(result2.shares, 102);
      expect(result3.shares, 103);
      verify(mockRepository.incrementShareCount(videoId)).called(3);
    });
  });
}
