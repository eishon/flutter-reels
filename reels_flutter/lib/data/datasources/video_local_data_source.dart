import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:reels_flutter/data/models/video_model.dart';

/// Local data source that reads video data from assets folder.
///
/// This class handles loading and parsing the mock_videos.json file.
/// In a real app, this could be extended to also handle local database
/// or shared preferences for caching.
class VideoLocalDataSource {
  static const String _mockDataPath = 'assets/mock_videos.json';

  /// Loads and parses videos from the mock JSON file.
  ///
  /// Returns a list of [VideoModel] objects.
  /// Throws an exception if the file cannot be read or parsed.
  Future<List<VideoModel>> getVideos() async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(_mockDataPath);

      // Parse the JSON string
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract the videos array
      final List<dynamic> videosJson = jsonData['videos'] as List;

      // Convert each JSON object to a VideoModel
      final List<VideoModel> videos = videosJson
          .map(
            (videoJson) =>
                VideoModel.fromJson(videoJson as Map<String, dynamic>),
          )
          .toList();

      return videos;
    } catch (e) {
      throw Exception('Failed to load videos from assets: $e');
    }
  }

  /// Gets a single video by its ID.
  ///
  /// Returns the [VideoModel] if found, null otherwise.
  /// Throws an exception if the data cannot be loaded.
  Future<VideoModel?> getVideoById(String id) async {
    final videos = await getVideos();
    try {
      return videos.firstWhere((video) => video.id == id);
    } catch (e) {
      // firstWhere throws if no element is found
      return null;
    }
  }

  /// Toggles the like status of a video.
  ///
  /// Note: This is a mock implementation that modifies in-memory data.
  /// In a real app, this would update a local database or call an API.
  ///
  /// Returns the updated [VideoModel].
  Future<VideoModel> toggleLike(String videoId) async {
    final videos = await getVideos();
    final video = videos.firstWhere(
      (v) => v.id == videoId,
      orElse: () => throw Exception('Video not found: $videoId'),
    );

    // Toggle the like status and update the count
    final bool newIsLiked = !video.isLiked;
    final int newLikes = newIsLiked ? video.likes + 1 : video.likes - 1;

    // Create a new VideoModel with updated values
    // Note: Using copyWith would be cleaner, but VideoEntity has it
    return VideoModel(
      id: video.id,
      url: video.url,
      title: video.title,
      description: video.description,
      user: video.user,
      likes: newLikes,
      comments: video.comments,
      shares: video.shares,
      isLiked: newIsLiked,
      category: video.category,
      duration: video.duration,
      quality: video.quality,
      format: video.format,
      products: video.products,
    );
  }

  /// Increments the share count for a video.
  ///
  /// Note: This is a mock implementation.
  /// In a real app, this would update persistent storage.
  ///
  /// Returns the updated [VideoModel].
  Future<VideoModel> incrementShareCount(String videoId) async {
    final videos = await getVideos();
    final video = videos.firstWhere(
      (v) => v.id == videoId,
      orElse: () => throw Exception('Video not found: $videoId'),
    );

    // Increment the share count
    return VideoModel(
      id: video.id,
      url: video.url,
      title: video.title,
      description: video.description,
      user: video.user,
      likes: video.likes,
      comments: video.comments,
      shares: video.shares + 1,
      isLiked: video.isLiked,
      category: video.category,
      duration: video.duration,
      quality: video.quality,
      format: video.format,
      products: video.products,
    );
  }
}
