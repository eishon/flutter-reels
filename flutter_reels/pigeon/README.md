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

## Files

- `messages.dart` - Source interface definitions
- Generated files (automatically created, not in git):
  - `../lib/core/platform/messages.g.dart` - Flutter/Dart code
  - `../../android/src/main/kotlin/com/example/flutter_reels/Messages.g.kt` - Android/Kotlin code
  - `../../ios/Classes/Messages.g.swift` - iOS/Swift code

## How to Generate Code

After modifying `messages.dart`, regenerate the platform code:

```bash
cd flutter_reels
dart run pigeon --input pigeon/messages.dart
```

The generated code will be created in the appropriate platform directories.

## API Overview

### 1. HostApi (Native → Flutter)
Methods that native platforms can call on Flutter:

#### Token Management
- `updateAccessToken(String token)` - Update authentication token
- `clearAccessToken()` - Clear stored token

#### Video Control
- `pauseVideos()` - Pause all video playback
- `resumeVideos()` - Resume video playback

### 2. FlutterReelsAnalyticsApi (Flutter → Native)
Send analytics events to native platform:

- `trackEvent(AnalyticsEvent event)` - Generic analytics tracking

**Event Types:**
- `appear` - Video appeared on screen
- `click` - User interaction (like, share, etc.)
- `page_view` - Screen navigation

### 3. FlutterReelsTokenApi (Native → Flutter)
Provide access tokens asynchronously:

- `getAccessToken(TokenCallback callback)` - Request token with callback

**Callback Methods:**
- `onTokenReceived(String token)` - Success callback
- `onTokenError(String error)` - Error callback

### 4. FlutterReelsButtonEventsApi (Flutter → Native)
Button interaction events:

#### Like Button
- `onBeforeLikeButtonClick(String videoId, bool currentLikeState)` - Before like action
- `onAfterLikeButtonClick(String videoId, bool newLikeState)` - After like action

#### Share Button
- `onBeforeShareButtonClick(String videoId, int currentShareCount)` - Before share
- `onAfterShareButtonClick(ShareData shareData)` - After share with data

### 5. FlutterReelsStateApi (Flutter → Native)
Screen and video state changes:

#### Screen States
- `onScreenStateChanged(ScreenStateData state)` - Screen lifecycle events

**Screen States:** `focused`, `unfocused`, `appeared`, `disappeared`

#### Video States
- `onVideoStateChanged(VideoStateData state)` - Video playback state

**Video States:** `playing`, `paused`, `stopped`, `buffering`, `completed`

### 6. FlutterReelsNavigationApi (Flutter → Native)
Gesture-based navigation events:

- `onSwipeLeft()` - User swiped left (e.g., profile view)
- `onSwipeRight()` - User swiped right (e.g., back to feed)

## Data Classes

### AnalyticsEvent
```dart
class AnalyticsEvent {
  final String type;              // Event type: appear, click, page_view
  final Map<String?, Object?> data; // Event metadata
}
```

### ShareData
```dart
class ShareData {
  final String url;               // Content URL to share
  final String title;             // Share title
  final String? description;      // Optional description
  final String? thumbnailUrl;     // Optional thumbnail image
}
```

### ScreenStateData
```dart
class ScreenStateData {
  final String state;             // focused, unfocused, appeared, disappeared
  final String screenName;        // Screen identifier
  final Map<String?, Object?>? metadata; // Optional context data
}
```

### VideoStateData
```dart
class VideoStateData {
  final String videoId;           // Video identifier
  final String state;             // playing, paused, stopped, buffering, completed
  final double? position;         // Current playback position (seconds)
  final double? duration;         // Total video duration (seconds)
}
```
## Usage Examples

### Flutter Side

#### Sending Analytics Events
```dart
import 'package:flutter_reels/core/di/injection_container.dart';
import 'package:flutter_reels/core/services/analytics_service.dart';

final analyticsService = sl<AnalyticsService>();

// Track video appearance
analyticsService.trackVideoAppear(
  videoId: 'video123',
  position: 5,
  screenName: 'reels_screen',
);

// Track button click
analyticsService.trackButtonClick(
  element: 'like_button',
  videoId: 'video123',
  metadata: {'liked': true},
);
```

#### Handling Button Events
```dart
import 'package:flutter_reels/core/services/button_events_service.dart';

final buttonEventsService = sl<ButtonEventsService>();

// Notify before/after like
buttonEventsService.notifyBeforeLikeClick(
  videoId: 'video123',
  currentLikeState: false,
);

buttonEventsService.notifyAfterLikeClick(
  videoId: 'video123',
  newLikeState: true,
);
```

#### Tracking Screen States
```dart
import 'package:flutter_reels/core/services/state_events_service.dart';

final stateEventsService = sl<StateEventsService>();

// Screen lifecycle
stateEventsService.notifyScreenFocused(screenName: 'reels_screen');
stateEventsService.notifyScreenUnfocused(screenName: 'reels_screen');

// Video playback
stateEventsService.notifyVideoPlaying(
  videoId: 'video123',
  position: 5.0,
  duration: 60.0,
);
```

#### Navigation Gestures
```dart
import 'package:flutter_reels/core/services/navigation_events_service.dart';

final navigationService = sl<NavigationEventsService>();

// User swiped left
navigationService.notifySwipeLeft(
  fromVideoId: 'video123',
  metadata: {'action': 'profile_view'},
);
```

### Android Integration (Kotlin)

#### Setting Up Listeners

```kotlin
import com.example.flutter_reels.FlutterReelsAnalyticsApi
import com.example.flutter_reels.FlutterReelsButtonEventsApi
import com.example.flutter_reels.FlutterReelsStateApi
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Analytics listener
        FlutterReelsAnalyticsApi.setUp(flutterEngine.dartExecutor.binaryMessenger) { event ->
            // Send to your analytics platform
            Analytics.track(event.type, event.data.mapValues { it.value.toString() })
        }
        
        // Button events listener
        FlutterReelsButtonEventsApi.setUp(flutterEngine.dartExecutor.binaryMessenger, object : FlutterReelsButtonEventsApi {
            override fun onBeforeLikeButtonClick(videoId: String, currentLikeState: Boolean) {
                Log.d("FlutterReels", "Before like: $videoId, liked: $currentLikeState")
            }
            
            override fun onAfterLikeButtonClick(videoId: String, newLikeState: Boolean) {
                Log.d("FlutterReels", "After like: $videoId, liked: $newLikeState")
            }
            
            override fun onBeforeShareButtonClick(videoId: String, currentShareCount: Long) {
                Log.d("FlutterReels", "Before share: $videoId")
            }
            
            override fun onAfterShareButtonClick(shareData: Messages.ShareData) {
                // Open native share sheet
                shareContent(shareData.url, shareData.title)
            }
        })
        
        // State events listener
        FlutterReelsStateApi.setUp(flutterEngine.dartExecutor.binaryMessenger, object : FlutterReelsStateApi {
            override fun onScreenStateChanged(state: Messages.ScreenStateData) {
                when (state.state) {
                    "focused" -> Log.d("FlutterReels", "Screen focused: ${state.screenName}")
                    "unfocused" -> Log.d("FlutterReels", "Screen unfocused: ${state.screenName}")
                }
            }
            
            override fun onVideoStateChanged(state: Messages.VideoStateData) {
                Log.d("FlutterReels", "Video ${state.videoId} is ${state.state}")
            }
        })
        
        // Navigation listener
        FlutterReelsNavigationApi.setUp(flutterEngine.dartExecutor.binaryMessenger, object : FlutterReelsNavigationApi {
            override fun onSwipeLeft() {
                // Navigate to profile or details
                startActivity(Intent(this@MainActivity, ProfileActivity::class.java))
            }
            
            override fun onSwipeRight() {
                // Go back to main feed
                finish()
            }
        })
    }
}
```

#### Calling Flutter from Native

```kotlin
import com.example.flutter_reels.FlutterReelsHostApi

class TokenManager(private val flutterEngine: FlutterEngine) {
    private val hostApi = FlutterReelsHostApi(flutterEngine.dartExecutor.binaryMessenger)
    
    fun updateToken(newToken: String) {
        hostApi.updateAccessToken(newToken) { }
    }
    
    fun clearToken() {
        hostApi.clearAccessToken { }
    }
    
    fun pauseVideos() {
        hostApi.pauseVideos { }
    }
    
    fun resumeVideos() {
        hostApi.resumeVideos { }
    }
}
```

### iOS Integration (Swift)

#### Setting Up Listeners

```swift
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let binaryMessenger = controller.binaryMessenger
        
        // Analytics listener
        FlutterReelsAnalyticsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: AnalyticsHandler()
        )
        
        // Button events listener
        FlutterReelsButtonEventsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: ButtonEventsHandler()
        )
        
        // State events listener
        FlutterReelsStateApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: StateEventsHandler()
        )
        
        // Navigation listener
        FlutterReelsNavigationApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: NavigationHandler()
        )
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class AnalyticsHandler: FlutterReelsAnalyticsApi {
    func trackEvent(event: AnalyticsEvent, completion: @escaping (Result<Void, Error>) -> Void) {
        // Send to your analytics platform
        Analytics.track(event.type, properties: event.data)
        completion(.success(()))
    }
}

class ButtonEventsHandler: FlutterReelsButtonEventsApi {
    func onBeforeLikeButtonClick(videoId: String, currentLikeState: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Before like: \(videoId), liked: \(currentLikeState)")
        completion(.success(()))
    }
    
    func onAfterLikeButtonClick(videoId: String, newLikeState: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        print("After like: \(videoId), liked: \(newLikeState)")
        completion(.success(()))
    }
    
    func onBeforeShareButtonClick(videoId: String, currentShareCount: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Before share: \(videoId)")
        completion(.success(()))
    }
    
    func onAfterShareButtonClick(shareData: ShareData, completion: @escaping (Result<Void, Error>) -> Void) {
        // Open native share sheet
        shareContent(url: shareData.url, title: shareData.title)
        completion(.success(()))
    }
}

class StateEventsHandler: FlutterReelsStateApi {
    func onScreenStateChanged(state: ScreenStateData, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Screen \(state.screenName) is \(state.state)")
        completion(.success(()))
    }
    
    func onVideoStateChanged(state: VideoStateData, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Video \(state.videoId) is \(state.state)")
        completion(.success(()))
    }
}

class NavigationHandler: FlutterReelsNavigationApi {
    func onSwipeLeft(completion: @escaping (Result<Void, Error>) -> Void) {
        // Navigate to profile
        completion(.success(()))
    }
    
    func onSwipeRight(completion: @escaping (Result<Void, Error>) -> Void) {
        // Go back
        completion(.success(()))
    }
}
```

#### Calling Flutter from Native

```swift
class TokenManager {
    let hostApi: FlutterReelsHostApi
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        hostApi = FlutterReelsHostApi(binaryMessenger: binaryMessenger)
    }
    
    func updateToken(newToken: String) {
        hostApi.updateAccessToken(token: newToken) { result in
            switch result {
            case .success:
                print("Token updated")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func clearToken() {
        hostApi.clearAccessToken { _ in }
    }
    
    func pauseVideos() {
        hostApi.pauseVideos { _ in }
    }
    
    func resumeVideos() {
        hostApi.resumeVideos { _ in }
    }
}
```

## Best Practices

1. **Regenerate after changes** - Always run pigeon after modifying interfaces
2. **Document changes** - Add comments to explain new methods
3. **Version compatibility** - Test on both platforms after changes
4. **Error handling** - Handle PlatformExceptions in Flutter
5. **Null safety** - Use nullable types where appropriate

## Troubleshooting

### Code not generating?
- Check that pigeon is in dev_dependencies
- Run `flutter pub get` first
- Verify the input path is correct

### Compilation errors?
- Clean and rebuild: `flutter clean && flutter pub get`
- Check Pigeon version compatibility
- Verify import statements in generated code

### Runtime errors?
- Ensure native code implements the APIs
- Check that setup is called before use
- Verify data types match between platforms

## Learn More

- [Pigeon Documentation](https://pub.dev/packages/pigeon)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
