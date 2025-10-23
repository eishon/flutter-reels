# Flutter Reels - Add-to-App Integration Guide

**Simple integration for native Android and iOS apps** - No Flutter or Pigeon knowledge required! 🚀

---

## Overview

Flutter Reels provides native SDKs (`reels_android` and `reels_ios`) that embed the Flutter module for you. You work with clean, familiar native APIs while we handle all the Flutter complexity behind the scenes.

### What You Get

- ✅ **Clean Native APIs** - Kotlin for Android, Swift for iOS
- ✅ **Zero Flutter Knowledge Required** - We handle all Flutter integration
- ✅ **Zero Pigeon Knowledge Required** - Platform communication is hidden
- ✅ **Familiar Patterns** - Standard Android/iOS development practices
- ✅ **Type-Safe** - Full compile-time safety with native types

### Architecture

```
Your Native App (Kotlin/Swift)
        ↓
reels_android / reels_ios (Native SDK)
    [Clean API - This is what you use!]
        ↓
    [Flutter Engine + Pigeon - Hidden from you]
        ↓
reels_flutter Module (Reels UI)
```

**You only interact with the top layer** - everything else is handled automatically!

---

## 🤖 Android Integration

### Prerequisites

- Android SDK 21+ (Android 5.0+)
- Gradle 8.0+
- Kotlin 1.9.0+

### Step 1: Add the Flutter Module

In your **`settings.gradle`**:

```gradle
// Include the Flutter module for Add-to-App
setBinding(new Binding([gradle: this]))
evaluate(new File('../path/to/flutter-reels/reels_flutter/.android/include_flutter.groovy'))
```

> **Note**: Adjust the path based on where you've placed the `flutter-reels` repository relative to your project.

### Step 2: Add the Native SDK

In your **`settings.gradle`** (add this after Step 1):

```gradle
// Include the reels_android native SDK
include ':reels_android'
project(':reels_android').projectDir = file('../path/to/flutter-reels/reels_android')
```

### Step 3: Add Dependencies

In your app's **`build.gradle`**:

```gradle
dependencies {
    // Add the reels_android SDK
    implementation project(':reels_android')
    
    // Flutter module is automatically included by include_flutter.groovy
    
    // Your other dependencies...
}
```

### Step 4: Use the SDK in Your Code

**Kotlin Example:**

```kotlin
import com.eishon.reels_android.*

class MainActivity : AppCompatActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 1. Initialize the SDK
        ReelsAndroidSDK.initialize(
            context = this,
            config = ReelsConfig(
                autoPlay = true,
                showControls = true,
                loopVideos = true
            )
        )
        
        // 2. Set up event listener (optional)
        ReelsAndroidSDK.setListener(object : ReelsListener {
            override fun onReelViewed(videoId: String) {
                Log.d(TAG, "User viewed video: $videoId")
            }
            
            override fun onReelLiked(videoId: String, isLiked: Boolean) {
                Log.d(TAG, "Video $videoId liked: $isLiked")
            }
            
            override fun onReelShared(videoId: String) {
                Log.d(TAG, "User shared video: $videoId")
            }
        })
        
        // 3. Show reels
        val videos = listOf(
            VideoInfo(
                id = "1",
                url = "https://example.com/video1.mp4",
                title = "Amazing Video",
                description = "Check this out!",
                thumbnailUrl = "https://example.com/thumb1.jpg"
            ),
            VideoInfo(
                id = "2",
                url = "https://example.com/video2.mp4",
                title = "Another Great Video"
            )
        )
        
        ReelsAndroidSDK.showReels(videos)
    }
}
```

### Build Configuration

Make sure your **`settings.gradle`** uses the correct repository mode:

```gradle
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)  // Important!
    repositories {
        google()
        mavenCentral()
    }
}
```

> **Why PREFER_PROJECT?** This allows the Flutter Gradle Plugin to add its own Maven repositories for Flutter engine artifacts.

### That's It for Android! 🎉

No Flutter commands to run, no AAR files to build. Just add the dependencies and start using the SDK!

---

## 🍎 iOS Integration

### Prerequisites

- iOS 13.0+
- Xcode 14.0+
- CocoaPods 1.11+

### Step 1: Update Your Podfile

```ruby
platform :ios, '13.0'

# Path to the Flutter module
flutter_application_path = '../path/to/flutter-reels/reels_flutter'

# Load Flutter's podhelper
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'YourApp' do
  use_frameworks!
  
  # Install Flutter pods (automatically handles Flutter engine + module)
  install_all_flutter_pods(flutter_application_path)
  
  # Install the reels_ios native SDK
  pod 'ReelsIOS', :path => '../path/to/flutter-reels/reels_ios'
  
  # Your other dependencies...
end
```

> **Note**: Adjust paths based on where you've placed the `flutter-reels` repository.

### Step 2: Install Pods

```bash
cd ios
pod install
```

### Step 3: Open Workspace (Not .xcodeproj!)

```bash
open YourApp.xcworkspace
```

### Step 4: Use the SDK in Your Code

**Swift Example:**

```swift
import ReelsIOS

class AppDelegate: UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 1. Initialize the SDK
        let config = ReelsConfig(
            autoPlay: true,
            showControls: true,
            loopVideos: true
        )
        ReelsIOSSDK.shared.initialize(config: config)
        
        // 2. Set up delegate (optional)
        ReelsIOSSDK.shared.delegate = self
        
        return true
    }
}

// Implement the delegate
extension AppDelegate: ReelsDelegate {
    
    func onReelViewed(videoId: String) {
        print("User viewed video: \(videoId)")
    }
    
    func onReelLiked(videoId: String, isLiked: Bool) {
        print("Video \(videoId) liked: \(isLiked)")
    }
    
    func onReelShared(videoId: String) {
        print("User shared video: \(videoId)")
    }
}

// Show reels from any view controller
class ViewController: UIViewController {
    
    func showReels() {
        let videos = [
            VideoInfo(
                id: "1",
                url: "https://example.com/video1.mp4",
                title: "Amazing Video",
                description: "Check this out!",
                thumbnailUrl: "https://example.com/thumb1.jpg"
            ),
            VideoInfo(
                id: "2",
                url: "https://example.com/video2.mp4",
                title: "Another Great Video"
            )
        ]
        
        try? ReelsIOSSDK.shared.showReels(videos: videos)
    }
}
```

### That's It for iOS! 🎉

CocoaPods handles all the Flutter integration automatically. No Flutter commands needed!

---

## 🔧 Configuration Options

### ReelsConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `autoPlay` | Boolean | `true` | Auto-play videos when visible |
| `showControls` | Boolean | `true` | Show video controls |
| `loopVideos` | Boolean | `true` | Loop videos when they end |

### VideoInfo

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | String | ✅ Yes | Unique video identifier |
| `url` | String | ✅ Yes | Video URL (HTTP/HTTPS) |
| `title` | String | ❌ No | Video title |
| `description` | String | ❌ No | Video description |
| `thumbnailUrl` | String | ❌ No | Thumbnail image URL |
| `userInfo` | UserInfo | ❌ No | Creator information |
| `products` | List | ❌ No | Tagged products |

---

## 📱 Example Apps

Working examples are available in the repository:

- **Android**: `example/android/` - Complete Android app demonstrating integration
- **iOS**: `example/ios/` - Complete iOS app demonstrating integration

**To run the Android example:**

```bash
cd example/android
./gradlew :app:assembleDebug
./gradlew :app:installDebug
```

**To run the iOS example:**

```bash
cd example/ios
pod install
open Runner.xcworkspace
# Build and run from Xcode
```

---

## 🐛 Troubleshooting

### Android Issues

**Problem**: "Could not find Flutter engine artifacts"

**Solution**: Make sure you're using `PREFER_PROJECT` repository mode in `settings.gradle`:

```gradle
repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
```

**Problem**: Build fails with Kotlin version mismatch

**Solution**: Make sure you're using Kotlin 1.9.0 or higher in your project's `build.gradle`:

```gradle
buildscript {
    ext.kotlin_version = '2.1.0'
}
```

### iOS Issues

**Problem**: "Framework not found Flutter"

**Solution**: Make sure you:
1. Opened the `.xcworkspace` file (not `.xcodeproj`)
2. Ran `pod install` successfully
3. Have the correct path to `flutter_application_path` in your Podfile

**Problem**: Pod install fails

**Solution**: Try cleaning CocoaPods cache:

```bash
pod deintegrate
pod cache clean --all
pod install
```

---

## ❓ FAQ

### Do I need to install Flutter?

**For integration**: No! The native SDKs include everything you need.

**For contribution**: Yes, if you want to modify the Flutter module or contribute to the project. See [SETUP.md](./SETUP.md).

### Do I need to learn Pigeon?

**For basic usage**: No! The native SDKs provide clean, type-safe APIs that hide all Pigeon complexity.

**For advanced integration**: Understanding the Pigeon API can help you:
- Implement custom analytics tracking
- Handle button events (like/share)
- Respond to video state changes
- Provide authentication tokens to Flutter
- Handle navigation gestures

See the **Advanced: Pigeon API Integration** section below for details.

### Can I customize the UI?

Currently, the UI is provided by the Flutter module. Customization options are planned for future releases. For now, you can fork the repository and modify `reels_flutter/lib/` to your needs.

### How do I update to a new version?

1. Pull the latest changes from the repository
2. **Android**: Sync Gradle
3. **iOS**: Run `pod install` again

### Does this work with SwiftUI?

Yes! You can wrap the reels view in a `UIViewControllerRepresentable` for SwiftUI integration.

---

## 🔌 Advanced: Pigeon API Integration

This section is for advanced users who want to integrate directly with the Flutter module using Pigeon APIs for custom analytics, event handling, and authentication.

### Understanding Pigeon Communication

Pigeon generates type-safe platform channels between Flutter and native code. There are two types of APIs:

1. **@HostApi** - Native implements these APIs; Flutter calls them
   - Direction: Flutter → Native
   - Native provides the implementation
   - Example: Getting authentication tokens from native

2. **@FlutterApi** - Flutter implements these APIs; Native calls them
   - Direction: Native ← Flutter
   - Flutter calls native to notify of events
   - Example: Sending analytics events, button clicks

### Available Pigeon APIs

All APIs are defined in `reels_flutter/pigeons/messages.dart` and auto-generated to:
- **Kotlin**: `reels_android/src/main/java/com/eishon/reels_android/PigeonGenerated.kt`
- **Swift**: `reels_ios/Sources/ReelsIOS/PigeonGenerated.swift`

#### 1. ReelsFlutterTokenApi (@HostApi)
**Native implements, Flutter calls**

Provides authentication tokens to Flutter when needed.

```kotlin
// Android - Implement the interface
class MyTokenProvider : ReelsFlutterTokenApi {
    override fun getAccessToken(): String? {
        // Return current valid token or null if not authenticated
        return AuthManager.getCurrentToken()
    }
}

// Register with Flutter
ReelsFlutterTokenApi.setUp(flutterEngine.dartExecutor.binaryMessenger, MyTokenProvider())
```

```swift
// iOS - Implement the protocol
class MyTokenProvider: ReelsFlutterTokenApi {
    func getAccessToken() throws -> String? {
        // Return current valid token or null if not authenticated
        return AuthManager.shared.currentToken
    }
}

// Register with Flutter
ReelsFlutterTokenApiSetup.setUp(
    binaryMessenger: flutterEngine.binaryMessenger,
    api: MyTokenProvider()
)
```

#### 2. ReelsFlutterAnalyticsApi (@FlutterApi)
**Flutter calls native to send analytics events**

Track user interactions and video views in your analytics platform.

```kotlin
// Android - Create instance and receive events
val analyticsApi = ReelsFlutterAnalyticsApi(flutterEngine.dartExecutor.binaryMessenger)

// Flutter will call this when tracking events
// You need to register this in your Flutter integration
// The Flutter side sends events via this channel automatically
```

```swift
// iOS - Create instance to receive events
let analyticsApi = ReelsFlutterAnalyticsApi(binaryMessenger: flutterEngine.binaryMessenger)

// Flutter will send events through this channel
// Events are received automatically when Flutter tracks them
```

**AnalyticsEvent Data Model:**
```kotlin
// Kotlin
data class AnalyticsEvent(
    val eventName: String,           // e.g., "video_viewed", "button_clicked"
    val eventProperties: Map<String?, String?>  // Event metadata
)
```

```swift
// Swift
struct AnalyticsEvent {
    var eventName: String           // e.g., "video_viewed", "button_clicked"
    var eventProperties: [String?: String?]  // Event metadata
}
```

#### 3. ReelsFlutterButtonEventsApi (@FlutterApi)
**Flutter calls native when buttons are clicked**

Handle like and share button interactions.

```kotlin
// Android - Listen for button events
// These methods are called by Flutter automatically when buttons are clicked
// Example usage in your native SDK wrapper:
class ReelsButtonHandler {
    private val buttonEventsApi = ReelsFlutterButtonEventsApi(binaryMessenger)
    
    // Note: Flutter calls the native side, not the other way around
    // You would typically handle these in your SDK implementation
}
```

```swift
// iOS - Listen for button events
class ReelsButtonHandler {
    private let buttonEventsApi: ReelsFlutterButtonEventsApi
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.buttonEventsApi = ReelsFlutterButtonEventsApi(binaryMessenger: binaryMessenger)
    }
}
```

**Available Methods:**
- `onBeforeLikeButtonClick(videoId: String)` - Called before like action (for optimistic UI)
- `onAfterLikeButtonClick(videoId: String, isLiked: Boolean, likeCount: Long)` - Called after like completes
- `onShareButtonClick(shareData: ShareData)` - Called when share button is clicked

**ShareData Model:**
```kotlin
// Kotlin
data class ShareData(
    val videoId: String,
    val videoUrl: String,
    val title: String,
    val description: String,
    val thumbnailUrl: String? = null
)
```

```swift
// Swift
struct ShareData {
    var videoId: String
    var videoUrl: String
    var title: String
    var description: String
    var thumbnailUrl: String? = nil
}
```

#### 4. ReelsFlutterStateApi (@FlutterApi)
**Flutter calls native to notify of state changes**

Track screen and video playback states.

**Available Methods:**
- `onScreenStateChanged(state: ScreenStateData)` - Screen lifecycle events
- `onVideoStateChanged(state: VideoStateData)` - Video playback state changes

**ScreenStateData Model:**
```kotlin
// Kotlin
data class ScreenStateData(
    val screenName: String,         // Screen identifier
    val state: String,              // "appeared", "disappeared", "focused", "unfocused"
    val timestamp: Long? = null     // Optional timestamp
)
```

```swift
// Swift
struct ScreenStateData {
    var screenName: String         // Screen identifier
    var state: String              // "appeared", "disappeared", "focused", "unfocused"
    var timestamp: Int64? = nil    // Optional timestamp
}
```

**VideoStateData Model:**
```kotlin
// Kotlin
data class VideoStateData(
    val videoId: String,
    val state: String,              // "playing", "paused", "stopped", "buffering", "completed"
    val position: Long? = null,     // Current position in seconds
    val duration: Long? = null,     // Total duration in seconds
    val timestamp: Long? = null     // Optional timestamp
)
```

```swift
// Swift
struct VideoStateData {
    var videoId: String
    var state: String              // "playing", "paused", "stopped", "buffering", "completed"
    var position: Int64? = nil     // Current position in seconds
    var duration: Int64? = nil     // Total duration in seconds
    var timestamp: Int64? = nil    // Optional timestamp
}
```

#### 5. ReelsFlutterNavigationApi (@FlutterApi)
**Flutter calls native for navigation gestures**

Handle swipe gestures for custom navigation.

**Available Methods:**
- `onSwipeLeft()` - User swiped left
- `onSwipeRight()` - User swiped right

### Complete Android Integration Example

```kotlin
import com.eishon.reels_android.*
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        
        // 1. Provide authentication token to Flutter (HostApi)
        ReelsFlutterTokenApi.setUp(messenger, object : ReelsFlutterTokenApi {
            override fun getAccessToken(): String? {
                return AuthManager.getCurrentToken()
            }
        })
        
        // 2. Set up analytics tracking (FlutterApi)
        val analyticsApi = ReelsFlutterAnalyticsApi(messenger)
        // Flutter will send events - handle them in your analytics platform
        
        // 3. Handle button events (FlutterApi)
        val buttonEventsApi = ReelsFlutterButtonEventsApi(messenger)
        // Note: Flutter sends these events. Set up listeners if you need to respond.
        
        // 4. Handle state changes (FlutterApi)
        val stateApi = ReelsFlutterStateApi(messenger)
        // Note: Flutter sends these events. Set up listeners if you need to respond.
        
        // 5. Handle navigation (FlutterApi)
        val navigationApi = ReelsFlutterNavigationApi(messenger)
        // Note: Flutter sends these events. Set up listeners if you need to respond.
    }
}
```

### Complete iOS Integration Example

```swift
import ReelsIOS
import Flutter

class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let flutterEngine = (window?.rootViewController as! FlutterViewController).engine!
        let messenger = flutterEngine.binaryMessenger
        
        // 1. Provide authentication token to Flutter (HostApi)
        ReelsFlutterTokenApiSetup.setUp(
            binaryMessenger: messenger,
            api: TokenProvider()
        )
        
        // 2. Set up analytics tracking (FlutterApi)
        let analyticsApi = ReelsFlutterAnalyticsApi(binaryMessenger: messenger)
        // Flutter will send events through this channel
        
        // 3. Handle button events (FlutterApi)
        let buttonEventsApi = ReelsFlutterButtonEventsApi(binaryMessenger: messenger)
        // Flutter will send button events through this channel
        
        // 4. Handle state changes (FlutterApi)
        let stateApi = ReelsFlutterStateApi(binaryMessenger: messenger)
        // Flutter will send state changes through this channel
        
        // 5. Handle navigation (FlutterApi)
        let navigationApi = ReelsFlutterNavigationApi(binaryMessenger: messenger)
        // Flutter will send navigation events through this channel
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

// Token provider implementation
class TokenProvider: ReelsFlutterTokenApi {
    func getAccessToken() throws -> String? {
        return AuthManager.shared.currentToken
    }
}
```

### Regenerating Pigeon Code

If you need to modify the Pigeon interfaces or regenerate the code:

```bash
cd reels_flutter
dart run pigeon --input pigeons/messages.dart
```

This will regenerate:
- `lib/core/pigeon_generated.dart` (Flutter/Dart)
- `../reels_android/src/main/java/com/eishon/reels_android/PigeonGenerated.kt` (Android)
- `../reels_ios/Sources/ReelsIOS/PigeonGenerated.swift` (iOS)

**Note**: The repository includes a GitHub Actions workflow (`.github/workflows/auto-format-pigeon.yml`) that automatically formats and validates Pigeon code.

### Pigeon Troubleshooting

#### Problem: Methods not found or signature mismatch

**Solution**: 
1. Check that you're using the correct API names (`ReelsFlutter*Api` not `FlutterReels*Api`)
2. Regenerate Pigeon code: `cd reels_flutter && dart run pigeon --input pigeons/messages.dart`
3. Clean and rebuild your project

#### Problem: HostApi vs FlutterApi confusion

**Solution**: Remember:
- **@HostApi**: Native implements, Flutter calls (e.g., `ReelsFlutterTokenApi`)
  - You must call `setUp()` with your implementation
- **@FlutterApi**: Flutter calls native (e.g., `ReelsFlutterAnalyticsApi`)
  - You create an instance to receive events

#### Problem: Events not being received

**Solution**:
1. Verify the Flutter engine is initialized before setting up Pigeon APIs
2. Check that you're using the correct `BinaryMessenger` instance
3. Ensure methods are called after `configureFlutterEngine` (Android) or engine initialization (iOS)

#### Problem: Compilation errors after regenerating

**Solution**:
1. Clean build: `flutter clean` (in reels_flutter)
2. Android: `./gradlew clean` (in reels_android)
3. iOS: `pod deintegrate && pod install` (in reels_ios)
4. Rebuild the project

---

## 💡 Pro Tips

1. **Start with the example apps** - They show best practices and working integration
2. **Use the listener/delegate** - Get notified of user interactions for analytics
3. **Preload thumbnails** - Better UX if you provide thumbnail URLs
4. **Test on real devices** - Video performance varies between emulator and device

---

## 🤝 Need Help?

- **Issues**: [GitHub Issues](https://github.com/eishon/flutter-reels/issues)
- **Examples**: See `example/android` and `example/ios` directories
- **Contributing**: See [SETUP.md](./SETUP.md) for development setup

---

**Made with ❤️ using Flutter's Add-to-App pattern**

*You get the power of Flutter without needing to know Flutter!*
