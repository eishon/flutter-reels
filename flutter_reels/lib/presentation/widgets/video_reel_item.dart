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
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 8.0,
                ),
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

              // Products button at bottom (if products available)
              if (video.hasProducts)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: _buildProductsButton(context),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProductsSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              color: Colors.grey.shade900,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'View ${video.productCount} ${video.productCount == 1 ? "Product" : "Products"}',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Products in this video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...video.products.map((product) {
                return Card(
                  color: Colors.grey.shade800,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Colors.white54,
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${product.currency}${product.price}',
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle product purchase
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('View'),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
