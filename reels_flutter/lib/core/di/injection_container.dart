import 'package:reels_flutter/core/platform/platform_initializer.dart';
import 'package:reels_flutter/core/services/access_token_service.dart';
import 'package:reels_flutter/core/services/analytics_service.dart';
import 'package:reels_flutter/core/services/button_events_service.dart';
import 'package:reels_flutter/core/services/navigation_events_service.dart';
import 'package:reels_flutter/core/services/state_events_service.dart';
import 'package:reels_flutter/data/datasources/video_local_data_source.dart';
import 'package:reels_flutter/data/repositories/video_repository_impl.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';
import 'package:reels_flutter/domain/usecases/get_video_by_id_usecase.dart';
import 'package:reels_flutter/domain/usecases/get_videos_usecase.dart';
import 'package:reels_flutter/domain/usecases/increment_share_count_usecase.dart';
import 'package:reels_flutter/domain/usecases/toggle_like_usecase.dart';
import 'package:get_it/get_it.dart';

/// Service locator for dependency injection.
///
/// Uses get_it package to manage dependencies throughout the app.
/// This provides a centralized place to register and resolve dependencies.
///
/// Benefits:
/// - Loose coupling between layers
/// - Easy to test (can replace with mocks)
/// - Single source of truth for instances
/// - Lazy initialization support
final sl = GetIt.instance;

/// Initializes all dependencies.
///
/// This should be called once at app startup, before running the app.
/// Dependencies are registered in order:
/// platform services → data sources → repositories → use cases.
///
/// Example:
/// ```dart
/// void main() async {
///   await initializeDependencies();
///   runApp(MyApp());
/// }
/// ```
Future<void> initializeDependencies() async {
  // Platform services
  // Initialize native platform communication and get services
  final platformServices = PlatformInitializer.initializePlatformAPIs();
  sl.registerSingleton<AccessTokenService>(platformServices.accessTokenService);
  sl.registerSingleton<AnalyticsService>(platformServices.analyticsService);
  sl.registerSingleton<ButtonEventsService>(
    platformServices.buttonEventsService,
  );
  sl.registerSingleton<StateEventsService>(platformServices.stateEventsService);
  sl.registerSingleton<NavigationEventsService>(
    platformServices.navigationEventsService,
  );

  // Data sources
  // Registered as lazy singleton - created only when first accessed
  sl.registerLazySingleton<VideoLocalDataSource>(() => VideoLocalDataSource());

  // Repositories
  // Registered as lazy singleton - created only when first accessed
  // Depends on VideoLocalDataSource
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(localDataSource: sl<VideoLocalDataSource>()),
  );

  // Use cases
  // Registered as factory - new instance created each time
  // This is preferred for use cases as they're typically lightweight

  sl.registerFactory(() => GetVideosUseCase(sl<VideoRepository>()));

  sl.registerFactory(() => GetVideoByIdUseCase(sl<VideoRepository>()));

  sl.registerFactory(() => ToggleLikeUseCase(sl<VideoRepository>()));

  sl.registerFactory(() => IncrementShareCountUseCase(sl<VideoRepository>()));
}

/// Resets all registered dependencies.
///
/// Useful for testing to ensure a clean state between tests.
/// Should NOT be called in production code.
Future<void> resetDependencies() async {
  await sl.reset();
}
