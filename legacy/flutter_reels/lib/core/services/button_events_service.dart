import 'package:flutter_reels/core/platform/messages.g.dart';

/// Service for notifying native platform about button interaction events
///
/// This service wraps the FlutterReelsButtonEventsApi to send button click
/// events to the native platform, enabling native to:
/// - Show/hide loading indicators
/// - Update UI optimistically
/// - Show custom feedback
/// - Handle native sharing
class ButtonEventsService {
  /// Creates a button events service
  ///
  /// [api] The native button events API implementation
  ButtonEventsService({required FlutterReelsButtonEventsApi api}) : _api = api;

  final FlutterReelsButtonEventsApi _api;

  /// Notify native that the like button is about to be clicked
  ///
  /// This is called BEFORE the like action is processed.
  /// Native can use this to:
  /// - Show loading/processing indicator
  /// - Update UI optimistically
  /// - Prepare for state change
  ///
  /// [videoId] The ID of the video being liked/unliked
  void notifyBeforeLikeClick(String videoId) {
    _api.onBeforeLikeButtonClick(videoId);
  }

  /// Notify native that the like action has completed
  ///
  /// This is called AFTER the like action is processed.
  /// Native can use this to:
  /// - Hide loading indicator
  /// - Update final UI state
  /// - Show success/failure feedback
  /// - Sync with native data store
  ///
  /// [videoId] The ID of the video
  /// [isLiked] Whether the video is now liked (true) or unliked (false)
  /// [likeCount] The updated total like count
  void notifyAfterLikeClick({
    required String videoId,
    required bool isLiked,
    required int likeCount,
  }) {
    _api.onAfterLikeButtonClick(videoId, isLiked, likeCount);
  }

  /// Notify native that the share button was clicked
  ///
  /// Native can use this to:
  /// - Show native share sheet
  /// - Implement custom sharing logic
  /// - Track share metrics
  /// - Add custom share options
  ///
  /// [videoId] The ID of the video being shared
  /// [videoUrl] The URL to share
  /// [title] The title for the share
  /// [description] The description for the share
  /// [thumbnailUrl] Optional thumbnail URL for the share preview
  void notifyShareClick({
    required String videoId,
    required String videoUrl,
    required String title,
    required String description,
    String? thumbnailUrl,
  }) {
    final shareData = ShareData(
      videoId: videoId,
      videoUrl: videoUrl,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
    );
    _api.onShareButtonClick(shareData);
  }
}
