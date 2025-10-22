/// Reusable mock classes and annotations for testing
///
/// This file centralizes all mock class definitions using mockito.
/// These mocks are used across different test files to maintain consistency.

import 'package:reels_flutter/core/pigeon_generated.dart';
import 'package:reels_flutter/core/services/analytics_service.dart';
import 'package:reels_flutter/core/services/button_events_service.dart';
import 'package:reels_flutter/data/datasources/video_local_data_source.dart';
import 'package:reels_flutter/domain/repositories/video_repository.dart';
import 'package:reels_flutter/domain/usecases/get_video_by_id_usecase.dart';
import 'package:reels_flutter/domain/usecases/get_videos_usecase.dart';
import 'package:reels_flutter/domain/usecases/increment_share_count_usecase.dart';
import 'package:reels_flutter/domain/usecases/toggle_like_usecase.dart';
import 'package:mockito/annotations.dart';

export 'test_mocks.mocks.dart';

/// Generate mocks for these classes by running:
/// flutter pub run build_runner build --delete-conflicting-outputs
///
/// This will generate test_mocks.mocks.dart file
@GenerateMocks([
  // Core Pigeon APIs
  ReelsFlutterAnalyticsApi,
  ReelsFlutterButtonEventsApi,
  ReelsFlutterNavigationApi,
  ReelsFlutterStateApi,

  // Core services
  AnalyticsService,
  ButtonEventsService,

  // Data layer
  VideoLocalDataSource,

  // Domain layer
  VideoRepository,
  GetVideosUseCase,
  GetVideoByIdUseCase,
  ToggleLikeUseCase,
  IncrementShareCountUseCase,
])
void main() {}
