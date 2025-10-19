import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reels/core/di/injection_container.dart';
import 'package:flutter_reels/presentation/providers/video_provider.dart';
import 'package:flutter_reels/presentation/screens/reels_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize dependencies
  await initializeDependencies();

  runApp(const FlutterReelsApp());
}

class FlutterReelsApp extends StatelessWidget {
  const FlutterReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Register VideoProvider with dependency injection
        ChangeNotifierProvider(
          create: (_) => VideoProvider(
            getVideosUseCase: sl(),
            toggleLikeUseCase: sl(),
            incrementShareCountUseCase: sl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Reels',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: const ReelsScreen(),
      ),
    );
  }
}

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Reels Module'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.video_library,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Hello World!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Flutter Reels Module',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
