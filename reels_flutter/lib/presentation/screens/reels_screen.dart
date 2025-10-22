import 'package:flutter/material.dart';
import 'package:reels_flutter/core/di/injection_container.dart';
import 'package:reels_flutter/core/services/access_token_service.dart';
import 'package:reels_flutter/core/services/analytics_service.dart';
import 'package:reels_flutter/core/services/state_events_service.dart';
import 'package:reels_flutter/main.dart';
import 'package:reels_flutter/presentation/providers/video_provider.dart';
import 'package:reels_flutter/presentation/widgets/video_reel_item.dart';
import 'package:provider/provider.dart';

/// Full-screen reels interface with vertical scrolling
///
/// Features:
/// - Vertical PageView for smooth scrolling between videos
/// - Full-screen immersive experience
/// - Pull-to-refresh functionality
/// - Loading and error states
/// - Analytics tracking for video views and page views
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
  late AnalyticsService _analyticsService;
  late StateEventsService _stateEventsService;
  late AccessTokenService _accessTokenService;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _analyticsService = sl<AnalyticsService>();
    _stateEventsService = sl<StateEventsService>();
    _accessTokenService = sl<AccessTokenService>();
    WidgetsBinding.instance.addObserver(this);

    // Load videos when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().loadVideos();

      // Track page view
      _analyticsService.trackPageView('reels_screen');

      // Notify native that screen appeared
      _stateEventsService.notifyScreenFocused(screenName: 'reels_screen');
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

    // Notify native of screen focus state based on app lifecycle
    if (state == AppLifecycleState.resumed) {
      _stateEventsService.notifyScreenFocused(screenName: 'reels_screen');
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stateEventsService.notifyScreenUnfocused(screenName: 'reels_screen');
    }
  }

  @override
  void didPush() {
    // Called when this route has been pushed
    setState(() {
      _isScreenActive = true;
    });

    // Notify native that screen gained focus
    _stateEventsService.notifyScreenFocused(screenName: 'reels_screen');
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and this route shows up
    setState(() {
      _isScreenActive = true;
    });

    // Notify native that screen regained focus
    _stateEventsService.notifyScreenFocused(screenName: 'reels_screen');
  }

  @override
  void didPushNext() {
    // Called when a new route has been pushed, and this route is no longer visible
    setState(() {
      _isScreenActive = false;
    });

    // Notify native that screen lost focus
    _stateEventsService.notifyScreenUnfocused(screenName: 'reels_screen');
  }

  @override
  void didPop() {
    // Called when this route has been popped off
    setState(() {
      _isScreenActive = false;
    });

    // Notify native that screen disappeared
    _stateEventsService.notifyScreenUnfocused(screenName: 'reels_screen');
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Track video appear event
    final videoProvider = context.read<VideoProvider>();
    if (index < videoProvider.videos.length) {
      final video = videoProvider.videos[index];
      _analyticsService.trackVideoAppear(
        videoId: video.id,
        position: index,
        screenName: 'reels_screen',
      );
    }
  }

  Future<void> _onRefresh() async {
    await context.read<VideoProvider>().refresh();
    // Reset to first video after refresh
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  Future<void> _testAccessToken() async {
    print('🧪 [Test] Testing Access Token...');
    try {
      final token = await _accessTokenService.getToken();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Access Token'),
          content: SingleChildScrollView(
            child: SelectableText(
              token ?? 'No token received from native',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: token != null ? Colors.black : Colors.red,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );

      print('🧪 [Test] Access Token Result: ${token ?? "null"}');
    } catch (e) {
      print('🧪 [Test] Access Token Error: $e');

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to get access token:\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.grey[900],
            onSelected: (value) {
              if (value == 'test_token') {
                _testAccessToken();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'test_token',
                child: Row(
                  children: [
                    Icon(Icons.vpn_key, color: Colors.white70),
                    SizedBox(width: 12),
                    Text(
                      'Test Access Token',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          // Loading state - show only when loading for the first time
          if (videoProvider.isLoading && !videoProvider.hasLoadedOnce) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // Error state - show only after loading is complete
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
          if (!videoProvider.hasVideos && videoProvider.hasLoadedOnce) {
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
