import 'package:flutter/foundation.dart';
import 'package:flutter_reels/domain/entities/video_entity.dart';
import 'package:flutter_reels/domain/usecases/get_videos_usecase.dart';
import 'package:flutter_reels/domain/usecases/increment_share_count_usecase.dart';
import 'package:flutter_reels/domain/usecases/toggle_like_usecase.dart';

/// Provider for managing video state using Provider package with ChangeNotifier.
///
/// This class handles:
/// - Fetching videos from use cases
/// - Managing loading/error states
/// - User interactions (like, share)
/// - Notifying UI of state changes
class VideoProvider with ChangeNotifier {
  final GetVideosUseCase getVideosUseCase;
  final ToggleLikeUseCase toggleLikeUseCase;
  final IncrementShareCountUseCase incrementShareCountUseCase;

  VideoProvider({
    required this.getVideosUseCase,
    required this.toggleLikeUseCase,
    required this.incrementShareCountUseCase,
  });

  // State properties
  List<VideoEntity> _videos = [];
  bool _isLoading = false;
  bool _hasLoadedOnce = false;
  String? _errorMessage;

  // Getters for state
  List<VideoEntity> get videos => _videos;
  bool get isLoading => _isLoading;
  bool get hasLoadedOnce => _hasLoadedOnce;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasVideos => _videos.isNotEmpty;

  /// Loads videos from the use case.
  ///
  /// Sets loading state, fetches videos, and handles errors.
  /// Notifies listeners of state changes.
  Future<void> loadVideos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _videos = await getVideosUseCase();
      _isLoading = false;
      _hasLoadedOnce = true;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasLoadedOnce = true;
      _errorMessage = 'Failed to load videos: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Toggles the like status of a video.
  ///
  /// Updates the video in the list and notifies listeners.
  Future<void> toggleLike(String videoId) async {
    try {
      final updatedVideo = await toggleLikeUseCase(videoId);

      // Find and update the video in the list
      final index = _videos.indexWhere((v) => v.id == videoId);
      if (index != -1) {
        _videos[index] = updatedVideo;
        notifyListeners();
      }
    } catch (e) {
      // In a real app, you might want to show a snackbar or error message
      debugPrint('Failed to toggle like: $e');
    }
  }

  /// Increments the share count for a video.
  ///
  /// Updates the video in the list and notifies listeners.
  Future<void> shareVideo(String videoId) async {
    try {
      final updatedVideo = await incrementShareCountUseCase(videoId);

      // Find and update the video in the list
      final index = _videos.indexWhere((v) => v.id == videoId);
      if (index != -1) {
        _videos[index] = updatedVideo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to increment share count: $e');
    }
  }

  /// Refreshes the video list.
  ///
  /// Useful for pull-to-refresh functionality.
  Future<void> refresh() async {
    await loadVideos();
  }

  /// Clears any error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
