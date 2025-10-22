import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reels_flutter/core/di/injection_container.dart';
import 'package:reels_flutter/presentation/providers/video_provider.dart';
import 'package:reels_flutter/presentation/screens/reels_screen.dart';
import 'package:provider/provider.dart';

/// Entry point for the Flutter Reels application
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for immersive full-screen experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize dependency injection container
  await initializeDependencies();

  runApp(const ReelsFlutterApp());
}

/// Global route observer to track navigation lifecycle events
/// Used in ReelsScreen to manage video playback state
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// Main application widget for Flutter Reels
///
/// This widget sets up:
/// - State management providers (VideoProvider)
/// - Material Design theme (dark mode)
/// - Navigation and routing
class ReelsFlutterApp extends StatelessWidget {
  const ReelsFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // VideoProvider manages video state, likes, and shares
        ChangeNotifierProvider(
          create: (_) => VideoProvider(
            getVideosUseCase: sl(),
            toggleLikeUseCase: sl(),
            incrementShareCountUseCase: sl(),
            analyticsService: sl(),
            buttonEventsService: sl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Reels',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.dark,
          // Dark theme optimized for video viewing
          scaffoldBackgroundColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        home: const ReelsScreen(),
      ),
    );
  }
}
