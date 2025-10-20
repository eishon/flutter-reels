# Native Initialization Quick Start

This guide shows you how to quickly initialize Flutter Reels in your native Android and iOS applications.

## Overview

Flutter Reels now requires native initialization to setup platform communication channels (Pigeon APIs). This enables:
- ✅ Analytics tracking from Flutter to native
- ✅ Access token management
- ✅ Button event callbacks (like, share)
- ✅ Screen & video state events
- ✅ Swipe gesture navigation

---

## 🤖 Android Integration (Kotlin)

### Step 1: Initialize FlutterEngine in Application Class

```kotlin
// MyApplication.kt
import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MyApplication : Application() {
    
    companion object {
        const val FLUTTER_ENGINE_ID = "flutter_reels_engine"
    }
    
    override fun onCreate() {
        super.onCreate()
        
        // Initialize Flutter Engine
        val flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        
        // Cache the engine for reuse
        FlutterEngineCache.getInstance().put(FLUTTER_ENGINE_ID, flutterEngine)
        
        // Setup Pigeon APIs
        setupFlutterReelsApis(flutterEngine)
    }
    
    private fun setupFlutterReelsApis(engine: FlutterEngine) {
        val messenger = engine.dartExecutor.binaryMessenger
        
        // 1. Analytics API - Receive analytics events from Flutter
        FlutterReelsAnalyticsApi.setUp(messenger) { event ->
            // Handle analytics events
            when (event.type) {
                "appear" -> {
                    val videoId = event.data["video_id"] as? String
                    // Track video view
                }
                "click" -> {
                    val element = event.data["element"] as? String
                    // Track click event
                }
                "page_view" -> {
                    val screen = event.data["screen"] as? String
                    // Track page view
                }
            }
        }
        
        // 2. Button Events API - Handle like/share actions
        FlutterReelsButtonEventsApi.setUp(messenger, object : FlutterReelsButtonEventsApi {
            override fun onBeforeLikeButtonClick(videoId: String, currentLikeState: Boolean) {
                // Called before like button is clicked
                // Use this to check authentication, etc.
            }
            
            override fun onAfterLikeButtonClick(videoId: String, newLikeState: Boolean) {
                // Called after like state changes
                // Sync with your backend
            }
            
            override fun onBeforeShareButtonClick(videoId: String, currentShareCount: Long) {
                // Called before share button is clicked
            }
            
            override fun onAfterShareButtonClick(shareData: Messages.ShareData) {
                // Called when user wants to share
                // Open native share sheet
                val intent = Intent(Intent.ACTION_SEND).apply {
                    type = "text/plain"
                    putExtra(Intent.EXTRA_TEXT, shareData.url)
                    putExtra(Intent.EXTRA_TITLE, shareData.title)
                }
                startActivity(Intent.createChooser(intent, "Share via"))
            }
        })
        
        // 3. State Events API - Track screen and video states
        FlutterReelsStateApi.setUp(messenger, object : FlutterReelsStateApi {
            override fun onScreenStateChanged(state: Messages.ScreenStateData) {
                when (state.state) {
                    "focused" -> {
                        // Screen came to foreground
                    }
                    "unfocused" -> {
                        // Screen went to background
                    }
                }
            }
            
            override fun onVideoStateChanged(state: Messages.VideoStateData) {
                when (state.state) {
                    "playing" -> { /* Video started playing */ }
                    "paused" -> { /* Video paused */ }
                    "stopped" -> { /* Video stopped */ }
                    "buffering" -> { /* Video buffering */ }
                    "completed" -> { /* Video completed */ }
                }
            }
        })
        
        // 4. Navigation API - Handle swipe gestures
        FlutterReelsNavigationApi.setUp(messenger, object : FlutterReelsNavigationApi {
            override fun onSwipeLeft() {
                // User swiped left - maybe open profile or details
            }
            
            override fun onSwipeRight() {
                // User swiped right - maybe go back
            }
        })
        
        // 5. Token API - Provide access tokens to Flutter
        FlutterReelsTokenApi.setUp(messenger, object : FlutterReelsTokenApi {
            override fun getAccessToken(callback: Messages.TokenCallback) {
                // Fetch token from your auth system
                val token = getYourAuthToken()
                
                if (token != null) {
                    callback.onTokenReceived(token)
                } else {
                    callback.onTokenError("No token available")
                }
            }
        })
    }
    
    private fun getYourAuthToken(): String? {
        // TODO: Implement your token retrieval logic
        return "your_access_token"
    }
}
```

### Step 2: Update AndroidManifest.xml

```xml
<application
    android:name=".MyApplication"
    ...>
    ...
</application>
```

### Step 3: Create ReelsActivity

```kotlin
// ReelsActivity.kt
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity

class ReelsActivity : FlutterActivity() {
    
    override fun getCachedEngineId(): String {
        return MyApplication.FLUTTER_ENGINE_ID
    }
    
    override fun shouldDestroyEngineWithHost(): Boolean {
        // Keep engine alive for better performance
        return false
    }
    
    companion object {
        fun launch(context: Context) {
            context.startActivity(
                Intent(context, ReelsActivity::class.java)
            )
        }
    }
}
```

### Step 4: Launch Flutter Reels

```kotlin
// From anywhere in your app
ReelsActivity.launch(this)
```

---

## 🍎 iOS Integration (Swift)

### Step 1: Initialize FlutterEngine in AppDelegate

```swift
// AppDelegate.swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private var flutterEngine: FlutterEngine?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize Flutter Engine
        let engine = FlutterEngine(name: "flutter_reels_engine")
        engine.run()
        self.flutterEngine = engine
        
        // Setup Pigeon APIs
        setupFlutterReelsApis(binaryMessenger: engine.binaryMessenger)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupFlutterReelsApis(binaryMessenger: FlutterBinaryMessenger) {
        
        // 1. Analytics API - Receive analytics events from Flutter
        FlutterReelsAnalyticsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: AnalyticsHandler()
        )
        
        // 2. Button Events API - Handle like/share actions
        FlutterReelsButtonEventsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: ButtonEventsHandler()
        )
        
        // 3. State Events API - Track screen and video states
        FlutterReelsStateApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: StateEventsHandler()
        )
        
        // 4. Navigation API - Handle swipe gestures
        FlutterReelsNavigationApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: NavigationHandler()
        )
        
        // 5. Token API - Provide access tokens to Flutter
        FlutterReelsTokenApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: TokenProvider()
        )
    }
    
    func getFlutterEngine() -> FlutterEngine? {
        return flutterEngine
    }
}

// MARK: - Analytics Handler
class AnalyticsHandler: FlutterReelsAnalyticsApi {
    func trackEvent(event: AnalyticsEvent, completion: @escaping (Result<Void, Error>) -> Void) {
        switch event.type {
        case "appear":
            if let videoId = event.data["video_id"] as? String {
                // Track video view
                print("Video appeared: \(videoId)")
            }
        case "click":
            if let element = event.data["element"] as? String {
                // Track click event
                print("Element clicked: \(element)")
            }
        case "page_view":
            if let screen = event.data["screen"] as? String {
                // Track page view
                print("Page viewed: \(screen)")
            }
        default:
            break
        }
        completion(.success(()))
    }
}

// MARK: - Button Events Handler
class ButtonEventsHandler: FlutterReelsButtonEventsApi {
    func onBeforeLikeButtonClick(
        videoId: String,
        currentLikeState: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Called before like button is clicked
        print("Before like: \(videoId), current state: \(currentLikeState)")
        completion(.success(()))
    }
    
    func onAfterLikeButtonClick(
        videoId: String,
        newLikeState: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Called after like state changes
        print("After like: \(videoId), new state: \(newLikeState)")
        // TODO: Sync with your backend
        completion(.success(()))
    }
    
    func onBeforeShareButtonClick(
        videoId: String,
        currentShareCount: Int64,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Called before share button is clicked
        print("Before share: \(videoId)")
        completion(.success(()))
    }
    
    func onAfterShareButtonClick(
        shareData: ShareData,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Open native share sheet
        let activityVC = UIActivityViewController(
            activityItems: [shareData.url, shareData.title],
            applicationActivities: nil
        )
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(activityVC, animated: true)
        }
        
        completion(.success(()))
    }
}

// MARK: - State Events Handler
class StateEventsHandler: FlutterReelsStateApi {
    func onScreenStateChanged(
        state: ScreenStateData,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        switch state.state {
        case "focused":
            print("Screen focused")
            // Resume video playback if needed
        case "unfocused":
            print("Screen unfocused")
            // Pause video playback if needed
        default:
            break
        }
        completion(.success(()))
    }
    
    func onVideoStateChanged(
        state: VideoStateData,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print("Video \(state.videoId) is \(state.state)")
        // Handle video state changes
        completion(.success(()))
    }
}

// MARK: - Navigation Handler
class NavigationHandler: FlutterReelsNavigationApi {
    func onSwipeLeft(completion: @escaping (Result<Void, Error>) -> Void) {
        print("Swiped left")
        // Navigate to profile or details
        completion(.success(()))
    }
    
    func onSwipeRight(completion: @escaping (Result<Void, Error>) -> Void) {
        print("Swiped right")
        // Go back
        completion(.success(()))
    }
}

// MARK: - Token Provider
class TokenProvider: FlutterReelsTokenApi {
    func getAccessToken(
        callback: TokenCallback,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Fetch token from your auth system
        if let token = getYourAuthToken() {
            callback.onTokenReceived(token: token) { _ in }
        } else {
            callback.onTokenError(error: "No token available") { _ in }
        }
        completion(.success(()))
    }
    
    private func getYourAuthToken() -> String? {
        // TODO: Implement your token retrieval logic
        return "your_access_token"
    }
}
```

### Step 2: Create ReelsViewController

```swift
// ReelsViewController.swift
import UIKit
import Flutter

class ReelsViewController: FlutterViewController {
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let engine = appDelegate.getFlutterEngine()!
        
        super.init(engine: engine, nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

### Step 3: Launch Flutter Reels

```swift
// From anywhere in your app
let reelsVC = ReelsViewController()
navigationController?.pushViewController(reelsVC, animated: true)

// Or present modally
present(reelsVC, animated: true)
```

---

## 📋 Checklist

### Before Integration
- [ ] Flutter SDK installed (3.0+)
- [ ] Flutter Reels added to your project
- [ ] Run `dart run pigeon --input pigeon/messages.dart` to generate platform code
- [ ] Run `flutter pub get` to install dependencies

### Android
- [ ] Created `MyApplication` class
- [ ] Initialized FlutterEngine in `onCreate()`
- [ ] Setup all 5 Pigeon APIs (Analytics, ButtonEvents, State, Navigation, Token)
- [ ] Updated `AndroidManifest.xml` with application name
- [ ] Created `ReelsActivity` with cached engine
- [ ] Tested launching ReelsActivity

### iOS
- [ ] Updated `Podfile` with Flutter pods
- [ ] Run `pod install`
- [ ] Initialized FlutterEngine in `AppDelegate`
- [ ] Setup all 5 Pigeon APIs
- [ ] Created handler classes (Analytics, ButtonEvents, State, Navigation, Token)
- [ ] Created `ReelsViewController`
- [ ] Tested launching ReelsViewController

---

## 🚀 Quick Test

After integration, test that everything works:

### Android
```kotlin
// In any Activity
Button("Open Reels") {
    ReelsActivity.launch(this)
}
```

### iOS
```swift
// In any ViewController
@IBAction func openReels() {
    let reelsVC = ReelsViewController()
    navigationController?.pushViewController(reelsVC, animated: true)
}
```

---

## 🔍 Troubleshooting

### Engine not initialized
**Error:** `FlutterEngine is null`  
**Solution:** Make sure you initialize the engine in `Application.onCreate()` (Android) or `AppDelegate.didFinishLaunchingWithOptions` (iOS)

### Pigeon APIs not working
**Error:** `No implementation found for method`  
**Solution:** 
1. Run `dart run pigeon --input pigeon/messages.dart`
2. Make sure you call `.setUp()` for all APIs before launching Flutter screen
3. Verify the generated files are included in your build

### Token callback not working
**Error:** No access token received in Flutter  
**Solution:** Implement `FlutterReelsTokenApi` and call `callback.onTokenReceived(token)` with a valid token

### App crashes on launch
**Error:** Crash when opening Flutter screen  
**Solution:** 
1. Check that FlutterEngine is cached before creating Activity/ViewController
2. Verify all Pigeon handler methods return success in completion callbacks
3. Check Xcode/Android Studio logs for specific error messages

---

## 📚 Next Steps

- **Full Documentation:** See [NATIVE_INTEGRATION.md](./NATIVE_INTEGRATION.md) for complete details
- **Multi-Instance Navigation:** See [MULTI_INSTANCE_NAVIGATION.md](./MULTI_INSTANCE_NAVIGATION.md) for complex navigation patterns
- **API Reference:** See [pigeon/README.md](./flutter_reels/pigeon/README.md) for detailed API documentation
- **Examples:** Check the `examples/` directory for complete integration examples

---

## ⚡ Performance Tips

1. **Initialize Early:** Initialize FlutterEngine in `Application.onCreate()` / `AppDelegate` to reduce first-launch latency
2. **Cache the Engine:** Always cache the engine to avoid re-initialization overhead (~500ms saved)
3. **Keep Engine Alive:** Set `shouldDestroyEngineWithHost = false` to reuse the engine across multiple launches
4. **Single Engine Pattern:** Use one engine for all Flutter screens (recommended for 95% of apps)
5. **Background Initialization:** Consider initializing the engine in background thread for smoother startup

---

## 💡 Pro Tips

- **Analytics:** Use the Analytics API to track user behavior and send events to your analytics platform
- **Authentication:** Use the Token API to provide secure access tokens from your native auth system
- **Deep Linking:** Combine Navigation API with deep links to enable swipe-to-profile navigation
- **Custom Share:** Implement native share sheets in `onAfterShareButtonClick` for platform-specific sharing
- **Video States:** Use State Events to pause videos when app goes to background, saving battery

---

**Need Help?** Check the [main README](./README.md) or open an issue on GitHub.
