import 'package:flutter_reels/domain/usecases/toggle_like_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.dart';
import '../../../helpers/test_mocks.mocks.dart';

/// Unit tests for ToggleLikeUseCase
///
/// Tests cover:
/// - Successfully toggling like state (false -> true)
/// - Successfully toggling unlike state (true -> false)
/// - Passing correct id to repository
/// - Verifying repository method called once
/// - Handling exceptions
void main() {
  late ToggleLikeUseCase useCase;
  late MockVideoRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoRepository();
    useCase = ToggleLikeUseCase(mockRepository);
  });

  group('ToggleLikeUseCase', () {
    test('should toggle like from false to true', () async {
      // Arrange
      const videoId = 'video-123';
      final unlikedVideo =
          createTestVideo(id: videoId, isLiked: false, likes: 100);
      final likedVideo = unlikedVideo.copyWith(isLiked: true, likes: 101);

      when(mockRepository.toggleLike(videoId))
          .thenAnswer((_) async => likedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.id, videoId);
      expect(result.isLiked, true);
      expect(result.likes, 101);
      verify(mockRepository.toggleLike(videoId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should toggle like from true to false', () async {
      // Arrange
      const videoId = 'video-123';
      final likedVideo =
          createTestVideo(id: videoId, isLiked: true, likes: 101);
      final unlikedVideo = likedVideo.copyWith(isLiked: false, likes: 100);

      when(mockRepository.toggleLike(videoId))
          .thenAnswer((_) async => unlikedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.id, videoId);
      expect(result.isLiked, false);
      expect(result.likes, 100);
      verify(mockRepository.toggleLike(videoId)).called(1);
    });

    test('should pass correct video id to repository', () async {
      // Arrange
      const videoId = 'specific-video-id';
      final video = createTestVideo(id: videoId);

      when(mockRepository.toggleLike(videoId)).thenAnswer((_) async => video);

      // Act
      await useCase(videoId);

      // Assert
      verify(mockRepository.toggleLike(videoId)).called(1);
    });

    test('should handle toggling like on video with zero likes', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(id: videoId, isLiked: false, likes: 0);
      final likedVideo = video.copyWith(isLiked: true, likes: 1);

      when(mockRepository.toggleLike(videoId))
          .thenAnswer((_) async => likedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.isLiked, true);
      expect(result.likes, 1);
      verify(mockRepository.toggleLike(videoId)).called(1);
    });

    test('should handle toggling like on video with many likes', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(id: videoId, isLiked: false, likes: 999999);
      final likedVideo = video.copyWith(isLiked: true, likes: 1000000);

      when(mockRepository.toggleLike(videoId))
          .thenAnswer((_) async => likedVideo);

      // Act
      final result = await useCase(videoId);

      // Assert
      expect(result.isLiked, true);
      expect(result.likes, 1000000);
      verify(mockRepository.toggleLike(videoId)).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      const videoId = 'video-123';
      when(mockRepository.toggleLike(videoId))
          .thenThrow(Exception('Failed to toggle like'));

      // Act & Assert
      expect(
        () => useCase(videoId),
        throwsA(isA<Exception>()),
      );
      verify(mockRepository.toggleLike(videoId)).called(1);
    });

    test('should throw exception when id is empty', () async {
      // Arrange
      const videoId = '';

      // Act & Assert
      expect(
        () => useCase(videoId),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should allow multiple toggle calls', () async {
      // Arrange
      const videoId = 'video-123';
      final video = createTestVideo(id: videoId);

      when(mockRepository.toggleLike(videoId)).thenAnswer((_) async => video);

      // Act
      await useCase(videoId);
      await useCase(videoId);
      await useCase(videoId);

      // Assert
      verify(mockRepository.toggleLike(videoId)).called(3);
    });

    test('should handle toggling likes on different videos', () async {
      // Arrange
      final video1 = createTestVideo(id: 'video-1', isLiked: false);
      final video2 = createTestVideo(id: 'video-2', isLiked: true);
      final likedVideo1 = video1.copyWith(isLiked: true);
      final unlikedVideo2 = video2.copyWith(isLiked: false);

      when(mockRepository.toggleLike('video-1'))
          .thenAnswer((_) async => likedVideo1);
      when(mockRepository.toggleLike('video-2'))
          .thenAnswer((_) async => unlikedVideo2);

      // Act
      final result1 = await useCase('video-1');
      final result2 = await useCase('video-2');

      // Assert
      expect(result1.id, 'video-1');
      expect(result1.isLiked, true);
      expect(result2.id, 'video-2');
      expect(result2.isLiked, false);
      verify(mockRepository.toggleLike('video-1')).called(1);
      verify(mockRepository.toggleLike('video-2')).called(1);
    });
  });
}
