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
        ↓ [Initialize SDK, Set Listener, Show Reels]
reels_android / reels_ios (Native SDK)
    [Clean, Type-Safe API]
    [Handles Pigeon Setup Automatically]
        ↓ [Pigeon Communication Channels]
    Flutter Engine + Pigeon
    [Type-Safe Platform Channels]
    [5 APIs: Token, Analytics, Button Events, State, Navigation]
        ↓ [UI Rendering & Business Logic]
reels_flutter Module (Reels UI)
    [Video Playback, Interactions, Animations]
```

**You only interact with the top layer** - everything else is handled automatically!

**Communication Flow:**
1. **Your App → Native SDK**: Clean Kotlin/Swift API calls
2. **Native SDK ↔ Flutter Module**: Type-safe Pigeon communication (automatic)
3. **Flutter Module → Your App**: Event callbacks through listener/delegate

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
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // 1. Initialize the SDK with optional access token provider
        ReelsAndroidSDK.initialize(
            context = this,
            accessTokenProvider = {
                // Return user's authentication token
                // This will be called when Flutter needs the token
                getUserAuthToken()
            }
        )
        
        // 2. Set up event listener (optional)
        ReelsAndroidSDK.setListener(object : ReelsListener {
            override fun onReelViewed(videoId: String) {
                Log.d(TAG, "User completed viewing video: $videoId")
                // Track analytics, update view count, etc.
            }
            
            override fun onReelLiked(videoId: String, isLiked: Boolean) {
                Log.d(TAG, "Video $videoId liked: $isLiked")
                // Sync like state with your backend
            }
            
            override fun onReelShared(videoId: String) {
                Log.d(TAG, "User shared video: $videoId")
                // Track share analytics
            }
            
            override fun onReelsClosed() {
                Log.d(TAG, "User closed reels screen")
            }
            
            override fun onError(errorMessage: String) {
                Log.e(TAG, "Reels error: $errorMessage")
            }
            
            // Alternative way to provide access token
            override fun getAccessToken(): String? {
                return getUserAuthToken()
            }
        })
        
        // 3. Show reels using FlutterActivity
        findViewById<Button>(R.id.btnShowReels).setOnClickListener {
            val intent = FlutterActivity
                .withCachedEngine(ReelsAndroidSDK.getEngineId())
                .build(this)
            startActivity(intent)
        }
    }
    
    private fun getUserAuthToken(): String? {
        // Return your user's authentication token
        // Return null if user is not authenticated
        return "user_token_123"
    }
    
    companion object {
        private const val TAG = "MainActivity"
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
import Flutter

class AppDelegate: UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 1. Initialize the SDK with optional access token provider
        ReelsIOSSDK.shared.initialize(accessTokenProvider: {
            // Return user's authentication token
            // This will be called when Flutter needs the token
            return self.getUserAuthToken()
        })
        
        // 2. Set up delegate (optional)
        ReelsIOSSDK.shared.delegate = self
        
        return true
    }
    
    private func getUserAuthToken() -> String? {
        // Return your user's authentication token
        // Return nil if user is not authenticated
        return "user_token_123"
    }
}

// Implement the delegate
extension AppDelegate: ReelsDelegate {
    
    func onReelViewed(videoId: String) {
        print("User completed viewing video: \(videoId)")
        // Track analytics, update view count, etc.
    }
    
    func onReelLiked(videoId: String, isLiked: Bool) {
        print("Video \(videoId) liked: \(isLiked)")
        // Sync like state with your backend
    }
    
    func onReelShared(videoId: String) {
        print("User shared video: \(videoId)")
        // Track share analytics
    }
    
    func onReelCommented(videoId: String) {
        print("User commented on video: \(videoId)")
    }
    
    func onProductClicked(productId: String, videoId: String) {
        print("Product \(productId) clicked in video: \(videoId)")
        // Navigate to product details
    }
    
    func onReelsClosed() {
        print("User closed reels screen")
    }
    
    func onError(errorMessage: String) {
        print("Reels error: \(errorMessage)")
    }
    
    // Alternative way to provide access token
    func getAccessToken() -> String? {
        return getUserAuthToken()
    }
}

// Show reels from any view controller
class ViewController: UIViewController {
    
    @IBAction func showReelsButtonTapped(_ sender: UIButton) {
        showReels()
    }
    
    func showReels() {
        // Get the Flutter engine from the SDK
        guard let flutterEngine = ReelsIOSSDK.shared.getFlutterEngine() else {
            print("Flutter engine not initialized")
            return
        }
        
        // Create a FlutterViewController with the cached engine
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        // Present the reels screen
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true)
    }
}
```

### That's It for iOS! 🎉

CocoaPods handles all the Flutter integration automatically. No Flutter commands needed!

---

## 🔧 SDK Reference

### Initialization Options

**Android:**
```kotlin
ReelsAndroidSDK.initialize(
    context: Context,
    accessTokenProvider: (() -> String?)? = null
)
```

**iOS:**
```swift
ReelsIOSSDK.shared.initialize(
    accessTokenProvider: (() -> String?)? = nil
)
```

### Event Listener Interface

**Android: ReelsListener**
```kotlin
interface ReelsListener {
    fun onReelViewed(videoId: String) {}
    fun onReelLiked(videoId: String, isLiked: Boolean) {}
    fun onReelShared(videoId: String) {}
    fun onReelsClosed() {}
    fun onError(errorMessage: String) {}
    fun getAccessToken(): String? = null
}
```

**iOS: ReelsDelegate**
```swift
@objc protocol ReelsDelegate: AnyObject {
    @objc optional func onReelViewed(videoId: String)
    @objc optional func onReelLiked(videoId: String, isLiked: Bool)
    @objc optional func onReelShared(videoId: String)
    @objc optional func onReelCommented(videoId: String)
    @objc optional func onProductClicked(productId: String, videoId: String)
    @objc optional func onReelsClosed()
    @objc optional func onError(errorMessage: String)
    @objc optional func getAccessToken() -> String?
}
```

### Flutter Engine Access

**Android:**
```kotlin
val engine = ReelsAndroidSDK.getFlutterEngine()
val engineId = ReelsAndroidSDK.getEngineId() // Returns "reels_engine"
```

**iOS:**
```swift
let engine = ReelsIOSSDK.shared.getFlutterEngine()
```

Use these to show the reels UI using `FlutterActivity` (Android) or `FlutterViewController` (iOS).

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

**Problem**: "Unresolved reference: ReelsFlutterTokenApi" or other Pigeon classes

**Solution**: The Pigeon-generated code is already included in the `reels_android` module. Make sure you:
1. Have the correct dependency: `implementation project(':reels_android')`
2. Synced Gradle after adding the dependency
3. Are using the correct package: `import com.eishon.reels_android.*`

**Problem**: Token not being requested by Flutter

**Solution**: Ensure you provided the `accessTokenProvider` during initialization:

```kotlin
ReelsAndroidSDK.initialize(
    context = this,
    accessTokenProvider = { getUserToken() }
)
```

Or implement it in your `ReelsListener`:

```kotlin
override fun getAccessToken(): String? {
    return getUserToken()
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

**Problem**: "Cannot find 'ReelsFlutterTokenApi' in scope" or other Pigeon types

**Solution**: The Pigeon-generated code is already included in the `ReelsIOS` pod. Make sure you:
1. Ran `pod install` successfully
2. Are importing the module: `import ReelsIOS`
3. Are building the workspace (not the project)

**Problem**: Token not being requested by Flutter

**Solution**: Ensure you provided the `accessTokenProvider` during initialization:

```swift
ReelsIOSSDK.shared.initialize(accessTokenProvider: {
    return self.getUserToken()
})
```

Or implement it in your `ReelsDelegate`:

```swift
func getAccessToken() -> String? {
    return getUserToken()
}
```

### Common Integration Issues

**Problem**: Events not being received in listener/delegate

**Solution**: Make sure you:
1. Set the listener/delegate **after** initializing the SDK
2. Keep a strong reference to your listener/delegate object
3. Implemented the callback methods correctly

**Android:**
```kotlin
ReelsAndroidSDK.initialize(context = this, accessTokenProvider = { token })
ReelsAndroidSDK.setListener(this) // 'this' must implement ReelsListener
```

**iOS:**
```swift
ReelsIOSSDK.shared.initialize(accessTokenProvider: { token })
ReelsIOSSDK.shared.delegate = self // 'self' must conform to ReelsDelegate
```

**Problem**: App crashes when showing reels

**Solution**: 
1. Verify SDK initialization completed successfully
2. Check logs for detailed error messages
3. Ensure Flutter engine is not null before showing reels

**Android:**
```kotlin
val engine = ReelsAndroidSDK.getFlutterEngine()
if (engine != null) {
    // Safe to show reels
} else {
    Log.e(TAG, "Flutter engine not initialized")
}
```

**iOS:**
```swift
guard let engine = ReelsIOSSDK.shared.getFlutterEngine() else {
    print("Flutter engine not initialized")
    return
}
// Safe to show reels
```

### Performance Issues

**Problem**: Slow startup or high memory usage

**Solution**: 
1. Initialize the SDK early in your app lifecycle (e.g., in `Application.onCreate()` for Android or `application:didFinishLaunchingWithOptions:` for iOS)
2. Reuse the same Flutter engine instance - the SDK handles this automatically
3. Don't create multiple SDK instances

**Problem**: Video playback stuttering

**Solution**:
1. Test on a real device (emulators have limited performance)
2. Ensure videos are properly encoded (H.264/H.265 recommended)
3. Use appropriate video resolutions (1080p recommended, 4K may cause issues on older devices)

---

## 🔌 Advanced: Understanding the Pigeon API (Optional)

**Note**: This section is for advanced users who want to understand or extend the SDK. Regular integration does not require Pigeon knowledge.

### What is Pigeon?

Pigeon is a code generator that creates type-safe communication channels between Flutter and native platforms. Flutter Reels uses Pigeon internally to enable bidirectional communication between the native SDKs and the Flutter module.

### Current Pigeon API Structure

The SDK uses the following APIs for platform communication:

#### 1. ReelsFlutterTokenApi (Host API)
**Direction**: Native → Flutter

Provides authentication tokens to the Flutter module.

```dart
@HostApi()
abstract class ReelsFlutterTokenApi {
  String? getAccessToken();
}
```

**Implementation**: Already handled by `ReelsAndroidSDK` and `ReelsIOSSDK`.

#### 2. ReelsFlutterAnalyticsApi (Flutter API)
**Direction**: Flutter → Native

Sends analytics events from Flutter to native analytics platforms.

```dart
@FlutterApi()
abstract class ReelsFlutterAnalyticsApi {
  void trackEvent(AnalyticsEvent event);
}
```

**Data Model**:
```dart
class AnalyticsEvent {
  final String eventName;
  final Map<String?, String?> eventProperties;
}
```

#### 3. ReelsFlutterButtonEventsApi (Flutter API)
**Direction**: Flutter → Native

Notifies native code about button interactions.

```dart
@FlutterApi()
abstract class ReelsFlutterButtonEventsApi {
  void onBeforeLikeButtonClick(String videoId);
  void onAfterLikeButtonClick(String videoId, bool isLiked, int likeCount);
  void onShareButtonClick(ShareData shareData);
}
```

**Data Model**:
```dart
class ShareData {
  final String videoId;
  final String videoUrl;
  final String title;
  final String description;
  final String? thumbnailUrl;
}
```

#### 4. ReelsFlutterStateApi (Flutter API)
**Direction**: Flutter → Native

Tracks screen and video state changes.

```dart
@FlutterApi()
abstract class ReelsFlutterStateApi {
  void onScreenStateChanged(ScreenStateData state);
  void onVideoStateChanged(VideoStateData state);
}
```

**Data Models**:
```dart
class ScreenStateData {
  final String screenName;
  final String state; // "appeared", "disappeared", "focused", "unfocused"
  final int? timestamp;
}

class VideoStateData {
  final String videoId;
  final String state; // "playing", "paused", "stopped", "buffering", "completed"
  final int? position; // in seconds
  final int? duration; // in seconds
  final int? timestamp;
}
```

#### 5. ReelsFlutterNavigationApi (Flutter API)
**Direction**: Flutter → Native

Handles navigation gestures.

```dart
@FlutterApi()
abstract class ReelsFlutterNavigationApi {
  void onSwipeLeft();
  void onSwipeRight();
}
```

### Extending the SDK

If you want to add custom functionality:

**Android Example** - Custom Analytics Handler:
```kotlin
import com.eishon.reels_android.ReelsFlutterAnalyticsApi
import com.eishon.reels_android.AnalyticsEvent

// Extend ReelsAndroidSDK setup to add custom analytics handling
class CustomReelsIntegration(context: Context) {
    init {
        ReelsAndroidSDK.initialize(context) { "user_token" }
        
        // Access the Flutter engine's binary messenger
        val binaryMessenger = ReelsAndroidSDK.getFlutterEngine()?.dartExecutor?.binaryMessenger
        
        // Set up custom analytics handler
        binaryMessenger?.let { messenger ->
            ReelsFlutterAnalyticsApi.setUp(messenger, object : ReelsFlutterAnalyticsApi {
                override fun trackEvent(event: AnalyticsEvent) {
                    // Send to your analytics platform
                    MyAnalytics.track(
                        eventName = event.eventName,
                        properties = event.eventProperties
                    )
                }
            })
        }
    }
}
```

**iOS Example** - Custom State Tracking:
```swift
import ReelsIOS

class CustomReelsIntegration {
    func setup() {
        // Initialize SDK
        ReelsIOSSDK.shared.initialize(accessTokenProvider: {
            return "user_token"
        })
        
        // The SDK already sets up Pigeon APIs internally
        // But you can extend the delegate to add custom behavior
        ReelsIOSSDK.shared.delegate = self
    }
}

extension CustomReelsIntegration: ReelsDelegate {
    func onReelViewed(videoId: String) {
        // Custom tracking logic
        MyAnalytics.trackVideoView(videoId: videoId)
    }
    
    func onReelLiked(videoId: String, isLiked: Bool) {
        // Custom like handling with backend sync
        syncLikeToBackend(videoId: videoId, isLiked: isLiked)
    }
}
```

### Migration from Legacy Pigeon API

If you're upgrading from a legacy version of Flutter Reels, here's what changed:

#### 1. Token API - Now Synchronous

**Before (Legacy):**
```kotlin
// Android - Callback-based
FlutterReelsTokenApi.setUp(binaryMessenger) { callback ->
    callback.onTokenReceived("user_token")
}
```

**After (Current):**
```kotlin
// Android - Synchronous
ReelsFlutterTokenApi.setUp(binaryMessenger, object : ReelsFlutterTokenApi {
    override fun getAccessToken(): String? {
        return "user_token"
    }
})
```

**Note**: The native SDKs handle this automatically now. You just provide the token during initialization.

#### 2. Analytics Event Structure

**Before (Legacy):**
```dart
class AnalyticsEvent {
  final String type;  // "appear", "click", "page_view"
  final Map<String?, Object?> data;  // Any type of data
}
```

**After (Current):**
```dart
class AnalyticsEvent {
  final String eventName;  // Free-form event name
  final Map<String?, String?> eventProperties;  // String properties only
}
```

**Migration**: Change `type` to `eventName` and ensure all event properties are strings.

#### 3. Button Events - Simplified Interface

**Before (Legacy):**
```kotlin
// Android
override fun onBeforeLikeButtonClick(videoId: String, currentLikeState: Boolean) {
    // currentLikeState was passed
}

override fun onAfterLikeButtonClick(videoId: String, newLikeState: Boolean) {
    // Only new state, no like count
}

override fun onBeforeShareButtonClick(videoId: String, currentShareCount: Long) {
    // Separate before event
}

override fun onAfterShareButtonClick(shareData: ShareData) {
    // Separate after event
}
```

**After (Current):**
```kotlin
// Android
override fun onBeforeLikeButtonClick(videoId: String) {
    // Simplified - no current state needed
}

override fun onAfterLikeButtonClick(videoId: String, isLiked: Boolean, likeCount: Int) {
    // Now includes like count
}

override fun onShareButtonClick(shareData: ShareData) {
    // Single share event (after user action)
}
```

**Migration**: Remove dependencies on current state in before events. Use the like count from after events.

#### 4. State Data - Integer Timestamps

**Before (Legacy):**
```dart
class VideoStateData {
  final String videoId;
  final String state;
  final double? position;  // Double for sub-second precision
  final double? duration;
}

class ScreenStateData {
  final String state;
  final String screenName;
  final Map<String?, Object?>? metadata;  // Generic metadata
}
```

**After (Current):**
```dart
class VideoStateData {
  final String videoId;
  final String state;
  final int? position;    // Integer seconds
  final int? duration;    // Integer seconds
  final int? timestamp;   // New: Unix timestamp
}

class ScreenStateData {
  final String screenName;
  final String state;
  final int? timestamp;   // New: Unix timestamp
  // metadata removed
}
```

**Migration**: 
- Round position/duration values to integers (seconds)
- Remove metadata usage from screen state
- Use timestamp field for tracking event timing

#### 5. Host API Removed

**Before (Legacy):**
```kotlin
// Android - Native could control video playback
val hostApi = FlutterReelsHostApi(binaryMessenger)
hostApi.pauseVideos()
hostApi.resumeVideos()
```

**After (Current):**
```kotlin
// These methods no longer exist
// Video control is now handled internally by Flutter module
// Use ReelsListener events to react to playback state changes
```

**Migration**: Remove any calls to `pauseVideos()` or `resumeVideos()`. The Flutter module now manages video lifecycle automatically based on screen visibility and app lifecycle events.

#### Complete Migration Example

**Before (Legacy Android):**
```kotlin
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Complex manual setup
        FlutterReelsAnalyticsApi.setUp(flutterEngine.dartExecutor.binaryMessenger) { event ->
            Analytics.track(event.type, event.data)
        }
        
        FlutterReelsButtonEventsApi.setUp(flutterEngine.dartExecutor.binaryMessenger, 
            object : FlutterReelsButtonEventsApi {
            override fun onBeforeLikeButtonClick(videoId: String, currentLikeState: Boolean) {
                // Handle before like
            }
            override fun onAfterLikeButtonClick(videoId: String, newLikeState: Boolean) {
                // Handle after like
            }
        })
        
        val hostApi = FlutterReelsHostApi(flutterEngine.dartExecutor.binaryMessenger)
        hostApi.pauseVideos()
    }
}
```

**After (Current Android):**
```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Simple SDK initialization
        ReelsAndroidSDK.initialize(
            context = this,
            accessTokenProvider = { getUserToken() }
        )
        
        // Clean listener interface
        ReelsAndroidSDK.setListener(object : ReelsListener {
            override fun onReelLiked(videoId: String, isLiked: Boolean) {
                // Much simpler!
            }
        })
        
        // Show reels
        val intent = FlutterActivity
            .withCachedEngine(ReelsAndroidSDK.getEngineId())
            .build(this)
        startActivity(intent)
    }
}
```

**Key Benefits of Migration:**
- ✅ 70% less boilerplate code
- ✅ No direct Pigeon API handling required
- ✅ Type-safe, idiomatic Kotlin/Swift APIs
- ✅ Automatic Pigeon setup and lifecycle management
- ✅ Better error handling and diagnostics

## ❓ FAQ

### Do I need to install Flutter?

**For integration**: No! The native SDKs include everything you need.

**For contribution**: Yes, if you want to modify the Flutter module or contribute to the project. See [SETUP.md](./SETUP.md).

### Do I need to learn Pigeon?

**No!** Pigeon is only used internally for platform communication. The native SDKs provide clean, type-safe APIs that hide all Pigeon complexity.

**However**, if you want to extend the SDK with custom functionality, understanding the Pigeon API can be helpful. See the "Advanced: Understanding the Pigeon API" section above.

### Can I customize the UI?

Currently, the UI is provided by the Flutter module. Customization options are planned for future releases. For now, you can fork the repository and modify `reels_flutter/lib/` to your needs.

### How do I update to a new version?

1. Pull the latest changes from the repository
2. **Android**: Sync Gradle
3. **iOS**: Run `pod install` again

### Does this work with SwiftUI?

Yes! You can wrap the reels view in a `UIViewControllerRepresentable` for SwiftUI integration.

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
