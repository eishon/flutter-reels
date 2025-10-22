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

**No!** Pigeon is only used internally for platform communication. The native SDKs provide clean, type-safe APIs that hide all Pigeon complexity.

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
