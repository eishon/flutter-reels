import 'package:flutter/material.dart';
import 'src/platform/platform_initializer.dart';

late PlatformServices platformServices;

void main() {
  // Initialize platform APIs before running app
  platformServices = PlatformInitializer.initializePlatformAPIs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const TestPlatformPage(),
    );
  }
}

/// Test page to verify all platform APIs
class TestPlatformPage extends StatefulWidget {
  const TestPlatformPage({super.key});

  @override
  State<TestPlatformPage> createState() => _TestPlatformPageState();
}

class _TestPlatformPageState extends State<TestPlatformPage> {
  final List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.insert(
        0,
        '[${DateTime.now().toString().substring(11, 19)}] $message',
      );
      if (_logs.length > 50) _logs.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReelsFlutter Platform API Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => setState(() => _logs.clear()),
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Access Token Section
                  const Text(
                    'Access Token API',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      _addLog('Getting access token...');
                      final token = await platformServices.accessTokenService
                          .getAccessToken();
                      _addLog('Token: ${token ?? "null"}');
                    },
                    child: const Text('Get Access Token'),
                  ),
                  const SizedBox(height: 16),

                  // Analytics Section
                  const Text(
                    'Analytics API',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          platformServices.analyticsService.trackEvent(
                            'button_click',
                            {'button': 'test'},
                          );
                          _addLog('Tracked custom event');
                        },
                        child: const Text('Track Event'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.analyticsService.trackVideoView(
                            'video_123',
                            45,
                          );
                          _addLog('Tracked video view');
                        },
                        child: const Text('Track Video View'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.analyticsService.trackPageView(
                            'test_screen',
                          );
                          _addLog('Tracked page view');
                        },
                        child: const Text('Track Page View'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Button Events Section
                  const Text(
                    'Button Events API',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          platformServices.buttonEventsService
                              .onBeforeLikeButtonClick('video_123');
                          _addLog('Before like button click');
                        },
                        child: const Text('Before Like'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.buttonEventsService
                              .onAfterLikeButtonClick('video_123', true, 42);
                          _addLog('After like button click');
                        },
                        child: const Text('After Like'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.buttonEventsService
                              .onShareButtonClick(
                                videoId: 'video_123',
                                videoUrl: 'https://example.com/video/123',
                                title: 'Test Video',
                                description: 'This is a test video',
                                thumbnailUrl: 'https://example.com/thumb.jpg',
                              );
                          _addLog('Share button click');
                        },
                        child: const Text('Share'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // State Events Section
                  const Text(
                    'State Events API',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          platformServices.stateEventsService.screenAppeared(
                            'test_screen',
                          );
                          _addLog('Screen appeared');
                        },
                        child: const Text('Screen Appeared'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.stateEventsService.screenFocused(
                            'test_screen',
                          );
                          _addLog('Screen focused');
                        },
                        child: const Text('Screen Focused'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.stateEventsService.videoPlaying(
                            'video_123',
                            position: 0.0,
                          );
                          _addLog('Video playing');
                        },
                        child: const Text('Video Playing'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.stateEventsService.videoPaused(
                            'video_123',
                            position: 15.0,
                          );
                          _addLog('Video paused');
                        },
                        child: const Text('Video Paused'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Navigation Events Section
                  const Text(
                    'Navigation Events API',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          platformServices.navigationEventsService
                              .onSwipeLeft();
                          _addLog('Swipe left');
                        },
                        child: const Text('Swipe Left'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          platformServices.navigationEventsService
                              .onSwipeRight();
                          _addLog('Swipe right');
                        },
                        child: const Text('Swipe Right'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black87,
              border: Border(top: BorderSide(color: Colors.grey.shade700)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Event Log (${_logs.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) => Text(
                      _logs[index],
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
