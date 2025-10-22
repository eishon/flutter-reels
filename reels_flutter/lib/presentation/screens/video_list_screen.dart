import 'package:flutter/material.dart';
import 'package:reels_flutter/presentation/providers/video_provider.dart';
import 'package:provider/provider.dart';

/// Screen that displays a list of videos to verify data flow.
///
/// This is a test widget demonstrating the complete architecture:
/// - Loads data from VideoProvider
/// - Displays loading/error/success states
/// - Shows video information including title, user, engagement stats, products
/// - Allows interaction (like, share)
class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  @override
  void initState() {
    super.initState();
    // Load videos when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().loadVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Reels'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<VideoProvider>().refresh(),
          ),
        ],
      ),
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          // Loading state - only show if we haven't loaded data yet
          if (videoProvider.isLoading && !videoProvider.hasLoadedOnce) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading videos...'),
                ],
              ),
            );
          }

          // Error state
          if (videoProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    videoProvider.errorMessage ?? 'Unknown error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => videoProvider.loadVideos(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state - only show if we've loaded data and there are no videos
          if (!videoProvider.hasVideos && videoProvider.hasLoadedOnce) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('No videos available'),
                ],
              ),
            );
          }

          // Success state - display videos
          return RefreshIndicator(
            onRefresh: () => videoProvider.refresh(),
            child: ListView.builder(
              itemCount: videoProvider.videos.length,
              itemBuilder: (context, index) {
                final video = videoProvider.videos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                video.user.avatarUrl,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                video.user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Video metadata
                            Chip(
                              label: Text(
                                video.quality,
                                style: const TextStyle(fontSize: 12),
                              ),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Video title
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Video description
                        Text(
                          video.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),

                        // Video URL chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 16,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  video.url,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Engagement stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Like button
                            TextButton.icon(
                              onPressed: () {
                                videoProvider.toggleLike(video.id);
                              },
                              icon: Icon(
                                video.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: video.isLiked ? Colors.red : Colors.grey,
                              ),
                              label: Text('${video.likes}'),
                            ),
                            // Comments
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.comment_outlined,
                                color: Colors.grey,
                              ),
                              label: Text('${video.comments}'),
                            ),
                            // Share button
                            TextButton.icon(
                              onPressed: () {
                                videoProvider.shareVideo(video.id);
                              },
                              icon: const Icon(
                                Icons.share_outlined,
                                color: Colors.grey,
                              ),
                              label: Text('${video.shares}'),
                            ),
                          ],
                        ),

                        // Products section (if any)
                        if (video.hasProducts) ...[
                          const Divider(),
                          Text(
                            'Products (${video.productCount})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: video.products.length,
                              itemBuilder: (context, productIndex) {
                                final product = video.products[productIndex];
                                return Card(
                                  child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${product.currency}${product.price}',
                                          style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (product.discountPrice != null)
                                          Text(
                                            product.currency +
                                                product.discountPrice!,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.amber.shade700,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${product.rating}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
