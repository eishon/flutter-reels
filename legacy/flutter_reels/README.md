# Flutter Reels Module

A production-ready Flutter module that provides a modern, full-screen vertical video reels experience (similar to popular social media platforms). This module can be seamlessly integrated into native Android and iOS applications.

## 📱 Features

### Core Functionality
- ✅ **Vertical scrolling reels** - Smooth PageView with full-screen videos
- ✅ **Auto-play videos** - Automatic playback when video becomes visible
- ✅ **Video controls** - Tap to pause/play, automatic looping
- ✅ **Engagement buttons** - Like, share, and more options
- ✅ **User interactions** - Comments, products, and social features
- ✅ **Pull-to-refresh** - Easy content refresh
- ✅ **Loading states** - Proper loading, error, and empty states

### Technical Features
- ✅ **Clean Architecture** - Domain, Data, and Presentation layers
- ✅ **State Management** - Provider pattern with ChangeNotifier
- ✅ **Dependency Injection** - Get_it for service location
- ✅ **Video Playback** - video_player with Chewie integration
- ✅ **Portrait-only mode** - Optimized for vertical viewing
- ✅ **Dark theme** - Immersive video viewing experience
- ✅ **Comprehensive tests** - 251 tests covering all layers
- ✅ **Ready for native integration** - Android and iOS

### UI Components
- Full-screen video player with gradient overlays
- Animated engagement buttons (like, share, products)
- User profile with follow button
- Expandable video descriptions
- Comments modal with bottom sheet
- Products showcase for e-commerce
- More options menu (Report, Not Interested, Save)

## 🚀 Integration Guide

### For Android (Native)

#### Prerequisites
- Android Studio
- Minimum SDK: 21 (Android 5.0)
- Gradle 7.0 or higher

#### Step 1: Add Flutter Module as Dependency

There are three methods to integrate the Flutter module:

##### Method A: Using Gradle Dependency (Recommended - Easiest)

1. Update your `settings.gradle` (or `settings.gradle.kts`):
   ```gradle
   dependencyResolutionManagement {
       repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
       repositories {
           google()
           mavenCentral()
           
           // Flutter repository
           maven {
               url 'https://storage.googleapis.com/download.flutter.io'
           }
           
           // Flutter Reels repository
           maven {
               url 'https://raw.githubusercontent.com/eishon/flutter-reels/releases/'
           }
       }
   }
   ```

2. Update your `app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 33
       
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 33
       }
       
       compileOptions {
           sourceCompatibility JavaVersion.VERSION_1_8
           targetCompatibility JavaVersion.VERSION_1_8
       }
   }

   dependencies {
       // Flutter Reels module
       implementation 'com.github.eishon:flutter_reels:0.0.1'
       
       // Required for Flutter
       implementation 'androidx.appcompat:appcompat:1.6.1'
       implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.1'
   }
   ```

3. Sync your project with Gradle files

That's it! The AAR will be automatically downloaded and integrated.

##### Method B: Using AAR File Manually

1. Download the latest AAR from the [Releases](https://github.com/eishon/flutter-reels/releases) page

2. Add the AAR to your Android project:
   ```
   your-android-app/
     app/
       libs/
         flutter_reels-release.aar  // Place the AAR here
   ```

3. Update your `app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 33
       
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 33
       }
       
       compileOptions {
           sourceCompatibility JavaVersion.VERSION_1_8
           targetCompatibility JavaVersion.VERSION_1_8
       }
   }

   dependencies {
       implementation fileTree(dir: 'libs', include: ['*.aar'])
       
       // Required for Flutter
       implementation 'androidx.appcompat:appcompat:1.6.1'
       implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.1'
   }
   ```

4. Update your `settings.gradle`:
   ```gradle
   dependencyResolutionManagement {
       repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
       repositories {
           google()
           mavenCentral()
           maven {
               url 'https://storage.googleapis.com/download.flutter.io'
           }
       }
   }
   ```

##### Method C: Using Source (For Development)

1. Clone this repository next to your Android project:
   ```
   your-projects/
     flutter-reels/
       flutter_reels/
     your-android-app/
   ```

2. Update your `settings.gradle`:
   ```gradle
   setBinding(new Binding([gradle: this]))
   evaluate(new File(
       settingsDir.parentFile,
       'flutter-reels/flutter_reels/.android/include_flutter.groovy'
   ))

   include ':app'
   ```

3. Update your `app/build.gradle`:
   ```gradle
   dependencies {
       implementation project(':flutter')
   }
   ```

#### Step 2: Add Flutter Activity to Your App

##### For Kotlin:

```kotlin
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Launch Flutter module
        findViewById<Button>(R.id.launchFlutterButton).setOnClickListener {
            startActivity(
                FlutterActivity.createDefaultIntent(this)
            )
        }
    }
}
```

##### For Java:

```java
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Launch Flutter module
        findViewById(R.id.launchFlutterButton).setOnClickListener(v -> {
            startActivity(
                FlutterActivity.createDefaultIntent(this)
            );
        });
    }
}
```

#### Step 3: Update AndroidManifest.xml

Add the Flutter activity to your `AndroidManifest.xml`:

```xml
<application>
    <!-- Your existing activities -->
    
    <activity
        android:name="io.flutter.embedding.android.FlutterActivity"
        android:theme="@style/LaunchTheme"
        android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
        android:hardwareAccelerated="true"
        android:windowSoftInputMode="adjustResize"
        />
</application>
```

---

### For iOS (Native)

#### Prerequisites
- Xcode 14.0 or higher
- CocoaPods 1.10 or higher
- iOS 12.0 or higher

#### Step 1: Add Flutter Module

There are three methods to integrate the Flutter module:

##### Method A: Using CocoaPods (Recommended - Easiest)

1. Add to your `Podfile`:
   ```ruby
   # Add Flutter Reels specs source
   source 'https://github.com/eishon/flutter-reels.git'
   source 'https://cdn.cocoapods.org/'
   
   platform :ios, '12.0'

   target 'YourApp' do
     use_frameworks!
     
     # Flutter Reels module - just one line!
     pod 'FlutterReels', '~> 0.0.1'
   end
   
   post_install do |installer|
     installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
       end
     end
   end
   ```

2. Install the pod:
   ```bash
   pod install
   ```

3. Open the `.xcworkspace` file (not `.xcodeproj`):
   ```bash
   open YourApp.xcworkspace
   ```

That's it! The frameworks will be automatically downloaded and integrated.

##### Method B: Using Framework Files Manually

1. Download the latest iOS framework from the [Releases](https://github.com/eishon/flutter-reels/releases) page

2. Create a `Flutter` folder in your iOS project:
   ```
   your-ios-app/
     Flutter/
       Flutter.xcframework
       App.xcframework
   ```

3. In Xcode, add the frameworks to your project:
   - Select your project in the navigator
   - Select your target
   - Go to "General" tab → "Frameworks, Libraries, and Embedded Content"
   - Click "+" and add both `.xcframework` files
   - Set "Embed & Sign" for both frameworks

4. Update your Build Settings:
   - Build Settings → Framework Search Paths: `$(PROJECT_DIR)/Flutter`

##### Method B: Using Source (For Development)

1. Clone this repository next to your iOS project:
   ```
   your-projects/
     flutter-reels/
       flutter_reels/
     your-ios-app/
   ```

2. Create/update your `Podfile`:
   ```ruby
   platform :ios, '12.0'

   flutter_application_path = '../flutter-reels/flutter_reels'
   load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

   target 'YourApp' do
     use_frameworks!
     install_all_flutter_pods(flutter_application_path)
   end

   post_install do |installer|
     flutter_post_install(installer) if defined?(flutter_post_install)
   end
   ```

3. Run:
   ```bash
   pod install
   ```

#### Step 2: Add Flutter View Controller

##### For Swift:

```swift
import UIKit
import Flutter

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func launchFlutterModule(_ sender: UIButton) {
        let flutterEngine = FlutterEngine(name: "flutter_reels_engine")
        flutterEngine.run()
        
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        present(flutterViewController, animated: true, completion: nil)
    }
}
```

##### For Objective-C:

```objective-c
#import <Flutter/Flutter.h>
#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)launchFlutterModule:(UIButton *)sender {
    FlutterEngine *flutterEngine = [[FlutterEngine alloc] initWithName:@"flutter_reels_engine"];
    [flutterEngine run];
    
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] 
                                                    initWithEngine:flutterEngine 
                                                    nibName:nil 
                                                    bundle:nil];
    
    [self presentViewController:flutterViewController animated:YES completion:nil];
}

@end
```

#### Step 3: Update Info.plist

Add the following to your `Info.plist`:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

---

## 🔧 Development

### Running the Module Standalone

You can run the Flutter module standalone for development:

```bash
cd flutter_reels
flutter run
```

### Building for Release

#### Android AAR:
```bash
cd flutter_reels
flutter build aar
```

The AAR will be generated at:
```
flutter_reels/build/host/outputs/repo/com/example/flutter_reels/flutter_release/1.0/
```

#### iOS Framework:
```bash
cd flutter_reels
flutter build ios-framework
```

The frameworks will be generated at:
```
flutter_reels/build/ios/framework/Release/
```

---

## � Usage Guide

### Understanding the Reels Experience

Once integrated, the Flutter Reels module provides a full-screen, immersive video viewing experience:

#### User Interface Components

1. **Full-Screen Video Player**
   - Auto-plays when visible
   - Tap to pause/play
   - Automatic looping
   - Smooth video transitions

2. **User Profile Section** (Bottom Left)
   - Circular avatar
   - Username with @ prefix
   - Follow button
   - Expandable description text
   - Audio/music attribution

3. **Engagement Buttons** (Right Side)
   - ❤️ **Like button**: Animated heart with count
   - 🔗 **Share button**: Share functionality with count
   - 🛍️ **Product button**: Shows tagged products (if available)
   - ⋮ **More options**: Opens menu with:
     - 💬 Comments (with count)
     - 🚩 Report
     - 🚫 Not Interested
     - 🔖 Save

4. **Navigation**
   - Swipe up/down to navigate between videos
   - Pull down to refresh content

### Data Format

The module expects video data in JSON format. Example structure:

```json
{
  "videos": [
    {
      "id": "video_1",
      "url": "https://example.com/video1.mp4",
      "title": "Amazing Video Title",
      "description": "This is an amazing video description with #hashtags",
      "quality": "1080p",
      "likes": 12500,
      "comments": 342,
      "shares": 89,
      "isLiked": false,
      "user": {
        "name": "John Doe",
        "avatarUrl": "https://example.com/avatar.jpg"
      },
      "products": [
        {
          "id": "prod_1",
          "name": "Cool Product",
          "price": "99.99",
          "currency": "$",
          "discountPrice": "79.99",
          "rating": 4.5
        }
      ]
    }
  ]
}
```

### Customizing Data Source

Currently, the module uses mock data from `assets/mock_videos.json`. To integrate your own data:

#### Option 1: Replace Mock Data File

1. Update `flutter_reels/assets/mock_videos.json` with your video data
2. Rebuild the module

#### Option 2: Implement Platform Channels (Advanced)

For dynamic data from native side:

**Flutter Side** (`lib/data/datasources/video_local_data_source.dart`):
```dart
// Modify to use MethodChannel
import 'package:flutter/services.dart';

class VideoLocalDataSource {
  static const platform = MethodChannel('com.example.flutter_reels/videos');
  
  Future<List<VideoModel>> getVideos() async {
    try {
      final String jsonString = await platform.invokeMethod('getVideos');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => VideoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load videos from native: $e');
    }
  }
}
```

**Android Side** (Kotlin):
```kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter_reels/videos"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getVideos") {
                    val videosJson = getVideosFromYourBackend()
                    result.success(videosJson)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getVideosFromYourBackend(): String {
        // Your logic to fetch videos from API/database
        return """{"videos": [...]}"""
    }
}
```

**iOS Side** (Swift):
```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let videosChannel = FlutterMethodChannel(
            name: "com.example.flutter_reels/videos",
            binaryMessenger: controller.binaryMessenger
        )
        
        videosChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getVideos" {
                let videosJson = self.getVideosFromYourBackend()
                result(videosJson)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getVideosFromYourBackend() -> String {
        // Your logic to fetch videos from API/database
        return """{"videos": [...]}"""
    }
}
```

### Handling User Actions

You can listen to user interactions from the native side:

**Setup Callbacks (Flutter):**
```dart
// In video_provider.dart or create a new channel
static const eventChannel = EventChannel('com.example.flutter_reels/events');

void setupCallbacks() {
  eventChannel.receiveBroadcastStream().listen((event) {
    // Handle events from Flutter
  });
}

// Send events to native
void onVideoLiked(String videoId) {
  platform.invokeMethod('onVideoLiked', {'videoId': videoId});
}

void onVideoShared(String videoId) {
  platform.invokeMethod('onVideoShared', {'videoId': videoId});
}

void onProductClicked(String productId) {
  platform.invokeMethod('onProductClicked', {'productId': productId});
}
```

**Listen on Android:**
```kotlin
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    .setMethodCallHandler { call, result ->
        when (call.method) {
            "onVideoLiked" -> {
                val videoId = call.argument<String>("videoId")
                handleVideoLike(videoId)
                result.success(null)
            }
            "onVideoShared" -> {
                val videoId = call.argument<String>("videoId")
                handleVideoShare(videoId)
                result.success(null)
            }
            "onProductClicked" -> {
                val productId = call.argument<String>("productId")
                handleProductClick(productId)
                result.success(null)
            }
        }
    }
```

### Theming and Customization

The module uses a dark theme optimized for video viewing:
- Black background for immersive experience
- White text with shadows for visibility
- Transparent status bar
- Portrait-only orientation

To customize colors, modify `lib/main.dart`:
```dart
theme: ThemeData(
  primarySwatch: Colors.blue,
  useMaterial3: true,
  brightness: Brightness.dark,
  // Add your custom theme colors
),
```

---

## �📦 Automated Releases

This repository includes GitHub Actions workflows that automatically build and publish releases:

1. **Android Build**: Generates AAR files for Android integration
2. **iOS Build**: Generates XCFramework files for iOS integration
3. **Release Publishing**: Creates GitHub releases with downloadable artifacts

To trigger a release:
1. Push a tag: `git tag v1.0.0 && git push origin v1.0.0`
2. GitHub Actions will automatically build and create a release

---

## 🏗️ Architecture

The module follows **Clean Architecture** principles with three distinct layers:

### 1. Domain Layer (`lib/domain/`)
Pure business logic with no external dependencies.

```
domain/
├── entities/          # Core business models
│   ├── video_entity.dart
│   ├── user_entity.dart
│   └── product_entity.dart
├── repositories/      # Repository interfaces
│   └── video_repository.dart
└── usecases/         # Business use cases
    ├── get_videos_usecase.dart
    ├── get_video_by_id_usecase.dart
    ├── toggle_like_usecase.dart
    └── increment_share_count_usecase.dart
```

### 2. Data Layer (`lib/data/`)
Data handling and external dependencies.

```
data/
├── models/           # Data models with JSON serialization
│   ├── video_model.dart
│   ├── user_model.dart
│   └── product_model.dart
├── datasources/      # Data sources
│   └── video_local_data_source.dart
└── repositories/     # Repository implementations
    └── video_repository_impl.dart
```

### 3. Presentation Layer (`lib/presentation/`)
UI and state management.

```
presentation/
├── screens/          # Screen widgets
│   └── reels_screen.dart
├── widgets/          # Reusable widgets
│   ├── video_reel_item.dart
│   ├── video_player_widget.dart
│   ├── engagement_buttons.dart
│   └── video_description.dart
└── providers/        # State management
    └── video_provider.dart
```

### 4. Core Layer (`lib/core/`)
Cross-cutting concerns.

```
core/
├── di/              # Dependency injection
│   └── injection_container.dart
├── error/           # Error handling
│   └── failures.dart
└── utils/           # Utilities
    └── constants.dart
```

### Dependencies

```yaml
dependencies:
  # Video playback
  video_player: ^2.8.7
  chewie: ^1.8.5
  visibility_detector: ^0.4.0+2
  
  # State management
  provider: ^6.1.2
  
  # Dependency injection
  get_it: ^7.6.7

dev_dependencies:
  # Testing
  flutter_test:
  mockito: ^5.4.4
  build_runner: ^2.4.8
```

---

## � Testing

The module includes comprehensive test coverage (251 tests):

### Run All Tests
```bash
cd flutter_reels
flutter test
```

### Test Coverage by Layer

- **Domain Layer (75 tests)**
  - Entity tests: 44 tests
  - Use case tests: 31 tests

- **Data Layer (100 tests)**
  - Model tests: 61 tests
  - Data source tests: 27 tests
  - Repository tests: 12 tests

- **Presentation Layer (40 tests)**
  - Provider tests: 24 tests
  - Widget tests: 16 tests

- **Core Layer (15 tests)**
  - Dependency injection tests: 15 tests

- **Integration Tests (20 tests)**
  - End-to-end flow tests: 20 tests

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🔍 Troubleshooting

### Common Issues

#### Android

**Issue: "Flutter module not found"**
```
Solution: Ensure you've added the Flutter repository to your settings.gradle:
maven {
    url 'https://storage.googleapis.com/download.flutter.io'
}
```

**Issue: "Minimum SDK version error"**
```
Solution: Update your app/build.gradle:
android {
    defaultConfig {
        minSdkVersion 21  // Flutter requires minimum SDK 21
    }
}
```

**Issue: "Duplicate class errors"**
```
Solution: Clean and rebuild:
./gradlew clean
./gradlew build
```

**Issue: "FlutterActivity not found"**
```
Solution: Ensure you have the correct import:
import io.flutter.embedding.android.FlutterActivity
```

#### iOS

**Issue: "Framework not found Flutter"**
```
Solution: Make sure you're opening the .xcworkspace file, not .xcodeproj
```

**Issue: "Unsupported architectures"**
```
Solution: Add to your Podfile:
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
```

**Issue: "CocoaPods could not find compatible versions"**
```
Solution: Update your CocoaPods:
pod repo update
pod install --repo-update
```

#### Video Playback

**Issue: "Videos not playing"**
```
Solution: Check the video URL format and network connectivity.
- Ensure URLs use https:// protocol
- Check if videos are accessible from the device
- Verify video codec compatibility (H.264 recommended)
```

**Issue: "Video player shows black screen"**
```
Solution: 
- Check video URL validity
- Ensure proper video format (MP4 with H.264 codec)
- Verify network permissions in AndroidManifest.xml/Info.plist
```

### Debug Mode

Enable debug logging by modifying `lib/presentation/providers/video_provider.dart`:

```dart
// Add at the top of the class
static const bool _debugMode = true;

void debugLog(String message) {
  if (_debugMode) {
    debugPrint('[FlutterReels] $message');
  }
}
```

---

## 📱 Platform Requirements

### Android
- **Minimum SDK**: 21 (Android 5.0 Lollipop)
- **Target SDK**: 33 (Android 13)
- **Compile SDK**: 33
- **Java**: 8 or higher
- **Kotlin**: 1.7.0 or higher

### iOS
- **Minimum iOS**: 12.0
- **Xcode**: 14.0 or higher
- **Swift**: 5.0 or higher
- **CocoaPods**: 1.10 or higher

---

## 🚀 Performance Optimization

### Video Loading
- Videos are loaded on-demand
- Only the visible video is played
- Previous/next videos are preloaded for smooth scrolling

### Memory Management
- Automatic video controller disposal
- Proper cleanup on page change
- Optimized image loading with caching

### Best Practices
1. Use appropriate video resolution (1080p recommended)
2. Compress videos before uploading
3. Use CDN for video delivery
4. Implement pagination for large video feeds
5. Cache video metadata locally

---

## �🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Flutter's style guide
- Run `flutter analyze` before committing
- Ensure all tests pass (`flutter test`)
- Add tests for new features

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 💬 Support

For issues, questions, or suggestions:

- 📧 Email: support@example.com
- 🐛 [Report Bugs](https://github.com/eishon/flutter-reels/issues)
- 💡 [Request Features](https://github.com/eishon/flutter-reels/issues)
- 📖 [Documentation](https://github.com/eishon/flutter-reels/wiki)

---

## 🙏 Acknowledgments

Built with:
- [Flutter](https://flutter.dev/) - UI framework
- [video_player](https://pub.dev/packages/video_player) - Video playback
- [Chewie](https://pub.dev/packages/chewie) - Video player UI
- [Provider](https://pub.dev/packages/provider) - State management
- [Get_it](https://pub.dev/packages/get_it) - Dependency injection

---

**Made with ❤️ using Flutter**

Version: 0.0.3  
Last Updated: October 2025
