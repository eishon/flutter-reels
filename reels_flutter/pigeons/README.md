# Pigeon - Native Platform Communication

This directory contains Pigeon interface definitions for type-safe communication between Flutter and native platforms (Android/iOS).

## What is Pigeon?

Pigeon is a code generator tool that creates type-safe communication channels between Flutter and native code. It eliminates the need for manual MethodChannel coding and provides compile-time type safety.

**Benefits:**
- Type-safe APIs between Flutter and native code
- Automatic serialization/deserialization
- Compile-time errors instead of runtime failures
- Consistent interfaces across platforms
- Reduced boilerplate code

## File Structure

```
reels_flutter/
├── pigeons/
│   ├── messages.dart              # Pigeon interface definitions (source)
│   └── README.md                  # This file
├── lib/core/
│   └── pigeon_generated.dart      # Generated Flutter/Dart code
├── ../reels_android/src/main/java/com/eishon/reels_android/
│   └── PigeonGenerated.kt         # Generated Android/Kotlin code
└── ../reels_ios/Sources/ReelsIOS/
    └── PigeonGenerated.swift      # Generated iOS/Swift code
```

**Note:** Generated files are created automatically by Pigeon and should not be edited manually.

## Configuration

The pigeon configuration in `messages.dart` defines where generated code is placed:

```dart
@ConfigurePigeon(
  PigeonOptions(
    // Flutter/Dart output
    dartOut: 'lib/core/pigeon_generated.dart',
    
    // Android output - directly in reels_android module
    kotlinOut: '../reels_android/src/main/java/com/eishon/reels_android/PigeonGenerated.kt',
    kotlinOptions: KotlinOptions(package: 'com.eishon.reels_android'),
    
    // iOS output - directly in reels_ios module
    swiftOut: '../reels_ios/Sources/ReelsIOS/PigeonGenerated.swift',
    
    dartPackageName: 'reels_flutter',
  ),
)
```

This configuration enables **Add-to-App integration** by generating code directly in the native SDK modules.

## Generating Code

### Manual Generation

After modifying `messages.dart`, regenerate the platform code:

```bash
cd reels_flutter
dart run pigeon --input pigeons/messages.dart
```

This will generate:
- `lib/core/pigeon_generated.dart` - Flutter implementation
- `../reels_android/src/main/java/com/eishon/reels_android/PigeonGenerated.kt` - Android implementation
- `../reels_ios/Sources/ReelsIOS/PigeonGenerated.swift` - iOS implementation

### Automatic Generation

The repository includes a GitHub Actions workflow (`.github/workflows/auto-format-pigeon.yml`) that:
1. Automatically regenerates Pigeon code when `messages.dart` changes
2. Formats the generated files
3. Commits the changes back to the branch

**Trigger conditions:**
- Push to any branch that modifies `pigeons/messages.dart`
- Manual trigger via workflow_dispatch

## API Overview

The module defines several APIs for bidirectional communication between Flutter and native platforms.

### 1. ReelsFlutterTokenApi (Native → Flutter)
**Type:** `@HostApi()` - Native platforms call into Flutter

Provides access token management for authenticated API requests.

```dart
@HostApi()
abstract class ReelsFlutterTokenApi {
  /// Get the current access token from native platform
  String? getAccessToken();
}
```

**Usage:** Native platforms implement this API to provide authentication tokens to Flutter.

### 2. ReelsFlutterAnalyticsApi (Flutter → Native)
**Type:** `@FlutterApi()` - Flutter calls into native platforms

Sends analytics events to native analytics SDK.

```dart
@FlutterApi()
abstract class ReelsFlutterAnalyticsApi {
  /// Track a custom analytics event
  void trackEvent(AnalyticsEvent event);
}
```

**Event Types:**
- Video views
- User interactions (like, share, comment)
- Page views
- Custom events with properties

### 3. ReelsFlutterButtonEventsApi (Flutter → Native)
**Type:** `@FlutterApi()` - Flutter calls into native platforms

Notifies native platforms about button interactions.

```dart
@FlutterApi()
abstract class ReelsFlutterButtonEventsApi {
  /// Called before like button is clicked (for optimistic UI)
  void onBeforeLikeButtonClick(String videoId);
  
  /// Called after like button click completes (with updated state)
  void onAfterLikeButtonClick(String videoId, bool isLiked, int likeCount);
  
  /// Called when share button is clicked
  void onShareButtonClick(ShareData shareData);
}
```

**Use Cases:**
- Optimistic UI updates (before network call)
- Native analytics tracking
- Opening native share sheets
- Updating local cache

### 4. ReelsFlutterStateApi (Flutter → Native)
**Type:** `@FlutterApi()` - Flutter calls into native platforms

Notifies native platforms about screen and video state changes.

```dart
@FlutterApi()
abstract class ReelsFlutterStateApi {
  /// Notify native when screen state changes
  void onScreenStateChanged(ScreenStateData state);
  
  /// Notify native when video state changes
  void onVideoStateChanged(VideoStateData state);
}
```

**Screen States:** `appeared`, `disappeared`, `focused`, `unfocused`

**Video States:** `playing`, `paused`, `stopped`, `buffering`, `completed`

### 5. ReelsFlutterNavigationApi (Flutter → Native)
**Type:** `@FlutterApi()` - Flutter calls into native platforms

Handles navigation gestures for native integration.

```dart
@FlutterApi()
abstract class ReelsFlutterNavigationApi {
  /// Called when user swipes left
  void onSwipeLeft();
  
  /// Called when user swipes right
  void onSwipeRight();
}
```

**Use Cases:**
- Navigate to user profile (swipe left)
- Return to main feed (swipe right)
- Open product details
- Custom navigation flows

## Data Models

### AnalyticsEvent
```dart
class AnalyticsEvent {
  const AnalyticsEvent({
    required this.eventName,
    required this.eventProperties,
  });
  
  final String eventName;
  final Map<String?, String?> eventProperties;
}
```

**Example:**
```dart
AnalyticsEvent(
  eventName: 'video_view',
  eventProperties: {
    'video_id': 'video123',
    'duration': '60',
    'source': 'feed',
  },
)
```

### ShareData
```dart
class ShareData {
  const ShareData({
    required this.videoId,
    required this.videoUrl,
    required this.title,
    required this.description,
    this.thumbnailUrl,
  });
  
  final String videoId;
  final String videoUrl;
  final String title;
  final String description;
  final String? thumbnailUrl;
}
```

**Example:**
```dart
ShareData(
  videoId: 'video123',
  videoUrl: 'https://example.com/video/123',
  title: 'Amazing Video',
  description: 'Check out this amazing video!',
  thumbnailUrl: 'https://example.com/thumb/123.jpg',
)
```

### ScreenStateData
```dart
class ScreenStateData {
  const ScreenStateData({
    required this.screenName,
    required this.state,
    this.timestamp,
  });
  
  final String screenName;
  final String state;
  final int? timestamp;
}
```

**States:** `appeared`, `disappeared`, `focused`, `unfocused`

### VideoStateData
```dart
class VideoStateData {
  const VideoStateData({
    required this.videoId,
    required this.state,
    this.position,
    this.duration,
    this.timestamp,
  });
  
  final String videoId;
  final String state;
  final int? position;    // in seconds
  final int? duration;    // in seconds
  final int? timestamp;
}
```

**States:** `playing`, `paused`, `stopped`, `buffering`, `completed`

## Usage Examples

### Flutter Side

#### Sending Analytics Events
```dart
import 'package:reels_flutter/core/pigeon_generated.dart';

final analyticsApi = ReelsFlutterAnalyticsApi();

// Track video view
analyticsApi.trackEvent(
  AnalyticsEvent(
    eventName: 'video_view',
    eventProperties: {
      'video_id': 'video123',
      'position': '5',
      'screen': 'reels_feed',
    },
  ),
);
```

#### Handling Button Events
```dart
final buttonEventsApi = ReelsFlutterButtonEventsApi();

// Before like (optimistic update)
buttonEventsApi.onBeforeLikeButtonClick('video123');

// After like (confirmed)
buttonEventsApi.onAfterLikeButtonClick('video123', true, 1234);

// Share button
buttonEventsApi.onShareButtonClick(
  ShareData(
    videoId: 'video123',
    videoUrl: 'https://example.com/video/123',
    title: 'Amazing Video',
    description: 'Check this out!',
  ),
);
```

#### Tracking State Changes
```dart
final stateApi = ReelsFlutterStateApi();

// Screen lifecycle
stateApi.onScreenStateChanged(
  ScreenStateData(
    screenName: 'reels_feed',
    state: 'focused',
    timestamp: DateTime.now().millisecondsSinceEpoch,
  ),
);

// Video playback
stateApi.onVideoStateChanged(
  VideoStateData(
    videoId: 'video123',
    state: 'playing',
    position: 5,
    duration: 60,
    timestamp: DateTime.now().millisecondsSinceEpoch,
  ),
);
```

#### Navigation Gestures
```dart
final navigationApi = ReelsFlutterNavigationApi();

// User swiped left to view profile
navigationApi.onSwipeLeft();

// User swiped right to go back
navigationApi.onSwipeRight();
```

### Android Integration (Kotlin)

#### Setting Up Listeners

```kotlin
import com.eishon.reels_android.ReelsFlutterAnalyticsApi
import com.eishon.reels_android.ReelsFlutterButtonEventsApi
import com.eishon.reels_android.ReelsFlutterStateApi
import com.eishon.reels_android.ReelsFlutterNavigationApi
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Analytics listener
        ReelsFlutterAnalyticsApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            object : ReelsFlutterAnalyticsApi {
                override fun trackEvent(event: AnalyticsEvent) {
                    // Send to your analytics platform
                    Firebase.analytics.logEvent(
                        event.eventName,
                        bundleOf(*event.eventProperties.map { 
                            it.key to it.value 
                        }.toTypedArray())
                    )
                }
            }
        )
        
        // Button events listener
        ReelsFlutterButtonEventsApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            object : ReelsFlutterButtonEventsApi {
                override fun onBeforeLikeButtonClick(videoId: String) {
                    Log.d("Reels", "About to like: $videoId")
                }
                
                override fun onAfterLikeButtonClick(
                    videoId: String,
                    isLiked: Boolean,
                    likeCount: Long
                ) {
                    Log.d("Reels", "Liked: $videoId, count: $likeCount")
                    // Update local cache or UI
                }
                
                override fun onShareButtonClick(shareData: ShareData) {
                    // Open native share sheet
                    val intent = Intent.createChooser(
                        Intent(Intent.ACTION_SEND).apply {
                            type = "text/plain"
                            putExtra(Intent.EXTRA_TEXT, shareData.videoUrl)
                            putExtra(Intent.EXTRA_TITLE, shareData.title)
                        },
                        "Share via"
                    )
                    startActivity(intent)
                }
            }
        )
        
        // State events listener
        ReelsFlutterStateApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            object : ReelsFlutterStateApi {
                override fun onScreenStateChanged(state: ScreenStateData) {
                    Log.d("Reels", "Screen ${state.screenName}: ${state.state}")
                }
                
                override fun onVideoStateChanged(state: VideoStateData) {
                    Log.d("Reels", "Video ${state.videoId}: ${state.state}")
                    // Track video completion for analytics
                    if (state.state == "completed") {
                        trackVideoCompletion(state.videoId)
                    }
                }
            }
        )
        
        // Navigation listener
        ReelsFlutterNavigationApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            object : ReelsFlutterNavigationApi {
                override fun onSwipeLeft() {
                    // Navigate to profile screen
                    startActivity(Intent(this@MainActivity, ProfileActivity::class.java))
                }
                
                override fun onSwipeRight() {
                    // Go back to main feed
                    finish()
                }
            }
        )
    }
}
```

#### Calling Flutter from Native

```kotlin
import com.eishon.reels_android.ReelsFlutterTokenApi

class TokenManager(private val flutterEngine: FlutterEngine) {
    private val tokenApi = ReelsFlutterTokenApi(flutterEngine.dartExecutor.binaryMessenger)
    
    fun getAccessToken(): String? {
        return tokenApi.getAccessToken()
    }
    
    // Call when user logs in
    fun onUserLogin() {
        val token = tokenApi.getAccessToken()
        if (token != null) {
            // Use token for API calls
            apiClient.setAuthToken(token)
        }
    }
}
```

### iOS Integration (Swift)

#### Setting Up Listeners

```swift
import Flutter
import ReelsIOS

class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        let binaryMessenger = controller.binaryMessenger
        
        // Analytics listener
        ReelsFlutterAnalyticsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: AnalyticsHandler()
        )
        
        // Button events listener
        ReelsFlutterButtonEventsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: ButtonEventsHandler()
        )
        
        // State events listener
        ReelsFlutterStateApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: StateEventsHandler()
        )
        
        // Navigation listener
        ReelsFlutterNavigationApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: NavigationHandler()
        )
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class AnalyticsHandler: ReelsFlutterAnalyticsApi {
    func trackEvent(event: AnalyticsEvent) throws {
        // Send to your analytics platform
        Analytics.logEvent(event.eventName, parameters: event.eventProperties)
    }
}

class ButtonEventsHandler: ReelsFlutterButtonEventsApi {
    func onBeforeLikeButtonClick(videoId: String) throws {
        print("About to like: \(videoId)")
    }
    
    func onAfterLikeButtonClick(
        videoId: String,
        isLiked: Bool,
        likeCount: Int64
    ) throws {
        print("Liked: \(videoId), count: \(likeCount)")
        // Update local cache or UI
    }
    
    func onShareButtonClick(shareData: ShareData) throws {
        // Open native share sheet
        let activityVC = UIActivityViewController(
            activityItems: [shareData.videoUrl, shareData.title],
            applicationActivities: nil
        )
        UIApplication.shared.windows.first?.rootViewController?.present(
            activityVC,
            animated: true
        )
    }
}

class StateEventsHandler: ReelsFlutterStateApi {
    func onScreenStateChanged(state: ScreenStateData) throws {
        print("Screen \(state.screenName): \(state.state)")
    }
    
    func onVideoStateChanged(state: VideoStateData) throws {
        print("Video \(state.videoId): \(state.state)")
        // Track video completion for analytics
        if state.state == "completed" {
            trackVideoCompletion(videoId: state.videoId)
        }
    }
}

class NavigationHandler: ReelsFlutterNavigationApi {
    func onSwipeLeft() throws {
        // Navigate to profile screen
        let profileVC = ProfileViewController()
        UIApplication.shared.windows.first?.rootViewController?.present(
            profileVC,
            animated: true
        )
    }
    
    func onSwipeRight() throws {
        // Go back to main feed
        UIApplication.shared.windows.first?.rootViewController?.dismiss(
            animated: true
        )
    }
}
```

#### Calling Flutter from Native

```swift
import Flutter
import ReelsIOS

class TokenManager {
    let tokenApi: ReelsFlutterTokenApi
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        tokenApi = ReelsFlutterTokenApi(binaryMessenger: binaryMessenger)
    }
    
    func getAccessToken() -> String? {
        return try? tokenApi.getAccessToken()
    }
    
    // Call when user logs in
    func onUserLogin() {
        if let token = try? tokenApi.getAccessToken() {
            // Use token for API calls
            APIClient.shared.setAuthToken(token)
        }
    }
}
```

## Best Practices

### 1. Code Generation
- Always regenerate code after modifying `messages.dart`
- Run `dart format` on generated files for consistency
- Commit generated files to version control

### 2. API Design
- Keep interfaces simple and focused
- Use clear, descriptive names for methods and parameters
- Document all public APIs with comments
- Use nullable types (`String?`) when values are optional

### 3. Error Handling
- Handle potential exceptions in native implementations
- Provide meaningful error messages
- Use try-catch blocks when calling Pigeon APIs

### 4. Testing
- Test all Pigeon APIs on both platforms
- Verify serialization/deserialization of complex types
- Test edge cases (null values, empty strings, etc.)

### 5. Version Compatibility
- Test changes on both Android and iOS before merging
- Keep Pigeon package version up to date
- Document any breaking changes in API

## Troubleshooting

### Code Not Generating?

**Problem:** `dart run pigeon` doesn't produce output files.

**Solutions:**
1. Ensure Pigeon is in `pubspec.yaml` dev_dependencies:
   ```yaml
   dev_dependencies:
     pigeon: ^13.0.0
   ```
2. Run `flutter pub get` to install dependencies
3. Verify the input path is correct: `pigeons/messages.dart`
4. Check for syntax errors in `messages.dart`

### Compilation Errors?

**Problem:** Generated code doesn't compile.

**Solutions:**
1. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   dart run pigeon --input pigeons/messages.dart
   ```
2. Check Pigeon version compatibility with Flutter SDK
3. Verify import statements in generated code
4. Ensure native SDK dependencies are up to date

### Runtime Errors?

**Problem:** App crashes when calling Pigeon APIs.

**Solutions:**
1. Ensure native implementations are registered before use:
   ```kotlin
   // Android
   ReelsFlutterAnalyticsApi.setUp(binaryMessenger, implementation)
   ```
   ```swift
   // iOS
   ReelsFlutterAnalyticsApiSetup.setUp(binaryMessenger: messenger, api: implementation)
   ```
2. Check that all required methods are implemented
3. Verify data types match between Flutter and native code
4. Look for null safety issues

### "Method not found" Error?

**Problem:** Native platform can't find Pigeon-generated methods.

**Solutions:**
1. Regenerate Pigeon code:
   ```bash
   cd reels_flutter
   dart run pigeon --input pigeons/messages.dart
   ```
2. Rebuild native SDKs:
   ```bash
   # Android
   cd reels_android
   ./gradlew build
   
   # iOS
   cd reels_ios
   pod lib lint
   ```
3. Clean build artifacts and rebuild

## CI/CD Integration

The repository includes automatic Pigeon code generation via GitHub Actions:

**Workflow:** `.github/workflows/auto-format-pigeon.yml`

**Features:**
- Auto-generates code when `pigeons/messages.dart` changes
- Formats generated files with `dart format`
- Commits changes back to the branch
- Prevents infinite loops with `[skip ci]` in commit message

**Manual Trigger:**
```bash
# Via GitHub CLI
gh workflow run auto-format-pigeon.yml

# Or use GitHub web interface: Actions → Auto-Format Pigeon Code → Run workflow
```

## Additional Resources

- [Pigeon Official Documentation](https://pub.dev/packages/pigeon)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Add-to-App Documentation](https://docs.flutter.dev/add-to-app)
- [Repository Main README](../../README.md)
- [Native Integration Guide](../../NATIVE_INTEGRATION.md) (if available)

## Contributing

When contributing to Pigeon interfaces:

1. **Discuss First:** Open an issue to discuss API changes
2. **Update Documentation:** Update this README with new APIs
3. **Generate Code:** Run pigeon and commit generated files
4. **Test Both Platforms:** Verify on Android and iOS
5. **Update Examples:** Add usage examples for new APIs
6. **Follow Conventions:** Match existing naming and style

## Questions?

- **Issues:** [GitHub Issues](https://github.com/eishon/flutter-reels/issues)
- **Discussions:** [GitHub Discussions](https://github.com/eishon/flutter-reels/discussions)

---

**Last Updated:** October 2025
**Pigeon Version:** 13.0+
**Flutter Version:** 3.35.6+
