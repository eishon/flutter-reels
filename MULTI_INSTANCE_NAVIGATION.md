# Multi-Instance Navigation Support

This guide explains how to implement complex navigation patterns including NATIVE→FLUTTER→NATIVE→FLUTTER→NATIVE.

## Overview

The current Flutter Reels implementation supports single-instance navigation. To enable multi-instance patterns, you need to:

1. Use multiple FlutterEngine instances
2. Implement platform-specific navigation handlers
3. Manage the navigation stack on native side

## Architecture Patterns

### Pattern 1: Single Engine, Native Stack Management (Recommended)

**Flow:** NATIVE → FLUTTER → NATIVE → FLUTTER (back to same instance)

```
[Native Activity/ViewController]
    ↓ opens
[Flutter Reels Screen] (FlutterEngine #1)
    ↓ triggers native navigation
[Native Profile Screen]
    ↓ opens
[Flutter Reels Screen] (Same FlutterEngine #1)
```

**Pros:**
- Memory efficient
- Faster navigation
- Shared state

**Cons:**
- Same Flutter screen reused
- Cannot show multiple Flutter screens simultaneously

### Pattern 2: Multiple Engines (Advanced)

**Flow:** NATIVE → FLUTTER#1 → NATIVE → FLUTTER#2 → NATIVE

```
[Native Activity/ViewController]
    ↓ opens
[Flutter Reels Screen] (FlutterEngine #1)
    ↓ triggers native navigation
[Native Profile Screen]
    ↓ opens
[Flutter Comments Screen] (FlutterEngine #2)
    ↓ dismisses
[Back to Native Profile]
```

**Pros:**
- Multiple Flutter screens simultaneously
- Independent state
- True multi-instance

**Cons:**
- Higher memory usage (~40MB per engine)
- Slower initialization
- More complex state management

---

## Implementation Guide

### Android Implementation

#### Option 1: Single Engine with Navigation (Recommended)

```kotlin
// FlutterEngineManager.kt
object FlutterEngineManager {
    private var flutterEngine: FlutterEngine? = null
    
    fun getOrCreateEngine(context: Context): FlutterEngine {
        return flutterEngine ?: FlutterEngine(context).also {
            it.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            flutterEngine = it
        }
    }
    
    fun getEngine(): FlutterEngine? = flutterEngine
}

// NavigationHandler.kt
class NavigationHandler(
    private val activity: Activity
) : FlutterReelsNavigationApi {
    
    override fun onSwipeLeft() {
        // Open native profile screen
        val intent = Intent(activity, ProfileActivity::class.java)
        activity.startActivity(intent)
    }
    
    override fun onSwipeRight() {
        // Go back to previous native screen
        activity.finish()
    }
}

// ReelsActivity.kt
class ReelsActivity : FlutterActivity() {
    companion object {
        const val ENGINE_ID = "flutter_reels_engine"
        
        fun launch(context: Context, videoId: String? = null) {
            val intent = Intent(context, ReelsActivity::class.java).apply {
                videoId?.let { putExtra("video_id", it) }
            }
            context.startActivity(intent)
        }
    }
    
    override fun getCachedEngineId(): String = ENGINE_ID
    
    override fun shouldDestroyEngineWithHost(): Boolean = false
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Handle navigation back from native screen
        intent.getStringExtra("video_id")?.let { videoId ->
            // Navigate to specific video via method channel
            navigateToVideo(videoId)
        }
    }
}

// ProfileActivity.kt (Native Screen)
class ProfileActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)
        
        // Button to open Flutter Reels again
        findViewById<Button>(R.id.btnViewVideos).setOnClickListener {
            ReelsActivity.launch(this, videoId = "profile_video_123")
        }
    }
}

// MainActivity.kt (Entry Point)
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize Flutter engine once
        val engine = FlutterEngineManager.getOrCreateEngine(this)
        FlutterEngineCache.getInstance().put(ReelsActivity.ENGINE_ID, engine)
        
        // Setup Pigeon APIs
        setupPigeonApis(engine)
        
        // Launch Flutter Reels
        findViewById<Button>(R.id.btnOpenReels).setOnClickListener {
            ReelsActivity.launch(this)
        }
    }
}
```

**Navigation Flow Example:**
```
MainActivity (Native)
    → ReelsActivity (Flutter) 
        → swipe left triggers onSwipeLeft()
            → ProfileActivity (Native)
                → click "View Videos"
                    → ReelsActivity (Flutter, same engine)
                        → swipe right triggers onSwipeRight()
                            → back to ProfileActivity (Native)
```

#### Option 2: Multiple Engines (Advanced)

```kotlin
// MultiEngineManager.kt
object MultiEngineManager {
    private val engines = mutableMapOf<String, FlutterEngine>()
    
    fun getOrCreateEngine(context: Context, engineId: String): FlutterEngine {
        return engines[engineId] ?: FlutterEngine(context).also {
            it.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            engines[engineId] = it
            FlutterEngineCache.getInstance().put(engineId, it)
        }
    }
    
    fun destroyEngine(engineId: String) {
        FlutterEngineCache.getInstance().remove(engineId)
        engines.remove(engineId)?.destroy()
    }
    
    fun destroyAllEngines() {
        engines.keys.toList().forEach { destroyEngine(it) }
    }
}

// ReelsActivity.kt (Multiple Engines)
class ReelsActivity : FlutterActivity() {
    companion object {
        fun launch(
            context: Context, 
            engineId: String = "reels_${System.currentTimeMillis()}",
            videoId: String? = null
        ) {
            // Create new engine for this instance
            MultiEngineManager.getOrCreateEngine(context, engineId)
            
            val intent = Intent(context, ReelsActivity::class.java).apply {
                putExtra("engine_id", engineId)
                videoId?.let { putExtra("video_id", it) }
            }
            context.startActivity(intent)
        }
    }
    
    private var engineId: String = ""
    
    override fun onCreate(savedInstanceState: Bundle?) {
        engineId = intent.getStringExtra("engine_id") ?: "default"
        super.onCreate(savedInstanceState)
    }
    
    override fun getCachedEngineId(): String = engineId
    
    override fun shouldDestroyEngineWithHost(): Boolean = true
    
    override fun onDestroy() {
        super.onDestroy()
        MultiEngineManager.destroyEngine(engineId)
    }
}
```

---

### iOS Implementation

#### Option 1: Single Engine (Recommended)

```swift
// FlutterEngineManager.swift
class FlutterEngineManager {
    static let shared = FlutterEngineManager()
    
    private var engine: FlutterEngine?
    
    private init() {}
    
    func getOrCreateEngine() -> FlutterEngine {
        if let engine = engine {
            return engine
        }
        
        let newEngine = FlutterEngine(name: "flutter_reels")
        newEngine.run()
        self.engine = newEngine
        return newEngine
    }
    
    func getEngine() -> FlutterEngine? {
        return engine
    }
}

// NavigationHandler.swift
class NavigationHandler: FlutterReelsNavigationApi {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func onSwipeLeft(completion: @escaping (Result<Void, Error>) -> Void) {
        // Open native profile screen
        let profileVC = ProfileViewController()
        viewController?.navigationController?.pushViewController(profileVC, animated: true)
        completion(.success(()))
    }
    
    func onSwipeRight(completion: @escaping (Result<Void, Error>) -> Void) {
        // Go back
        viewController?.navigationController?.popViewController(animated: true)
        completion(.success(()))
    }
}

// ReelsViewController.swift
class ReelsViewController: FlutterViewController {
    static func create(videoId: String? = nil) -> ReelsViewController {
        let engine = FlutterEngineManager.shared.getOrCreateEngine()
        let controller = ReelsViewController(engine: engine, nibName: nil, bundle: nil)
        
        if let videoId = videoId {
            // Navigate to specific video via method channel
            controller.navigateToVideo(videoId)
        }
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation handler
        if let engine = engine {
            let handler = NavigationHandler(viewController: self)
            FlutterReelsNavigationApiSetup.setUp(
                binaryMessenger: engine.binaryMessenger,
                api: handler
            )
        }
    }
    
    private func navigateToVideo(_ videoId: String) {
        // Use method channel to navigate
    }
}

// ProfileViewController.swift (Native Screen)
class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("View Videos", for: .normal)
        button.addTarget(self, action: #selector(openReels), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func openReels() {
        let reelsVC = ReelsViewController.create(videoId: "profile_video_123")
        navigationController?.pushViewController(reelsVC, animated: true)
    }
}

// AppDelegate.swift
@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize Flutter engine once
        let engine = FlutterEngineManager.shared.getOrCreateEngine()
        setupPigeonApis(binaryMessenger: engine.binaryMessenger)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

// ViewController.swift (Entry Point)
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("Open Reels", for: .normal)
        button.addTarget(self, action: #selector(openReels), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func openReels() {
        let reelsVC = ReelsViewController.create()
        navigationController?.pushViewController(reelsVC, animated: true)
    }
}
```

#### Option 2: Multiple Engines (Advanced)

```swift
// MultiEngineManager.swift
class MultiEngineManager {
    static let shared = MultiEngineManager()
    
    private var engines: [String: FlutterEngine] = [:]
    
    private init() {}
    
    func getOrCreateEngine(id: String) -> FlutterEngine {
        if let engine = engines[id] {
            return engine
        }
        
        let engine = FlutterEngine(name: id)
        engine.run()
        engines[id] = engine
        return engine
    }
    
    func destroyEngine(id: String) {
        engines[id]?.destroy()
        engines.removeValue(forKey: id)
    }
    
    func destroyAllEngines() {
        engines.keys.forEach { destroyEngine(id: $0) }
    }
}

// ReelsViewController.swift (Multiple Engines)
class ReelsViewController: FlutterViewController {
    private let engineId: String
    
    static func create(videoId: String? = nil) -> ReelsViewController {
        let engineId = "reels_\(Date().timeIntervalSince1970)"
        let engine = MultiEngineManager.shared.getOrCreateEngine(id: engineId)
        let controller = ReelsViewController(engine: engine, engineId: engineId)
        
        if let videoId = videoId {
            controller.navigateToVideo(videoId)
        }
        
        return controller
    }
    
    private init(engine: FlutterEngine, engineId: String) {
        self.engineId = engineId
        super.init(engine: engine, nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    deinit {
        MultiEngineManager.shared.destroyEngine(id: engineId)
    }
}
```

---

## Adding to Pigeon API

To better support native screen launching, you can extend the Pigeon API:

```dart
// pigeon/messages.dart

/// Add new navigation API methods
@FlutterApi()
abstract class FlutterReelsNavigationApi {
  void onSwipeLeft();
  void onSwipeRight();
  
  // NEW: Request to open native screen
  void openNativeScreen(NavigationRequest request);
}

/// NEW: Navigation request data
class NavigationRequest {
  NavigationRequest({
    required this.screenName,
    this.params,
  });
  
  final String screenName;  // e.g., "profile", "settings", "comments"
  final Map<String?, Object?>? params;
}
```

Then regenerate: `dart run pigeon --input pigeon/messages.dart`

---

## Memory Considerations

### Single Engine
- **Memory:** ~40-50MB per app
- **Startup:** Fast (engine stays warm)
- **Use Case:** Most apps, simple navigation

### Multiple Engines
- **Memory:** ~40-50MB **per engine**
- **Startup:** Slower (each engine initializes separately)
- **Use Case:** Complex apps needing isolated Flutter screens

**Recommendation:** Use single engine unless you specifically need:
- Multiple Flutter screens visible simultaneously
- Completely isolated Flutter contexts
- Different Flutter entry points

---

## Testing Multi-Instance Navigation

### Android Test
```kotlin
@Test
fun testMultiInstanceNavigation() {
    // Launch from native
    val reelsIntent = Intent(context, ReelsActivity::class.java)
    activityRule.launchActivity(reelsIntent)
    
    // Trigger swipe left (opens native)
    onView(withId(R.id.reelsView)).perform(swipeLeft())
    
    // Verify native screen opened
    assertThat(activity).isInstanceOf(ProfileActivity::class.java)
    
    // Go back to Flutter
    onView(withId(R.id.btnViewVideos)).perform(click())
    
    // Verify Flutter reels reopened
    assertThat(activity).isInstanceOf(ReelsActivity::class.java)
}
```

### iOS Test
```swift
func testMultiInstanceNavigation() {
    // Launch from native
    let reelsVC = ReelsViewController.create()
    navigationController.pushViewController(reelsVC, animated: false)
    
    // Trigger swipe left
    reelsVC.handleSwipeLeft()
    
    // Verify native screen opened
    XCTAssertTrue(navigationController.topViewController is ProfileViewController)
    
    // Go back to Flutter
    let profileVC = navigationController.topViewController as! ProfileViewController
    profileVC.openReels()
    
    // Verify Flutter reels reopened
    XCTAssertTrue(navigationController.topViewController is ReelsViewController)
}
```

---

## Summary

**Current Support:** ❌ Multi-instance not supported out of the box

**To Enable Multi-Instance:**
1. Implement navigation handlers as shown above
2. Choose single-engine (recommended) or multi-engine approach
3. Manage navigation stack on native side
4. Optionally extend Pigeon API for better control

**Recommended Approach:** 
- Use **single FlutterEngine** with native navigation stack management
- Flutter notifies native via `onSwipeLeft()`/`onSwipeRight()`
- Native opens/closes screens using standard navigation
- Reuse same Flutter engine for better performance

Would you like me to create a complete working example with the multi-instance navigation pattern?
