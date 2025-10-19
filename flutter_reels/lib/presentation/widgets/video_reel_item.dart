import 'package:flutter/material.dart';
import 'package:flutter_reels/domain/entities/video_entity.dart';
import 'package:flutter_reels/presentation/widgets/engagement_buttons.dart';
import 'package:flutter_reels/presentation/widgets/video_description.dart';
import 'package:flutter_reels/presentation/widgets/video_player_widget.dart';

/// Full-screen video reel item with overlay controls
///
/// Features:
/// - Full-screen auto-playing video
/// - User avatar and username
/// - Engagement buttons (like, comment, share)
/// - Video description with hashtags
/// - Product tags
class VideoReelItem extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final bool isActive;

  const VideoReelItem({
    super.key,
    required this.video,
    required this.onLike,
    required this.onShare,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player
        VideoPlayerWidget(
          videoUrl: video.url,
          isActive: isActive,
        ),

        // Top gradient overlay for better text visibility
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom gradient overlay for better text visibility
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black87,
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Main content overlay
        SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Bottom content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Video description and user info
                    Expanded(
                      child: VideoDescription(video: video),
                    ),
                    const SizedBox(width: 12),
                    // Engagement buttons
                    EngagementButtons(
                      video: video,
                      onLike: onLike,
                      onShare: onShare,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
