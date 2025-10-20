import 'package:flutter/material.dart';
import 'package:flutter_reels/main.dart';
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

class _ReelsScreenState extends State<ReelsScreen>
    with WidgetsBindingObserver, RouteAware {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isScreenActive = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addObserver(this);

    // Load videos when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().loadVideos();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      _isScreenActive = state == AppLifecycleState.resumed;
    });
  }

  @override
  void didPush() {
    // Called when this route has been pushed
    setState(() {
      _isScreenActive = true;
    });
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and this route shows up
    setState(() {
      _isScreenActive = true;
    });
  }

  @override
  void didPushNext() {
    // Called when a new route has been pushed, and this route is no longer visible
    setState(() {
      _isScreenActive = false;
    });
  }

  @override
  void didPop() {
    // Called when this route has been popped off
    setState(() {
      _isScreenActive = false;
    });
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
          // Loading state - show only when loading and no videos loaded yet
          if (videoProvider.isLoading && !videoProvider.hasVideos) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          // Error state - show only after loading is complete
          if (videoProvider.hasError && !videoProvider.isLoading) {
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

          // Empty state - show only after loading is complete and no videos
          if (!videoProvider.hasVideos && !videoProvider.isLoading) {
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
                  isActive: index == _currentIndex && _isScreenActive,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
