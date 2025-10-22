# Flutter Reels - Integration Guide

## Architecture Overview

Flutter Reels uses a **hybrid Add-to-App architecture (Option C)** that provides clean native APIs while leveraging Flutter's capabilities:

```
User's Native App
        ↓
   Native SDK (reels_android / reels_ios)
        ↓ [hides complexity]
   Flutter Engine + Pigeon
        ↓
   reels_flutter Module (UI)
```

**Key Benefits:**
- ✅ Users get clean, native-feeling APIs
- ✅ No need to understand Flutter or Pigeon
- ✅ Standard Android/iOS development patterns
- ✅ Type-safe communication via Pigeon (hidden)

---

## Android Integration

### Step 1: Add to settings.gradle

```gradle
// settings.gradle
include ':app'

// Include Reels Android SDK
include ':reels_android'
project(':reels_android').projectDir = file('../path/to/reels_android')

// Include Flutter module (Add-to-App)
setBinding(new Binding([gradle: this]))
evaluate(new File('../path/to/reels_flutter/.android/include_flutter.groovy'))
```

### Step 2: Add dependencies

```gradle
// app/build.gradle
dependencies {
    implementation project(':reels_android')
    implementation project(':flutter')  // Added by include_flutter.groovy
    
    // Your other dependencies
}
```

### Step 3: Use the SDK

```kotlin
import com.eishon.reels_android.*

class MainActivity : AppCompatActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize SDK
        ReelsAndroidSDK.initialize(
            context = this,
            config = ReelsConfig(
                autoPlay = true,
                showControls = true,
                loopVideos = true
            )
        )
        
        // Set event listener
        ReelsAndroidSDK.setListener(object : ReelsListener {
            override fun onReelViewed(videoId: String) {
                Log.d(TAG, "Viewed: $videoId")
            }
            
            override fun onReelLiked(videoId: String, isLiked: Boolean) {
                Log.d(TAG, "Liked: $videoId")
            }
            
            override fun onReelShared(videoId: String) {
                Log.d(TAG, "Shared: $videoId")
            }
        })
        
        // Show reels
        val videos = listOf(
            VideoInfo(
                id = "1",
                url = "https://example.com/video1.mp4",
                title = "My Video",
                thumbnailUrl = "https://example.com/thumb1.jpg"
            )
        )
        ReelsAndroidSDK.showReels(videos)
    }
    
    override fun onDestroy() {
        super.onDestroy()
        ReelsAndroidSDK.dispose()
    }
}
```

### Android API Reference

#### ReelsAndroidSDK

```kotlin
// Initialize SDK
fun initialize(context: Context, config: ReelsConfig = ReelsConfig())

// Show reels
fun showReels(videos: List<VideoInfo>)

// Update video data
fun updateVideo(video: VideoInfo)

// Close reels
fun closeReels()

// Update configuration
fun updateConfig(config: ReelsConfig)

// Set event listener
fun setListener(listener: ReelsListener?)

// Clean up
fun dispose()
```

#### Data Classes

```kotlin
data class ReelsConfig(
    val autoPlay: Boolean = true,
    val showControls: Boolean = true,
    val loopVideos: Boolean = true
)

data class VideoInfo(
    val id: String,
    val url: String,
    val thumbnailUrl: String? = null,
    val title: String? = null,
    val description: String? = null,
    val authorName: String? = null,
    val authorAvatarUrl: String? = null,
    val likeCount: Int = 0,
    val commentCount: Int = 0,
    val shareCount: Int = 0,
    val isLiked: Boolean = false
)
```

#### ReelsListener

```kotlin
interface ReelsListener {
    fun onReelViewed(videoId: String) {}
    fun onReelLiked(videoId: String, isLiked: Boolean) {}
    fun onReelShared(videoId: String) {}
    fun onReelCommented(videoId: String) {}
    fun onProductClicked(productId: String, videoId: String) {}
    fun onReelsClosed() {}
    fun onError(errorMessage: String) {}
    fun getAccessToken(): String? = null
}
```

---

## iOS Integration

### Step 1: Create/Update Podfile

```ruby
platform :ios, '12.0'

# Flutter Add-to-App setup
flutter_application_path = '../path/to/reels_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'YourApp' do
  use_frameworks!

  # Reels iOS SDK
  pod 'ReelsIOS', :path => '../path/to/reels_ios'
  
  # Install Flutter and plugins
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end
```

### Step 2: Install Pods

```bash
cd ios
pod install
```

### Step 3: Use the SDK

```swift
import ReelsIOS

class AppDelegate: UIResponder, UIApplicationDelegate, ReelsDelegate {
    
    func application(_ application: UIApplication, 
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize SDK
        let config = ReelsConfig(autoPlay: true, showControls: true, loopVideos: true)
        ReelsIOSSDK.shared.initialize(config: config)
        ReelsIOSSDK.shared.delegate = self
        
        return true
    }
    
    // MARK: - ReelsDelegate
    
    func onReelViewed(videoId: String) {
        print("Viewed: \(videoId)")
    }
    
    func onReelLiked(videoId: String, isLiked: Bool) {
        print("Liked: \(videoId)")
    }
    
    func onReelShared(videoId: String) {
        print("Shared: \(videoId)")
    }
}

// Show reels
let videos = [
    VideoInfo(
        id: "1",
        url: "https://example.com/video1.mp4",
        title: "My Video",
        thumbnailUrl: "https://example.com/thumb1.jpg"
    )
]

try? ReelsIOSSDK.shared.showReels(videos: videos)
```

### iOS API Reference

#### ReelsIOSSDK

```swift
// Initialize SDK
func initialize(config: ReelsConfig = ReelsConfig())

// Show reels
func showReels(videos: [VideoInfo]) throws

// Update video data
func updateVideo(video: VideoInfo) throws

// Close reels
func closeReels() throws

// Update configuration
func updateConfig(config: ReelsConfig) throws

// Set delegate
var delegate: ReelsDelegate?

// Clean up
func dispose()
```

#### Data Classes

```swift
class ReelsConfig {
    init(autoPlay: Bool = true, showControls: Bool = true, loopVideos: Bool = true)
}

class VideoInfo {
    init(
        id: String,
        url: String,
        thumbnailUrl: String? = nil,
        title: String? = nil,
        description: String? = nil,
        authorName: String? = nil,
        authorAvatarUrl: String? = nil,
        likeCount: Int = 0,
        commentCount: Int = 0,
        shareCount: Int = 0,
        isLiked: Bool = false
    )
}
```

#### ReelsDelegate

```swift
protocol ReelsDelegate: AnyObject {
    func onReelViewed(videoId: String)
    func onReelLiked(videoId: String, isLiked: Bool)
    func onReelShared(videoId: String)
    func onReelCommented(videoId: String)
    func onProductClicked(productId: String, videoId: String)
    func onReelsClosed()
    func onError(errorMessage: String)
    func getAccessToken() -> String?
}
```

---

## Requirements

### Android
- Android SDK 21+ (Android 5.0+)
- Compile SDK 34
- Kotlin 1.9.0+
- Java 17
- Gradle 8.0+
- Flutter SDK (required for building, not runtime)

### iOS
- iOS 12.0+
- Swift 5.0+
- CocoaPods
- Xcode 14.0+
- Flutter SDK (required for building, not runtime)

---

## Architecture Details

### Why Add-to-App?

1. **Reliability**: Flutter's officially supported approach
2. **No AAR build issues**: Avoids `flutter build aar` problems
3. **Easier debugging**: Direct access to Flutter code
4. **Automatic updates**: Flutter dependencies managed automatically

### What Users Don't See

The native SDKs (reels_android / reels_ios) hide:
- Flutter engine initialization
- Pigeon API setup
- Method channel communication
- Binary messenger configuration
- Dart entry point execution

Users just call simple methods like `ReelsAndroidSDK.showReels(videos)`!

### Communication Flow

```
User calls: ReelsAndroidSDK.showReels(videos)
    ↓
ReelsAndroidSDK converts VideoInfo → Pigeon VideoData
    ↓
Pigeon sends via Method Channel
    ↓
Flutter receives via ReelsFlutterApi
    ↓
Flutter renders reels UI
    ↓
User interacts (likes, shares)
    ↓
Flutter calls ReelsNativeApi via Pigeon
    ↓
ReelsAndroidSDK receives callback
    ↓
ReelsListener.onReelLiked() called
    ↓
User's app handles event
```

---

## Example Projects

See `example/android` and `example/ios` for complete working examples.

---

## Troubleshooting

### Android

**Issue**: Cannot find `:flutter` project
**Solution**: Ensure `include_flutter.groovy` is evaluated in settings.gradle

**Issue**: Flutter engine crash
**Solution**: Check that Flutter SDK is properly installed and PATH is set

### iOS

**Issue**: Module 'Flutter' not found
**Solution**: Run `pod install` after adding to Podfile

**Issue**: Build fails with architecture errors
**Solution**: Clean build folder: Product → Clean Build Folder

---

## Publishing

This SDK is distributed as source code via GitHub. Users integrate it using Add-to-App pattern.

To use in your project:
1. Clone or download the repository
2. Follow integration steps above
3. Point paths to your local copy

---

## License

[Your License Here]

## Support

- GitHub Issues: https://github.com/eishon/flutter-reels/issues
- Email: [Your Email]
