import 'package:flutter/material.dart';
import 'package:flutter_reels/presentation/providers/video_provider.dart';
import 'package:flutter_reels/presentation/widgets/video_reel_item.dart';
import 'package:provider/provider.dart';

/// Full-screen reels interface with vertical scrolling
///
/// Features:
/// - Vertical PageView for smooth scrolling between videos
/// - Full-screen immersive experience
/// - Pull-to-refresh functionality
/// - Loading and error states
class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Load videos when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().loadVideos();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _onRefresh() async {
    await context.read<VideoProvider>().refresh();
    // Reset to first video after refresh
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          // Loading state
          if (videoProvider.isLoading && !videoProvider.hasVideos) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          // Error state
          if (videoProvider.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      videoProvider.errorMessage ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => videoProvider.loadVideos(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state
          if (!videoProvider.hasVideos) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.video_library_outlined,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No videos available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          // Success state - display reels
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: Colors.white,
            backgroundColor: Colors.black87,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: videoProvider.videos.length,
              itemBuilder: (context, index) {
                final video = videoProvider.videos[index];
                return VideoReelItem(
                  video: video,
                  onLike: () => videoProvider.toggleLike(video.id),
                  onShare: () => videoProvider.shareVideo(video.id),
                  isActive: index == _currentIndex,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
