# Flutter Reels# Flutter Reels - Native SDK Integration



**Add reels/stories to your native Android and iOS apps** - powered by Flutter, used like native code! 🚀A Flutter-based reels library for native Android and iOS applications using the **Add-to-App** pattern with clean, native SDKs.



[![PR Verification](https://github.com/eishon/flutter-reels/actions/workflows/pr-verification.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/pr-verification.yml)[![PR Verification](https://github.com/eishon/flutter-reels/actions/workflows/pr-verification.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/pr-verification.yml)

[![Main Build](https://github.com/eishon/flutter-reels/actions/workflows/main-build.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/main-build.yml)[![Main Build](https://github.com/eishon/flutter-reels/actions/workflows/main-build.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/main-build.yml)

[![Android](https://img.shields.io/badge/Android-5.0%2B-green)]()[![Android](https://img.shields.io/badge/Android-5.0%2B-green)]()

[![iOS](https://img.shields.io/badge/iOS-13.0%2B-blue)]()[![iOS](https://img.shields.io/badge/iOS-13.0%2B-blue)]()

[![Flutter](https://img.shields.io/badge/Flutter-3.35.6-blue)]()[![Flutter](https://img.shields.io/badge/Flutter-3.35.6-blue)]()



---## Project Structure



## What is Flutter Reels?---



A **native SDK** for Android and iOS that adds Instagram/TikTok-style reels to your app. Built with Flutter's Add-to-App pattern, but you don't need to know Flutter - just use our clean native APIs!



### ✨ Key Features## 🎯 Features



- ✅ **Zero Flutter Knowledge Required** - Clean Kotlin/Swift APIs- ✅ **Clean Native APIs** - No Flutter or Pigeon knowledge required for users

- ✅ **Zero Pigeon Knowledge Required** - We handle platform communication- ✅ **Add-to-App Integration** - Flutter module embedded in native apps

- ✅ **Easy Integration** - Just add dependencies and go- ✅ **Type-Safe Communication** - Pigeon-based platform channels (hidden from users)

- ✅ **Native Feel** - Familiar development patterns for Android/iOS- ✅ **Android SDK** - Kotlin-based wrapper with idiomatic API

- ✅ **Type-Safe** - Full compile-time safety- ✅ **iOS SDK** - Swift-based wrapper with Objective-C compatibility

- ✅ **Well-Tested** - 329+ tests, 95%+ coverage- ✅ **CI/CD Ready** - Automated testing and build verification

- ✅ **CI/CD Ready** - Automated builds and verification- ✅ **Example Apps** - Complete integration examples for both platforms



### 🎥 What You Get## 📋 Overview



- Vertical video feed (TikTok/Instagram Reels style)A Flutter module designed to be integrated into native Android and iOS applications. This module provides a reels/stories viewing experience that can be seamlessly embedded in your existing native apps.

- Auto-play with smooth transitions

- Like, comment, and share interactions- ✅ **Example Apps** - Complete integration examples for both platforms├── reels_android/          # Android native SDK wrapper

- User profiles and product tagging

- Pull-to-refresh and swipe gestures

- Analytics tracking

- Deep linking support---├── reels_ios/              # iOS native SDK wrapper  This repository contains a Flutter module (`flutter_reels`) that can be distributed as a library for native Android and iOS projects. The module is built with native integration in mind and includes automated CI/CD pipelines for easy distribution.



---



## 🚀 Quick Start## 📁 Project Structure├── example/



**👉 See [ADD_TO_APP_GUIDE.md](./ADD_TO_APP_GUIDE.md) for complete integration instructions**



### Android (30 seconds setup)```│   ├── android/           # Android example app## 🚀 Quick Start



```gradleflutter-reels/

// settings.gradle

setBinding(new Binding([gradle: this]))├── reels_flutter/          # Flutter module with reels UI (Add-to-App)│   └── ios/               # iOS example app

evaluate(new File('../path/to/flutter-reels/reels_flutter/.android/include_flutter.groovy'))

├── reels_android/          # Android native SDK wrapper (Kotlin)

include ':reels_android'

project(':reels_android').projectDir = file('../path/to/flutter-reels/reels_android')├── reels_ios/              # iOS native SDK wrapper (Swift)└── legacy/                # Previous project version (archived)### For Integration

```

├── example/

```gradle

// app/build.gradle│   ├── android/           # Android integration example```

dependencies {

    implementation project(':reels_android')│   └── ios/               # iOS integration example

}

```├── legacy/                # Previous implementation (archived)Visit the [flutter_reels](./flutter_reels) directory for detailed integration instructions for both Android and iOS.



```kotlin└── docs/                  # Documentation

// MainActivity.kt

ReelsAndroidSDK.initialize(this, ReelsConfig(autoPlay = true))```## Architecture

ReelsAndroidSDK.showReels(videos)

```



### iOS (30 seconds setup)---**Quick Links:**



```ruby

# Podfile

flutter_application_path = '../path/to/flutter-reels/reels_flutter'## 🚀 Quick StartThe project follows a three-tier architecture:- [**🚀 Native Initialization Quick Start**](./NATIVE_INITIALIZATION.md) ⭐ **START HERE** (Step-by-step setup)

load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')



target 'YourApp' do

  install_all_flutter_pods(flutter_application_path)### For Users (Integrating the SDK)- [**Native Integration Guide**](./NATIVE_INTEGRATION.md) (Complete native platform integration)

  pod 'ReelsIOS', :path => '../path/to/flutter-reels/reels_ios'

end

```

**Choose your platform:**1. **reels_flutter**: Flutter module containing the core reels UI and logic- [**Pigeon API Documentation**](./reels_flutter/pigeons/README.md) (Platform communication APIs)

```swift

// AppDelegate.swift

ReelsIOSSDK.shared.initialize(config: ReelsConfig(autoPlay: true))

try? ReelsIOSSDK.shared.showReels(videos: videos)- **Android**: See [INTEGRATION_GUIDE.md#android](./INTEGRATION_GUIDE.md#android-integration)2. **reels_android / reels_ios**: Native wrapper SDKs that embed the Flutter module- [Android Integration Guide](./flutter_reels/README.md#for-android-native)

```

- **iOS**: See [INTEGRATION_GUIDE.md#ios](./INTEGRATION_GUIDE.md#ios-integration)

**That's it!** No Flutter commands, no complex setup. 🎉

3. **example apps**: Demonstration apps showing how to integrate the native SDKs- [iOS Integration Guide](./flutter_reels/README.md#for-ios-native)

---

### For Contributors (Building the Project)

## 📁 Repository Structure

- [Gradle Integration Guide](./GRADLE_INTEGRATION.md) (Android Dependency)

```

flutter-reels/**See [SETUP.md](./SETUP.md)** for complete build instructions and troubleshooting.

├── reels_android/          # 🤖 Android native SDK (Kotlin)

├── reels_ios/              # 🍎 iOS native SDK (Swift)### Communication Layer- [CocoaPods Integration Guide](./COCOAPODS_INTEGRATION.md) (iOS Dependency)

├── reels_flutter/          # 🎨 Flutter module (UI implementation)

├── example/---

│   ├── android/           # Android example app

│   └── ios/               # iOS example app- [Multi-Instance Navigation](./MULTI_INSTANCE_NAVIGATION.md) (Advanced navigation patterns)

└── legacy/                # Previous implementation (archived)

```## 📚 Documentation



### What's What?- **Pigeon**: Type-safe platform channel communication between Flutter and native code
  - See [Pigeon API Documentation](./reels_flutter/pigeons/README.md) for complete reference
  - Automatic code generation via GitHub Actions workflow- [GitHub Packages Setup](./GITHUB_PACKAGES_SETUP.md) (For Private Repository Access)



- **`reels_android` / `reels_ios`**: Native SDKs you integrate into your app| Document | Description |

- **`reels_flutter`**: Flutter module embedded by the native SDKs (you don't touch this directly)

- **`example/`**: Working examples showing integration|----------|-------------|- Native SDKs provide clean APIs for initialization and interaction



---| [**SETUP.md**](./SETUP.md) | Complete setup guide, build instructions, fixes, and artifacts |



## 🏗️ Architecture| [**INTEGRATION_GUIDE.md**](./INTEGRATION_GUIDE.md) | User-facing integration guide for Android and iOS |- Flutter module handles the UI rendering and business logic### For Development



```| [**ARCHITECTURE_RECOMMENDATION.md**](./ARCHITECTURE_RECOMMENDATION.md) | Architecture analysis and Option C justification |

Your Native App (Kotlin/Swift)

        ↓| [**BUILD_VERIFICATION.md**](./BUILD_VERIFICATION.md) | Build verification report and test results |

reels_android / reels_ios

    [Clean, native-feeling API]| [**PROGRESS.md**](./PROGRESS.md) | Development progress and status tracking |

    [This is what you use!]

        ↓## Package Naming```bash

    [Pigeon - Hidden from you]

        ↓---

Flutter Engine + reels_flutter

    [Reels UI implementation]# Clone the repository

```

## 🏗️ Architecture

**Benefits:**

- You get clean native APIs (no Flutter knowledge needed)All packages use the `com.eishon` organization:git clone https://github.com/eishon/flutter-reels.git

- We handle all Flutter/Pigeon complexity

- Official Flutter pattern (Add-to-App)**Option C: Hybrid Add-to-App**

- Reliable builds and easy debugging

- Android: `com.eishon.reels_android`cd flutter-reels/flutter_reels

---

```

## 💻 Usage Example

User's Native App (Kotlin/Swift)- iOS: `com.eishon.reels_ios` (ReelsIOS)

### Android

        ↓

```kotlin

import com.eishon.reels_android.*Native SDK Wrapper (reels_android / reels_ios)- Example apps: `com.eishon.reels.example`# Get dependencies



class MainActivity : AppCompatActivity() {    [Clean, platform-native API]

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)    [Hides all Pigeon complexity]flutter pub get

        

        // Initialize        ↓

        ReelsAndroidSDK.initialize(

            context = this,    Pigeon Communication Layer [HIDDEN]## Current Status

            config = ReelsConfig(

                autoPlay = true,        ↓

                showControls = true,

                loopVideos = trueFlutter Engine + reels_flutter Module# Run the module in standalone mode

            )

        )    [Reels UI Implementation]

        

        // Set listener```### ✅ Completedflutter run

        ReelsAndroidSDK.setListener(object : ReelsListener {

            override fun onReelViewed(videoId: String) {

                // Track analytics

            }**Key Benefits:**- [x] Project structure created```

            override fun onReelLiked(videoId: String, isLiked: Boolean) {

                // Handle like- Users get clean native APIs (no Flutter knowledge needed)

            }

            override fun onReelShared(videoId: String) {- Official Flutter pattern (Add-to-App is fully supported)- [x] Flutter module initialized

                // Handle share

            }- Reliable builds (no AAR compilation issues)

        })

        - Easy debugging (source code access)- [x] Android native SDK structure## 📦 Releases & Distribution

        // Show reels

        val videos = listOf(

            VideoInfo(

                id = "1",---- [x] iOS native SDK structure (SPM + CocoaPods)

                url = "https://example.com/video.mp4",

                title = "My Video",

                thumbnailUrl = "https://example.com/thumb.jpg"

            )## 💻 Usage Examples- [x] Android example app structure### For Private Repository Access

        )

        ReelsAndroidSDK.showReels(videos)

    }

}### Android- [x] iOS example app structure

```



### iOS

```kotlinThis repository is currently **private**. To use it in your projects:

```swift

import ReelsIOS// Initialize



// InitializeReelsAndroidSDK.initialize(this, ReelsConfig(### 🚧 In Progress

let config = ReelsConfig(autoPlay: true, showControls: true, loopVideos: true)

ReelsIOSSDK.shared.initialize(config: config)    autoPlay = true,



// Set delegate    showControls = true,- [x] Pigeon API definitions - Complete type-safe communication layer1. **GitHub Packages** (Recommended for Private Repos)

ReelsIOSSDK.shared.delegate = self

    loopVideos = true

// Show reels

let videos = [))- [x] Flutter module integration with native wrappers   - See [GitHub Packages Setup Guide](./GITHUB_PACKAGES_SETUP.md)

    VideoInfo(

        id: "1",

        url: "https://example.com/video.mp4",

        title: "My Video",// Set listener- [x] Pigeon communication implementation - Complete with auto-formatting workflow   - Requires Personal Access Token (PAT)

        thumbnailUrl: "https://example.com/thumb.jpg"

    )ReelsAndroidSDK.setListener(object : ReelsListener {

]

try? ReelsIOSSDK.shared.showReels(videos: videos)    override fun onReelViewed(videoId: String) {- [ ] GitHub Actions for publishing AAR/framework   - Works with Gradle (Android) and CocoaPods (iOS)



// Implement delegate        // Handle event

extension AppDelegate: ReelsDelegate {

    func onReelViewed(videoId: String) { }    }

    func onReelLiked(videoId: String, isLiked: Bool) { }

    func onReelShared(videoId: String) { }})

}

```### 📋 Pending2. **Direct Downloads**



**No Pigeon. No Flutter. Just clean native code.** ✨// Show reels



---val videos = listOf(- [ ] Core reels functionality   - Pre-built releases available on [Releases](https://github.com/eishon/flutter-reels/releases) page



## 📚 Documentation    VideoInfo(id = "1", url = "https://example.com/video1.mp4")



| Document | Audience | Description |)- [ ] Video playback   - Requires repository access

|----------|----------|-------------|

| [**ADD_TO_APP_GUIDE.md**](./ADD_TO_APP_GUIDE.md) | 👤 **Users** | **⭐ START HERE** - Complete integration guide |ReelsAndroidSDK.showReels(videos)

| [SETUP.md](./SETUP.md) | 👨‍💻 Contributors | Development environment setup |

| [PUBLISHING.md](./PUBLISHING.md) | 👨‍💻 Maintainers | Release and publishing process |```- [ ] Engagement features (like, share, comment)   - **Android AAR**: Ready-to-use Android Archive files

| [reels_flutter/README.md](./reels_flutter/README.md) | 👨‍💻 Contributors | Flutter module details |



---

### iOS- [ ] Product tagging   - **iOS Frameworks**: XCFramework bundles for iOS integration

## 🔧 Requirements



### For Integration (Using the SDK)

```swift

**Android:**

- Android SDK 21+ (Android 5.0+)// Initialize

- Gradle 8.0+

- Kotlin 1.9.0+let config = ReelsConfig(autoPlay: true, showControls: true, loopVideos: true)## Development Roadmap### For Public Repository



**iOS:**ReelsIOSSDK.shared.initialize(config: config)

- iOS 13.0+

- Xcode 14.0+ReelsIOSSDK.shared.delegate = self

- CocoaPods 1.11+



### For Development (Contributing)

// Show reels### Phase 1: Infrastructure (Current)If you make this repository public, users can use simple dependency management:

- Flutter SDK 3.35.6+

- Dart SDK 3.9.2+let videos = [

- All of the above

    VideoInfo(id: "1", url: "https://example.com/video1.mp4")1. Setup project structure- **Android**: One-line Gradle dependency

See [SETUP.md](./SETUP.md) for detailed development setup.

]

---

try? ReelsIOSSDK.shared.showReels(videos: videos)2. ~~Implement Pigeon communication~~ ✅ Complete- **iOS**: One-line CocoaPods dependency

## 📦 Example Apps



Working examples are included in the repository:

// Implement delegate3. Integrate Flutter module with native wrappers- No authentication required

### Android Example

extension AppDelegate: ReelsDelegate {

```bash

cd example/android    func onReelViewed(videoId: String) {4. Create CI/CD pipelines for publishing

./gradlew :app:assembleDebug

./gradlew :app:installDebug        // Handle event

```

    }### Creating a New Release

**Output**: APK (5.4MB), builds in ~25 seconds

}

### iOS Example

```### Phase 2: Functionality (Next)

```bash

cd example/ios

pod install

open Runner.xcworkspace**No Pigeon. No Flutter. Just clean native code.** ✨1. Implement reels UI in Flutter moduleTo create a new release:

# Build and run from Xcode

```



**Output**: iOS app with working reels integration---2. Add video playback capabilities



---



## ✅ Current Status## ✅ Build Status3. Implement engagement features```bash



| Component | Status | Details |

|-----------|--------|---------|

| **Android SDK** | ✅ Ready | Kotlin wrapper, clean API || Platform | Status | Output |4. Add product tagging support# Tag your commit with a version

| **iOS SDK** | ✅ Ready | Swift wrapper, CocoaPods support |

| **Flutter Module** | ✅ Ready | UI implementation, Pigeon communication (5 APIs) ||----------|--------|--------|

| **Example Apps** | ✅ Working | Both Android and iOS |

| **CI/CD** | ✅ Passing | 8/8 checks passing || **Android** | ✅ Successful | APK (5.4MB) |git tag v1.0.0

| **Tests** | ✅ Passing | 329 tests, 95%+ coverage |

| **Documentation** | ✅ Complete | Integration guides and examples || **iOS** | ✅ Pods Installed | 3 dependencies |



**Latest Version**: v0.1.3-beta  | **Native SDKs** | ✅ Validated | Both compile |## Buildinggit push origin v1.0.0

**Branch**: release/v0.1.3-beta  

**PR Status**: #7 - All checks passing ✅



---**Last Verified**: October 22, 2025```



## 🤝 Contributing



Contributions welcome! Here's how:---### Flutter Module



1. **Fork** the repository

2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)

3. **Make** your changes## 🔧 Requirements```bashThe GitHub Actions workflows will automatically:

4. **Test** on both platforms

5. **Submit** a pull request



**Development Setup**: See [SETUP.md](./SETUP.md)### Androidcd reels_flutter1. Build Android AAR files



**Note**: The `main` branch is protected. All changes require PR approval.- Android SDK 21+ (Android 5.0+)



---- Gradle 8.12flutter pub get2. Build iOS frameworks



## 🐛 Troubleshooting- Kotlin 1.9.0+



### Common Issues- Java 17+flutter build aar  # For Android3. Create a GitHub release with all artifacts



**Android: "Could not find Flutter engine artifacts"**

- Solution: Use `PREFER_PROJECT` repository mode in `settings.gradle`

- Details: [ADD_TO_APP_GUIDE.md#troubleshooting](./ADD_TO_APP_GUIDE.md#troubleshooting)### iOSflutter build ios-framework  # For iOS4. Generate release notes



**iOS: "Framework not found Flutter"**- iOS 13.0+

- Solution: Open `.xcworkspace` (not `.xcodeproj`) and run `pod install`

- Details: [ADD_TO_APP_GUIDE.md#troubleshooting](./ADD_TO_APP_GUIDE.md#troubleshooting)- Xcode 14.0+```



**More help**: See [ADD_TO_APP_GUIDE.md](./ADD_TO_APP_GUIDE.md) or [open an issue](https://github.com/eishon/flutter-reels/issues)- CocoaPods



---- Swift 5.0+## 🔧 Development Workflow



## 📄 License



This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.### Build Environment### Android SDK



---- Flutter SDK 3.35.6+



## 💬 Support- Dart SDK 3.9.2+```bash### Prerequisites



- **Integration Help**: See [ADD_TO_APP_GUIDE.md](./ADD_TO_APP_GUIDE.md)

- **Issues**: [GitHub Issues](https://github.com/eishon/flutter-reels/issues)

- **Discussions**: [GitHub Discussions](https://github.com/eishon/flutter-reels/discussions)---cd example/android



---



## 🙏 Acknowledgments## 📦 Installation./gradlew :reels_android:assembleRelease- Flutter SDK 3.16.5 or higher



- Built with Flutter's [Add-to-App pattern](https://docs.flutter.dev/add-to-app)

- Uses [Pigeon](https://pub.dev/packages/pigeon) for type-safe platform communication

- Inspired by Instagram Reels and TikTok### Android```- For Android:



---



**Made with ❤️ using Flutter****Step 1**: Add to `settings.gradle`  - Android Studio



*Give us a ⭐ if this project helped you!*```gradle


include ':reels_android'### iOS SDK  - Java 17+

project(':reels_android').projectDir = file('../path/to/reels_android')

```bash  - Android SDK (API 21+)

setBinding(new Binding([gradle: this]))

evaluate(new File('../path/to/reels_flutter/.android/include_flutter.groovy'))cd reels_ios- For iOS:

```

pod lib lint  - macOS

**Step 2**: Add dependency in `app/build.gradle`

```gradle```  - Xcode 14.0+

dependencies {

    implementation project(':reels_android')  - CocoaPods

}

```## Example Apps



**Step 3**: Use the SDK (see examples above)### Project Structure



### iOS### Android



**Step 1**: Update `Podfile````bash```

```ruby

platform :ios, '13.0'cd example/androidflutter-reels/



flutter_application_path = '../path/to/reels_flutter'./gradlew :app:assembleDebug├── .github/

load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

./gradlew :app:installDebug│   └── workflows/          # GitHub Actions CI/CD workflows

target 'YourApp' do

  use_frameworks!```│       ├── ci.yml          # Continuous integration

  pod 'ReelsIOS', :path => '../path/to/reels_ios'

  install_all_flutter_pods(flutter_application_path)│       ├── build-android.yml

end

```### iOS│       ├── build-ios.yml



**Step 2**: Install pods```bash│       └── release.yml     # Release automation

```bash

cd ioscd example/ios/ios├── flutter_reels/          # The Flutter module

pod install

```pod install│   ├── lib/



**Step 3**: Use the SDK (see examples above)open Runner.xcworkspace│   │   └── main.dart       # Main entry point



---# Build and run from Xcode│   ├── test/               # Unit tests



## 🤝 Contributing```│   ├── .android/           # Android-specific files



Contributions are welcome! Please see [SETUP.md](./SETUP.md) for build instructions.│   ├── .ios/               # iOS-specific files



1. Fork the repository## Integration Guide│   └── pubspec.yaml        # Dependencies

2. Create your feature branch

3. Make your changes└── README.md               # This file

4. Test on both platforms

5. Submit a pull request### Android Integration```



---



## 📄 License```kotlin### Running Tests



[Your License Here]import com.eishon.reels_android.ReelsAndroidSDK



---```bash



## 🙏 Acknowledgmentsclass MainActivity : AppCompatActivity() {cd flutter_reels



- Built with Flutter's Add-to-App pattern    override fun onCreate(savedInstanceState: Bundle?) {flutter test

- Uses Pigeon for type-safe platform communication

- Inspired by Instagram Reels and TikTok        super.onCreate(savedInstanceState)```



---        



## 📞 Support        // Initialize Reels SDK### Code Analysis



- **Issues**: [GitHub Issues](https://github.com/eishon/flutter-reels/issues)        ReelsAndroidSDK.initialize()

- **Documentation**: See docs above

- **Examples**: Check `example/android` and `example/ios`    }```bash



---}cd flutter_reels



**Made with ❤️ using Flutter**```flutter analyze


```

### iOS Integration

### Building for Production

```swift

import ReelsIOS#### Android:

```bash

class AppDelegate: UIApplicationDelegate {cd flutter_reels

    func application(_ application: UIApplication, flutter build aar --release

                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {```

        // Initialize Reels SDK

        ReelsIOSSDK.shared.initialize()Output location: `build/host/outputs/repo/`

        return true

    }#### iOS:

}```bash

```cd flutter_reels

flutter build ios-framework --release

## Requirements```



### AndroidOutput location: `build/ios/framework/Release/`

- Android SDK 21+ (Android 5.0+)

- Compile SDK 34## 🤖 CI/CD

- Kotlin 1.9.0+

- Java 17This project uses GitHub Actions for continuous integration and deployment:



### iOS### Workflows

- iOS 12.0+

- Swift 5.0+1. **CI** (`ci.yml`): Runs on every push and PR

- CocoaPods or Swift Package Manager   - Code formatting check

   - Static analysis

### Flutter   - Unit tests

- Flutter SDK 3.35.6+   - Test coverage report

- Dart SDK 3.3.0+

2. **Build Android** (`build-android.yml`): Builds Android AAR

## License   - Triggered on tags and manual dispatch

   - Uploads AAR artifacts

[License information to be added]

3. **Build iOS** (`build-ios.yml`): Builds iOS frameworks

## Contributing   - Triggered on tags and manual dispatch

   - Uploads framework artifacts

[Contributing guidelines to be added]

4. **Release** (`release.yml`): Creates GitHub releases
   - Triggered on version tags (`v*`)
   - Builds both Android and iOS
   - Creates release with all artifacts

## 📱 Features

### Core Features
- ✅ Vertical video feed (TikTok/Instagram Reels style)
- ✅ Auto-playing videos with smooth transitions
- ✅ Like, comment, and share interactions
- ✅ User profiles with avatars
- ✅ Product tagging and e-commerce integration
- ✅ Pull-to-refresh functionality
- ✅ Horizontal swipe gestures

### Native Platform Integration
- ✅ **Type-safe platform communication** via Pigeon
- ✅ **Analytics tracking** - Track video views, clicks, and user engagement
- ✅ **Access token management** - Secure authentication flow
- ✅ **Button event callbacks** - Before/after like and share events
- ✅ **Screen state tracking** - Monitor screen lifecycle (focus/unfocus)
- ✅ **Video playback states** - Track playing, paused, buffering, completed
- ✅ **Navigation gestures** - Swipe left/right event handling
- ✅ **Native share integration** - Open platform share sheets
- ✅ **Deep linking support** - Navigate to specific videos

### Architecture & Quality
- ✅ **Clean Architecture** - Separation of concerns (Domain, Data, Presentation)
- ✅ **Dependency Injection** - Using get_it for loose coupling
- ✅ **State Management** - Provider for reactive UI
- ✅ **Comprehensive Testing** - 343+ unit tests with 95%+ coverage
- ✅ **CI/CD Pipeline** - Automated builds and releases
- ✅ **Native Integration Support** - Android and iOS
- ✅ **Automated builds and releases**
- ✅ **Comprehensive documentation**

### Coming Soon
- 🔄 Comments section
- 🔄 Follow/unfollow functionality
- 🔄 Video upload capability
- 🔄 Advanced video filters
- 🔄 Live streaming support

## 🛠️ Technology Stack

- **Flutter**: 3.16.5
- **Dart**: 3.2.3
- **Android**: API 21+ (Android 5.0+)
- **iOS**: 12.0+

## 📖 Documentation

### Integration Guides
- [**Native Integration Guide**](./NATIVE_INTEGRATION.md) - Complete guide for Android/iOS integration
- [**Pigeon API Documentation**](./reels_flutter/pigeons/README.md) - Platform communication APIs
- [Module Integration Guide](./flutter_reels/README.md) - Flutter module setup
- [Gradle Integration](./GRADLE_INTEGRATION.md) - Android dependency management
- [CocoaPods Integration](./COCOAPODS_INTEGRATION.md) - iOS dependency management
- [GitHub Packages Setup](./GITHUB_PACKAGES_SETUP.md) - Private repository access

### Platform Communication
The Flutter Reels module uses Pigeon for type-safe communication with native platforms:

- **5 Complete APIs** for bidirectional communication
- **Analytics tracking** - Monitor user behavior (ReelsFlutterAnalyticsApi)
- **Token management** - Handle authentication (ReelsFlutterTokenApi)
- **Button events** - React to user interactions (ReelsFlutterButtonEventsApi)
- **State tracking** - Screen and video lifecycle (ReelsFlutterStateApi)
- **Navigation** - Gesture-based navigation (ReelsFlutterNavigationApi)
- **Auto-formatting workflow** - Automatic code generation and formatting

See [Pigeon API Documentation](./reels_flutter/pigeons/README.md) for complete API reference, usage examples, and integration guides.

### External Resources
- [Flutter Add-to-App Official Documentation](https://docs.flutter.dev/add-to-app)
- [Pigeon Package Documentation](https://pub.dev/packages/pigeon)
- [Clean Architecture in Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

**Note:** The `main` branch is protected and does not allow direct pushes. All changes must be submitted through pull requests with at least one approval. See [Branch Protection Guide](.github/BRANCH_PROTECTION.md) and [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write tests for new features
- Update documentation as needed
- Ensure CI passes before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/eishon/flutter-reels/issues)
- **Discussions**: [GitHub Discussions](https://github.com/eishon/flutter-reels/discussions)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- The open-source community

---

**Made with ❤️ using Flutter**

For detailed integration instructions, visit the [flutter_reels README](./flutter_reels/README.md).
