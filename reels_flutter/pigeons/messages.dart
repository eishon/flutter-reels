import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeon_generated.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/eishon/reels_flutter/PigeonGenerated.kt',
    kotlinOptions: KotlinOptions(package: 'com.eishon.reels_flutter'),
    swiftOut: 'ios/Classes/PigeonGenerated.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'reels_flutter',
  ),
)
/// Configuration for the Reels SDK
class ReelsConfig {
  const ReelsConfig({
    required this.autoPlay,
    required this.showControls,
    required this.loopVideos,
  });

  final bool autoPlay;
  final bool showControls;
  final bool loopVideos;
}

/// Data model for a video in the reels
class VideoData {
  const VideoData({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    this.title,
    this.description,
    this.authorName,
    this.authorAvatarUrl,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.isLiked,
  });

  final String id;
  final String url;
  final String? thumbnailUrl;
  final String? title;
  final String? description;
  final String? authorName;
  final String? authorAvatarUrl;
  final int? likeCount;
  final int? commentCount;
  final int? shareCount;
  final bool? isLiked;
}

/// Product information for tagging in reels
class ProductData {
  const ProductData({
    required this.id,
    required this.name,
    this.imageUrl,
    this.price,
    this.currency,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final double? price;
  final String? currency;
}

/// API called by native platform to communicate with Flutter
@HostApi()
abstract class ReelsFlutterApi {
  /// Initialize the Reels SDK with configuration
  void initialize(ReelsConfig config);

  /// Show reels with the provided video data
  void showReels(List<VideoData> videos);

  /// Update a specific video's data (e.g., after a like/share)
  void updateVideo(VideoData video);

  /// Close the reels view
  void closeReels();

  /// Update the configuration
  void updateConfig(ReelsConfig config);
}

/// API called by Flutter to communicate with native platform
@FlutterApi()
abstract class ReelsNativeApi {
  /// Called when a reel is viewed (displayed for significant time)
  void onReelViewed(String videoId);

  /// Called when user likes/unlikes a video
  void onReelLiked(String videoId, bool isLiked);

  /// Called when user shares a video
  void onReelShared(String videoId);

  /// Called when user comments on a video
  void onReelCommented(String videoId);

  /// Called when a product in the reel is clicked
  void onProductClicked(String productId, String videoId);

  /// Called when reels view is closed
  void onReelsClosed();

  /// Called when an error occurs
  void onError(String errorMessage);

  /// Request access token for authenticated API calls
  String? getAccessToken();
}
