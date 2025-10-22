import 'package:reels_flutter/domain/usecases/get_video_by_id_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.dart';
import '../../../helpers/test_mocks.mocks.dart';

/// Unit tests for GetVideoByIdUseCase
///
/// Tests cover:
/// - Successful retrieval of video by id
/// - Passing correct id parameter to repository
/// - Handling null/not found case
/// - Handling exceptions
void main() {
  late GetVideoByIdUseCase useCase;
  late MockVideoRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoRepository();
    useCase = GetVideoByIdUseCase(mockRepository);
  });

  group('GetVideoByIdUseCase', () {
    test('should get video by id from repository', () async {
      // Arrange
      const videoId = 'video-123';
      final testVideo = createTestVideo(id: videoId);
      when(
        mockRepository.getVideoById(videoId),
      ).thenAnswer((_) async => testVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result, testVideo);
      expect(result?.id, videoId);
      verify(mockRepository.getVideoById(videoId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct id to repository', () async {
      // Arrange
      const videoId = 'specific-video-id';
      final testVideo = createTestVideo(id: videoId);
      when(
        mockRepository.getVideoById(videoId),
      ).thenAnswer((_) async => testVideo);

      // Act
      await useCase(videoId);

      // Assert
      verify(mockRepository.getVideoById(videoId)).called(1);
    });

    test('should return null when video not found', () async {
      // Arrange
      const videoId = 'non-existent-id';
      when(mockRepository.getVideoById(videoId)).thenAnswer((_) async => null);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result, isNull);
      verify(mockRepository.getVideoById(videoId)).called(1);
    });

    test('should throw exception when id is empty', () async {
      // Arrange
      const videoId = '';

      // Act & Assert
      expect(() => useCase(videoId), throwsA(isA<ArgumentError>()));
    });

    test('should propagate exception from repository', () async {
      // Arrange
      const videoId = 'video-123';
      when(
        mockRepository.getVideoById(videoId),
      ).thenThrow(Exception('Failed to load video'));

      // Act & Assert
      expect(() => useCase(videoId), throwsA(isA<Exception>()));
      verify(mockRepository.getVideoById(videoId)).called(1);
    });

    test('should retrieve different videos by different ids', () async {
      // Arrange
      final video1 = createTestVideo(id: 'video-1', title: 'Video 1');
      final video2 = createTestVideo(id: 'video-2', title: 'Video 2');

      when(
        mockRepository.getVideoById('video-1'),
      ).thenAnswer((_) async => video1);
      when(
        mockRepository.getVideoById('video-2'),
      ).thenAnswer((_) async => video2);

      // Act
      final result1 = await useCase('video-1');
      final result2 = await useCase('video-2');

      // Assert
      expect(result1?.id, 'video-1');
      expect(result1?.title, 'Video 1');
      expect(result2?.id, 'video-2');
      expect(result2?.title, 'Video 2');
      verify(mockRepository.getVideoById('video-1')).called(1);
      verify(mockRepository.getVideoById('video-2')).called(1);
    });

    test('should allow calling same id multiple times', () async {
      // Arrange
      const videoId = 'video-123';
      final testVideo = createTestVideo(id: videoId);
      when(
        mockRepository.getVideoById(videoId),
      ).thenAnswer((_) async => testVideo);

      // Act
      await useCase(videoId);
      await useCase(videoId);

      // Assert
      verify(mockRepository.getVideoById(videoId)).called(2);
    });
  });
}
