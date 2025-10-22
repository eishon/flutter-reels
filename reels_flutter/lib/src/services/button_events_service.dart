import '../pigeon_generated.dart';

/// Service for button event communication with native platform
class ButtonEventsService {
  ButtonEventsService({required this.api});

  final ReelsFlutterButtonEventsApi api;

  /// Called before like button click
  void onBeforeLikeButtonClick(String videoId) {
    try {
      api.onBeforeLikeButtonClick(videoId);
      print('[ReelsFlutter] Before like button clicked: $videoId');
    } catch (e) {
      print('[ReelsFlutter] Error on before like: $e');
    }
  }

  /// Called after like action completes
  void onAfterLikeButtonClick(String videoId, bool isLiked, int likeCount) {
    try {
      api.onAfterLikeButtonClick(videoId, isLiked, likeCount);
      print(
        '[ReelsFlutter] After like button clicked: $videoId, liked: $isLiked, count: $likeCount',
      );
    } catch (e) {
      print('[ReelsFlutter] Error on after like: $e');
    }
  }

  /// Called when share button is clicked
  void onShareButtonClick({
    required String videoId,
    required String videoUrl,
    required String title,
    required String description,
    String? thumbnailUrl,
  }) {
    try {
      final shareData = ShareData(
        videoId: videoId,
        videoUrl: videoUrl,
        title: title,
        description: description,
        thumbnailUrl: thumbnailUrl,
      );
      api.onShareButtonClick(shareData);
      print('[ReelsFlutter] Share button clicked: $videoId');
    } catch (e) {
      print('[ReelsFlutter] Error on share: $e');
    }
  }
}
