import 'package:reels_flutter/core/di/injection_container.dart';
import 'package:reels_flutter/data/datasources/video_local_data_source.dart';
import 'package:reels_flutter/data/repositories/video_repository_impl.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';
import 'package:reels_flutter/domain/usecases/get_video_by_id_usecase.dart';
import 'package:reels_flutter/domain/usecases/get_videos_usecase.dart';
import 'package:reels_flutter/domain/usecases/increment_share_count_usecase.dart';
import 'package:reels_flutter/domain/usecases/toggle_like_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for dependency injection container
///
/// Tests focus on:
/// - Proper registration of all dependencies
/// - Singleton vs factory patterns
/// - Dependency resolution without actual instantiation
void main() {
  setUp(() async {
    await resetDependencies();
  });

  tearDown(() async {
    await resetDependencies();
  });

  group('Dependency Injection Container', () {
    group('registration', () {
      test('should register all dependencies successfully', () async {
        // Act
        await initializeDependencies();

        // Assert - all types should be registered
        expect(sl.isRegistered<VideoLocalDataSource>(), true);
        expect(sl.isRegistered<VideoRepository>(), true);
        expect(sl.isRegistered<GetVideosUseCase>(), true);
        expect(sl.isRegistered<GetVideoByIdUseCase>(), true);
        expect(sl.isRegistered<ToggleLikeUseCase>(), true);
        expect(sl.isRegistered<IncrementShareCountUseCase>(), true);
      });

      test('should not allow re-registration without reset', () async {
        // Arrange
        await initializeDependencies();

        // Act & Assert
        expect(() => initializeDependencies(), throwsArgumentError);
      });
    });

    group('singleton behavior', () {
      test('VideoRepository should be registered as singleton', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final instance1 = sl<VideoRepository>();
        final instance2 = sl<VideoRepository>();

        // Assert - should return same instance
        expect(identical(instance1, instance2), true);
      });

      test('VideoRepository should be VideoRepositoryImpl', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final repository = sl<VideoRepository>();

        // Assert
        expect(repository, isA<VideoRepositoryImpl>());
      });
    });

    group('factory behavior', () {
      test('GetVideosUseCase should be registered as factory', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final instance1 = sl<GetVideosUseCase>();
        final instance2 = sl<GetVideosUseCase>();

        // Assert - should return different instances
        expect(identical(instance1, instance2), false);
        expect(instance1, isA<GetVideosUseCase>());
        expect(instance2, isA<GetVideosUseCase>());
      });

      test('GetVideoByIdUseCase should be registered as factory', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final instance1 = sl<GetVideoByIdUseCase>();
        final instance2 = sl<GetVideoByIdUseCase>();

        // Assert
        expect(identical(instance1, instance2), false);
      });

      test('ToggleLikeUseCase should be registered as factory', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final instance1 = sl<ToggleLikeUseCase>();
        final instance2 = sl<ToggleLikeUseCase>();

        // Assert
        expect(identical(instance1, instance2), false);
      });

      test(
        'IncrementShareCountUseCase should be registered as factory',
        () async {
          // Arrange
          await initializeDependencies();

          // Act
          final instance1 = sl<IncrementShareCountUseCase>();
          final instance2 = sl<IncrementShareCountUseCase>();

          // Assert
          expect(identical(instance1, instance2), false);
        },
      );
    });

    group('dependency injection', () {
      test('use cases should receive same repository singleton', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final useCase1 = sl<GetVideosUseCase>();
        final useCase2 = sl<GetVideoByIdUseCase>();
        final useCase3 = sl<ToggleLikeUseCase>();
        final useCase4 = sl<IncrementShareCountUseCase>();

        // Assert - all should share same repository instance
        expect(identical(useCase1.repository, useCase2.repository), true);
        expect(identical(useCase2.repository, useCase3.repository), true);
        expect(identical(useCase3.repository, useCase4.repository), true);
      });

      test('repository should have data source injected', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final repository = sl<VideoRepository>() as VideoRepositoryImpl;
        final dataSource = sl<VideoLocalDataSource>();

        // Assert - repository should use the registered data source
        expect(identical(repository.localDataSource, dataSource), true);
      });
    });

    group('reset functionality', () {
      test('should clear all registrations on reset', () async {
        // Arrange
        await initializeDependencies();
        expect(sl.isRegistered<VideoRepository>(), true);

        // Act
        await resetDependencies();

        // Assert - nothing should be registered
        expect(sl.isRegistered<VideoRepository>(), false);
        expect(sl.isRegistered<VideoLocalDataSource>(), false);
        expect(sl.isRegistered<GetVideosUseCase>(), false);
      });

      test('should allow re-initialization after reset', () async {
        // Arrange
        await initializeDependencies();
        await resetDependencies();

        // Act
        await initializeDependencies();

        // Assert - should be able to get dependencies again
        expect(sl.isRegistered<VideoRepository>(), true);
        final repository = sl<VideoRepository>();
        expect(repository, isNotNull);
      });

      test('should create new instances after reset and re-init', () async {
        // Arrange
        await initializeDependencies();
        final firstRepo = sl<VideoRepository>();

        // Act
        await resetDependencies();
        await initializeDependencies();
        final secondRepo = sl<VideoRepository>();

        // Assert - should be different instances
        expect(identical(firstRepo, secondRepo), false);
      });
    });

    group('type verification', () {
      test('all use cases should have correct types', () async {
        // Arrange
        await initializeDependencies();

        // Act & Assert
        expect(sl<GetVideosUseCase>(), isA<GetVideosUseCase>());
        expect(sl<GetVideoByIdUseCase>(), isA<GetVideoByIdUseCase>());
        expect(sl<ToggleLikeUseCase>(), isA<ToggleLikeUseCase>());
        expect(
          sl<IncrementShareCountUseCase>(),
          isA<IncrementShareCountUseCase>(),
        );
      });

      test('repository should implement VideoRepository interface', () async {
        // Arrange
        await initializeDependencies();

        // Act
        final repository = sl<VideoRepository>();

        // Assert
        expect(repository, isA<VideoRepository>());
        expect(repository, isA<VideoRepositoryImpl>());
      });
    });
  });
}
