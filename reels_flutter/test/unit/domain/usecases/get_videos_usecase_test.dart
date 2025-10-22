import 'package:reels_flutter/domain/usecases/get_videos_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.dart';
import '../../../helpers/test_mocks.mocks.dart';

/// Unit tests for GetVideosUseCase
///
/// Tests cover:
/// - Successful retrieval of videos from repository
/// - Calling repository method exactly once
/// - Returning correct data from repository
/// - Handling empty list
void main() {
  late GetVideosUseCase useCase;
  late MockVideoRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoRepository();
    useCase = GetVideosUseCase(mockRepository);
  });

  group('GetVideosUseCase', () {
    test('should get videos from repository', () async {
      // Arrange
      final testVideos = createTestVideoList(count: 3);
      when(mockRepository.getVideos()).thenAnswer((_) async => testVideos);

      // Act
      final result = await useCase();

      // Assert
      expect(result, testVideos);
      verify(mockRepository.getVideos()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when repository returns empty', () async {
      // Arrange
      when(mockRepository.getVideos()).thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getVideos()).called(1);
    });

    test('should return large list of videos', () async {
      // Arrange
      final largeVideoList = createTestVideoList(count: 100);
      when(mockRepository.getVideos()).thenAnswer((_) async => largeVideoList);

      // Act
      final result = await useCase();

      // Assert
      expect(result.length, 100);
      verify(mockRepository.getVideos()).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(mockRepository.getVideos())
          .thenThrow(Exception('Failed to load videos'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
      verify(mockRepository.getVideos()).called(1);
    });

    test('should call repository on multiple invocations', () async {
      // Arrange
      final testVideos = createTestVideoList(count: 2);
      when(mockRepository.getVideos()).thenAnswer((_) async => testVideos);

      // Act
      await useCase();
      await useCase();
      await useCase();

      // Assert
      verify(mockRepository.getVideos()).called(3);
    });
  });
}
