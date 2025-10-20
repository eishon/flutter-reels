/// Reusable mock classes and annotations for testing
///
/// This file centralizes all mock class definitions using mockito.
/// These mocks are used across different test files to maintain consistency.

import 'package:flutter_reels/core/services/analytics_service.dart';
import 'package:flutter_reels/data/datasources/video_local_data_source.dart';
import 'package:flutter_reels/domain/repositories/video_repository.dart';
import 'package:flutter_reels/domain/usecases/get_video_by_id_usecase.dart';
import 'package:flutter_reels/domain/usecases/get_videos_usecase.dart';
import 'package:flutter_reels/domain/usecases/increment_share_count_usecase.dart';
import 'package:flutter_reels/domain/usecases/toggle_like_usecase.dart';
import 'package:mockito/annotations.dart';

/// Generate mocks for these classes by running:
/// flutter pub run build_runner build --delete-conflicting-outputs
///
/// This will generate test_mocks.mocks.dart file
@GenerateMocks([
  // Core services
  AnalyticsService,

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
