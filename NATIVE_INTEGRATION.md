# Native Integration Guide

This guide shows you how to integrate Flutter Reels into your existing native Android and iOS applications.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Android Integration](#android-integration)
3. [iOS Integration](#ios-integration)
4. [Common Integration Patterns](#common-integration-patterns)
5. [Testing](#testing)
6. [Troubleshooting](#troubleshooting)

> **📘 Advanced Navigation:** For complex navigation patterns including NATIVE→FLUTTER→NATIVE→FLUTTER (multi-instance), see [Multi-Instance Navigation Guide](./MULTI_INSTANCE_NAVIGATION.md)

---

## Prerequisites

### Required Tools
- Flutter SDK 3.0 or higher
- Android Studio (for Android)
- Xcode 14+ (for iOS)
- CocoaPods 1.10+ (for iOS)

### Flutter Reels Setup
1. Add Flutter Reels to your project (see main README.md)
2. Run pigeon code generation: `dart run pigeon --input pigeon/messages.dart`
3. Ensure all dependencies are installed: `flutter pub get`

---

## Android Integration

### Step 1: Add Flutter Module

In your `settings.gradle`:

```gradle
setBinding(new Binding([gradle: this]))
evaluate(new File(
  settingsDir,
  'flutter_reels/.android/include_flutter.groovy'
))
```

In your app's `build.gradle`:

```gradle
dependencies {
    implementation project(':flutter')
    implementation project(':flutter_reels')
}
```

### Step 2: Setup FlutterEngine

Create a singleton to manage the Flutter engine:

```kotlin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

object FlutterEngineManager {
    const val ENGINE_ID = "flutter_reels_engine"
    
    fun initializeFlutterEngine(context: Context): FlutterEngine {
        val flutterEngine = FlutterEngine(context)
        
        // Start executing Dart code
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        
        // Cache the engine
        FlutterEngineCache
            .getInstance()
            .put(ENGINE_ID, flutterEngine)
        
        return flutterEngine
    }
    
    fun getEngine(): FlutterEngine? {
        return FlutterEngineCache
            .getInstance()
            .get(ENGINE_ID)
    }
}
```

### Step 3: Setup Pigeon APIs

In your `Application` class or `MainActivity`:

```kotlin
import com.example.flutter_reels.*

class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        val flutterEngine = FlutterEngineManager.initializeFlutterEngine(this)
        setupPigeonApis(flutterEngine)
    }
    
    private fun setupPigeonApis(flutterEngine: FlutterEngine) {
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        
        // Setup Analytics API
        FlutterReelsAnalyticsApi.setUp(messenger) { event ->
            handleAnalyticsEvent(event)
        }
        
        // Setup Button Events API
        FlutterReelsButtonEventsApi.setUp(messenger, ButtonEventsHandler())
        
        // Setup State Events API
        FlutterReelsStateApi.setUp(messenger, StateEventsHandler())
        
        // Setup Navigation API
        FlutterReelsNavigationApi.setUp(messenger, NavigationHandler())
        
        // Setup Token API (provide access tokens)
        FlutterReelsTokenApi.setUp(messenger, TokenProvider())
    }
    
    private fun handleAnalyticsEvent(event: Messages.AnalyticsEvent) {
        when (event.type) {
            "appear" -> {
                val videoId = event.data["video_id"] as? String
                Analytics.trackVideoView(videoId)
            }
            "click" -> {
                val element = event.data["element"] as? String
                Analytics.trackClick(element)
            }
            "page_view" -> {
                val screenName = event.data["screen"] as? String
                Analytics.trackPageView(screenName)
            }
        }
    }
}
```

### Step 4: Implement Event Handlers

```kotlin
class ButtonEventsHandler : FlutterReelsButtonEventsApi {
    override fun onBeforeLikeButtonClick(videoId: String, currentLikeState: Boolean) {
        Log.d("FlutterReels", "User about to like video: $videoId")
        // Validate user authentication, show login if needed
    }
    
    override fun onAfterLikeButtonClick(videoId: String, newLikeState: Boolean) {
        Log.d("FlutterReels", "User liked video: $videoId, state: $newLikeState")
        // Sync like state with backend
    }
    
    override fun onBeforeShareButtonClick(videoId: String, currentShareCount: Long) {
        Log.d("FlutterReels", "User about to share: $videoId")
    }
    
    override fun onAfterShareButtonClick(shareData: Messages.ShareData) {
        // Open native share sheet
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, shareData.url)
            putExtra(Intent.EXTRA_TITLE, shareData.title)
        }
        startActivity(Intent.createChooser(intent, "Share via"))
    }
}

class StateEventsHandler : FlutterReelsStateApi {
    override fun onScreenStateChanged(state: Messages.ScreenStateData) {
        when (state.state) {
            "focused" -> resumeVideoPlayback()
            "unfocused" -> pauseVideoPlayback()
        }
    }
    
    override fun onVideoStateChanged(state: Messages.VideoStateData) {
        when (state.state) {
            "playing" -> onVideoPlaying(state.videoId)
            "paused" -> onVideoPaused(state.videoId)
            "completed" -> onVideoCompleted(state.videoId)
        }
    }
}

class NavigationHandler : FlutterReelsNavigationApi {
    override fun onSwipeLeft() {
        // Navigate to profile or details screen
        navigateToProfile()
    }
    
    override fun onSwipeRight() {
        // Go back to main feed
        navigateBack()
    }
}

class TokenProvider : FlutterReelsTokenApi {
    override fun getAccessToken(callback: Messages.TokenCallback) {
        // Fetch token from secure storage or auth service
        val token = AuthManager.getCurrentToken()
        
        if (token != null) {
            callback.onTokenReceived(token)
        } else {
            callback.onTokenError("No token available")
        }
    }
}
```

### Step 5: Display Flutter Reels

```kotlin
import io.flutter.embedding.android.FlutterActivity

class ReelsActivity : FlutterActivity() {
    override fun getCachedEngineId(): String {
        return FlutterEngineManager.ENGINE_ID
    }
    
    override fun shouldDestroyEngineWithHost(): Boolean {
        // Keep engine alive for faster subsequent launches
        return false
    }
    
    companion fun {
        fun launch(context: Context) {
            context.startActivity(
                Intent(context, ReelsActivity::class.java)
            )
        }
    }
}
```

---

## iOS Integration

### Step 1: Add Flutter Module

In your `Podfile`:

```ruby
flutter_application_path = '../flutter_reels'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'YourApp' do
  use_frameworks!
  
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end
```

Run: `pod install`

### Step 2: Setup FlutterEngine

Create a singleton to manage the Flutter engine:

```swift
import Flutter
import UIKit

class FlutterEngineManager {
    static let shared = FlutterEngineManager()
    
    private(set) var flutterEngine: FlutterEngine?
    
    private init() {}
    
    func initializeEngine() -> FlutterEngine {
        let engine = FlutterEngine(name: "flutter_reels_engine")
        engine.run()
        self.flutterEngine = engine
        return engine
    }
    
    func getEngine() -> FlutterEngine? {
        return flutterEngine
    }
}
```

### Step 3: Setup Pigeon APIs

In your `AppDelegate`:

```swift
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize Flutter engine
        let flutterEngine = FlutterEngineManager.shared.initializeEngine()
        let binaryMessenger = flutterEngine.binaryMessenger
        
        // Setup Pigeon APIs
        setupPigeonApis(binaryMessenger: binaryMessenger)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupPigeonApis(binaryMessenger: FlutterBinaryMessenger) {
        // Analytics API
        FlutterReelsAnalyticsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: AnalyticsHandler()
        )
        
        // Button Events API
        FlutterReelsButtonEventsApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: ButtonEventsHandler()
        )
        
        // State Events API
        FlutterReelsStateApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: StateEventsHandler()
        )
        
        // Navigation API
        FlutterReelsNavigationApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: NavigationHandler()
        )
        
        // Token API
        FlutterReelsTokenApiSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: TokenProvider()
        )
    }
}
```

### Step 4: Implement Event Handlers

```swift
class AnalyticsHandler: FlutterReelsAnalyticsApi {
    func trackEvent(event: AnalyticsEvent, completion: @escaping (Result<Void, Error>) -> Void) {
        switch event.type {
        case "appear":
            if let videoId = event.data["video_id"] as? String {
                Analytics.trackVideoView(videoId)
            }
        case "click":
            if let element = event.data["element"] as? String {
                Analytics.trackClick(element)
            }
        case "page_view":
            if let screenName = event.data["screen"] as? String {
                Analytics.trackPageView(screenName)
            }
        default:
            break
        }
        completion(.success(()))
    }
}

class ButtonEventsHandler: FlutterReelsButtonEventsApi {
    func onBeforeLikeButtonClick(videoId: String, currentLikeState: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        print("User about to like video: \(videoId)")
        completion(.success(()))
    }
    
    func onAfterLikeButtonClick(videoId: String, newLikeState: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        print("User liked video: \(videoId), state: \(newLikeState)")
        // Sync with backend
        completion(.success(()))
    }
    
    func onBeforeShareButtonClick(videoId: String, currentShareCount: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        print("User about to share: \(videoId)")
        completion(.success(()))
    }
    
    func onAfterShareButtonClick(shareData: ShareData, completion: @escaping (Result<Void, Error>) -> Void) {
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

class StateEventsHandler: FlutterReelsStateApi {
    func onScreenStateChanged(state: ScreenStateData, completion: @escaping (Result<Void, Error>) -> Void) {
        switch state.state {
        case "focused":
            resumeVideoPlayback()
        case "unfocused":
            pauseVideoPlayback()
        default:
            break
        }
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
        navigateToProfile()
        completion(.success(()))
    }
    
    func onSwipeRight(completion: @escaping (Result<Void, Error>) -> Void) {
        // Go back
        navigateBack()
        completion(.success(()))
    }
}

class TokenProvider: FlutterReelsTokenApi {
    func getAccessToken(callback: TokenCallback, completion: @escaping (Result<Void, Error>) -> Void) {
        // Fetch token from keychain or auth service
        if let token = AuthManager.shared.getCurrentToken() {
            callback.onTokenReceived(token: token) { _ in }
        } else {
            callback.onTokenError(error: "No token available") { _ in }
        }
        completion(.success(()))
    }
}
```

### Step 5: Display Flutter Reels

```swift
import Flutter
import UIKit

class ReelsViewController: FlutterViewController {
    init() {
        let engine = FlutterEngineManager.shared.getEngine()!
        super.init(engine: engine, nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    static func present(from viewController: UIViewController) {
        let reelsVC = ReelsViewController()
        viewController.present(reelsVC, animated: true)
    }
}
```

---

## Common Integration Patterns

### Pattern 1: Authentication Flow

**Android:**
```kotlin
class TokenProvider : FlutterReelsTokenApi {
    override fun getAccessToken(callback: Messages.TokenCallback) {
        AuthManager.getCurrentToken { result ->
            when (result) {
                is Success -> callback.onTokenReceived(result.token)
                is Error -> {
                    // Show login screen
                    showLoginScreen()
                    callback.onTokenError("Please log in")
                }
            }
        }
    }
}
```

**iOS:**
```swift
class TokenProvider: FlutterReelsTokenApi {
    func getAccessToken(callback: TokenCallback, completion: @escaping (Result<Void, Error>) -> Void) {
        AuthManager.shared.getCurrentToken { result in
            switch result {
            case .success(let token):
                callback.onTokenReceived(token: token) { _ in }
            case .failure:
                self.showLoginScreen()
                callback.onTokenError(error: "Please log in") { _ in }
            }
            completion(.success(()))
        }
    }
}
```

### Pattern 2: Deep Linking

Handle deep links to specific videos:

**Android:**
```kotlin
class ReelsActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Handle deep link
        intent.data?.let { uri ->
            val videoId = uri.getQueryParameter("video_id")
            navigateToVideo(videoId)
        }
    }
    
    private fun navigateToVideo(videoId: String?) {
        videoId?.let {
            val hostApi = FlutterReelsHostApi(flutterEngine!!.dartExecutor.binaryMessenger)
            // Use method channel to navigate to specific video
        }
    }
}
```

**iOS:**
```swift
class ReelsViewController: FlutterViewController {
    func handleDeepLink(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let videoId = components.queryItems?.first(where: { $0.name == "video_id" })?.value else {
            return
        }
        
        navigateToVideo(videoId: videoId)
    }
}
```

### Pattern 3: Background Video Pause

Automatically pause videos when app goes to background:

**Android:**
```kotlin
class StateEventsHandler : FlutterReelsStateApi {
    private val hostApi by lazy {
        FlutterReelsHostApi(flutterEngine.dartExecutor.binaryMessenger)
    }
    
    fun onAppBackground() {
        hostApi.pauseVideos { }
    }
    
    fun onAppForeground() {
        hostApi.resumeVideos { }
    }
    
    override fun onScreenStateChanged(state: Messages.ScreenStateData) {
        // Handle screen state changes
    }
    
    override fun onVideoStateChanged(state: Messages.VideoStateData) {
        // Handle video state changes
    }
}
```

**iOS:**
```swift
class StateEventsHandler: FlutterReelsStateApi {
    private var hostApi: FlutterReelsHostApi?
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        hostApi = FlutterReelsHostApi(binaryMessenger: binaryMessenger)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc private func appDidEnterBackground() {
        hostApi?.pauseVideos { _ in }
    }
    
    @objc private func appWillEnterForeground() {
        hostApi?.resumeVideos { _ in }
    }
}
```

---

## Testing

### Unit Testing (Android)

```kotlin
@RunWith(MockitoJUnitRunner::class)
class ButtonEventsHandlerTest {
    @Mock
    private lateinit var mockCallback: (Result<Void>) -> Unit
    
    private lateinit var handler: ButtonEventsHandler
    
    @Before
    fun setup() {
        handler = ButtonEventsHandler()
    }
    
    @Test
    fun `test like button click`() {
        handler.onAfterLikeButtonClick("video123", true)
        
        // Verify analytics tracked
        verify(Analytics).trackLike("video123", true)
    }
}
```

### Unit Testing (iOS)

```swift
import XCTest

class ButtonEventsHandlerTests: XCTestCase {
    var handler: ButtonEventsHandler!
    
    override func setUp() {
        super.setUp()
        handler = ButtonEventsHandler()
    }
    
    func testLikeButtonClick() {
        let expectation = XCTestExpectation(description: "Like callback")
        
        handler.onAfterLikeButtonClick(videoId: "video123", newLikeState: true) { result in
            XCTAssertTrue(result.isSuccess)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
```

---

## Troubleshooting

### Common Issues

#### 1. "MissingPluginException" on Android
**Cause:** FlutterEngine not properly initialized or APIs not setup.

**Solution:**
```kotlin
// Ensure engine is initialized before setting up APIs
val flutterEngine = FlutterEngineManager.initializeFlutterEngine(this)
setupPigeonApis(flutterEngine)
```

#### 2. Black Screen on iOS
**Cause:** FlutterEngine not started or view not attached.

**Solution:**
```swift
// Ensure engine is running
let engine = FlutterEngine(name: "flutter_reels")
engine.run()

// Use engine in view controller
let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
```

#### 3. Token Callback Not Working
**Cause:** Callback not properly implemented or timing issue.

**Solution:**
```kotlin
// Android - ensure callback is called
override fun getAccessToken(callback: Messages.TokenCallback) {
    try {
        val token = getToken()
        callback.onTokenReceived(token)
    } catch (e: Exception) {
        callback.onTokenError(e.message ?: "Unknown error")
    }
}
```

#### 4. Navigation Events Not Firing
**Cause:** API listener not setup.

**Solution:**
```kotlin
// Ensure navigation API is setup
FlutterReelsNavigationApi.setUp(messenger, NavigationHandler())
```

### Debug Tips

1. **Enable Flutter Logging:**
   ```dart
   debugPrint('Event: $eventName');
   ```

2. **Check Platform Channels:**
   ```kotlin
   // Android
   Log.d("FlutterReels", "Channel message: $message")
   ```
   
   ```swift
   // iOS
   print("FlutterReels: Channel message: \(message)")
   ```

3. **Verify Pigeon Generation:**
   ```bash
   dart run pigeon --input pigeon/messages.dart
   ```

---

## Next Steps

1. Review the [Pigeon README](../pigeon/README.md) for API details
2. Check the [examples](../examples/) directory for sample integrations
3. Read the [main README](../README.md) for Flutter-specific setup
4. Join our community for support and updates

---

**Need Help?** 
- File an issue on GitHub
- Check existing issues for solutions
- Review the example projects
