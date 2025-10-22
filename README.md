# Flutter Reels - Native SDK Integration# Flutter Reels



This project provides native Android and iOS SDKs for integrating Flutter-based reels functionality into native mobile applications.[![CI](https://github.com/eishon/flutter-reels/actions/workflows/ci.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/ci.yml)

[![Build Android](https://github.com/eishon/flutter-reels/actions/workflows/build-android.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/build-android.yml)

## Project Structure[![Build iOS](https://github.com/eishon/flutter-reels/actions/workflows/build-ios.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/build-ios.yml)



```A Flutter module designed to be integrated into native Android and iOS applications. This module provides a reels/stories viewing experience that can be seamlessly embedded in your existing native apps.

flutter-reels/

├── reels_flutter/          # Flutter module with reels functionality## 📋 Overview

├── reels_android/          # Android native SDK wrapper

├── reels_ios/              # iOS native SDK wrapper  This repository contains a Flutter module (`flutter_reels`) that can be distributed as a library for native Android and iOS projects. The module is built with native integration in mind and includes automated CI/CD pipelines for easy distribution.

├── example/

│   ├── android/           # Android example app## 🚀 Quick Start

│   └── ios/               # iOS example app

└── legacy/                # Previous project version (archived)### For Integration

```

Visit the [flutter_reels](./flutter_reels) directory for detailed integration instructions for both Android and iOS.

## Architecture

**Quick Links:**

The project follows a three-tier architecture:- [**🚀 Native Initialization Quick Start**](./NATIVE_INITIALIZATION.md) ⭐ **START HERE** (Step-by-step setup)

- [**Native Integration Guide**](./NATIVE_INTEGRATION.md) (Complete native platform integration)

1. **reels_flutter**: Flutter module containing the core reels UI and logic- [**Pigeon API Documentation**](./flutter_reels/pigeon/README.md) (Platform communication APIs)

2. **reels_android / reels_ios**: Native wrapper SDKs that embed the Flutter module- [Android Integration Guide](./flutter_reels/README.md#for-android-native)

3. **example apps**: Demonstration apps showing how to integrate the native SDKs- [iOS Integration Guide](./flutter_reels/README.md#for-ios-native)

- [Gradle Integration Guide](./GRADLE_INTEGRATION.md) (Android Dependency)

### Communication Layer- [CocoaPods Integration Guide](./COCOAPODS_INTEGRATION.md) (iOS Dependency)

- [Multi-Instance Navigation](./MULTI_INSTANCE_NAVIGATION.md) (Advanced navigation patterns)

- **Pigeon**: Type-safe platform channel communication between Flutter and native code- [GitHub Packages Setup](./GITHUB_PACKAGES_SETUP.md) (For Private Repository Access)

- Native SDKs provide clean APIs for initialization and interaction

- Flutter module handles the UI rendering and business logic### For Development



## Package Naming```bash

# Clone the repository

All packages use the `com.eishon` organization:git clone https://github.com/eishon/flutter-reels.git

- Android: `com.eishon.reels_android`cd flutter-reels/flutter_reels

- iOS: `com.eishon.reels_ios` (ReelsIOS)

- Example apps: `com.eishon.reels.example`# Get dependencies

flutter pub get

## Current Status

# Run the module in standalone mode

### ✅ Completedflutter run

- [x] Project structure created```

- [x] Flutter module initialized

- [x] Android native SDK structure## 📦 Releases & Distribution

- [x] iOS native SDK structure (SPM + CocoaPods)

- [x] Android example app structure### For Private Repository Access

- [x] iOS example app structure

This repository is currently **private**. To use it in your projects:

### 🚧 In Progress

- [ ] Pigeon API definitions1. **GitHub Packages** (Recommended for Private Repos)

- [ ] Flutter module integration with native wrappers   - See [GitHub Packages Setup Guide](./GITHUB_PACKAGES_SETUP.md)

- [ ] Pigeon communication implementation   - Requires Personal Access Token (PAT)

- [ ] GitHub Actions for publishing AAR/framework   - Works with Gradle (Android) and CocoaPods (iOS)



### 📋 Pending2. **Direct Downloads**

- [ ] Core reels functionality   - Pre-built releases available on [Releases](https://github.com/eishon/flutter-reels/releases) page

- [ ] Video playback   - Requires repository access

- [ ] Engagement features (like, share, comment)   - **Android AAR**: Ready-to-use Android Archive files

- [ ] Product tagging   - **iOS Frameworks**: XCFramework bundles for iOS integration



## Development Roadmap### For Public Repository



### Phase 1: Infrastructure (Current)If you make this repository public, users can use simple dependency management:

1. Setup project structure- **Android**: One-line Gradle dependency

2. Implement Pigeon communication- **iOS**: One-line CocoaPods dependency

3. Integrate Flutter module with native wrappers- No authentication required

4. Create CI/CD pipelines for publishing

### Creating a New Release

### Phase 2: Functionality (Next)

1. Implement reels UI in Flutter moduleTo create a new release:

2. Add video playback capabilities

3. Implement engagement features```bash

4. Add product tagging support# Tag your commit with a version

git tag v1.0.0

## Buildinggit push origin v1.0.0

```

### Flutter Module

```bashThe GitHub Actions workflows will automatically:

cd reels_flutter1. Build Android AAR files

flutter pub get2. Build iOS frameworks

flutter build aar  # For Android3. Create a GitHub release with all artifacts

flutter build ios-framework  # For iOS4. Generate release notes

```

## 🔧 Development Workflow

### Android SDK

```bash### Prerequisites

cd example/android

./gradlew :reels_android:assembleRelease- Flutter SDK 3.16.5 or higher

```- For Android:

  - Android Studio

### iOS SDK  - Java 17+

```bash  - Android SDK (API 21+)

cd reels_ios- For iOS:

pod lib lint  - macOS

```  - Xcode 14.0+

  - CocoaPods

## Example Apps

### Project Structure

### Android

```bash```

cd example/androidflutter-reels/

./gradlew :app:assembleDebug├── .github/

./gradlew :app:installDebug│   └── workflows/          # GitHub Actions CI/CD workflows

```│       ├── ci.yml          # Continuous integration

│       ├── build-android.yml

### iOS│       ├── build-ios.yml

```bash│       └── release.yml     # Release automation

cd example/ios/ios├── flutter_reels/          # The Flutter module

pod install│   ├── lib/

open Runner.xcworkspace│   │   └── main.dart       # Main entry point

# Build and run from Xcode│   ├── test/               # Unit tests

```│   ├── .android/           # Android-specific files

│   ├── .ios/               # iOS-specific files

## Integration Guide│   └── pubspec.yaml        # Dependencies

└── README.md               # This file

### Android Integration```



```kotlin### Running Tests

import com.eishon.reels_android.ReelsAndroidSDK

```bash

class MainActivity : AppCompatActivity() {cd flutter_reels

    override fun onCreate(savedInstanceState: Bundle?) {flutter test

        super.onCreate(savedInstanceState)```

        

        // Initialize Reels SDK### Code Analysis

        ReelsAndroidSDK.initialize()

    }```bash

}cd flutter_reels

```flutter analyze

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
- [**Pigeon API Documentation**](./flutter_reels/pigeon/README.md) - Platform communication APIs
- [Module Integration Guide](./flutter_reels/README.md) - Flutter module setup
- [Gradle Integration](./GRADLE_INTEGRATION.md) - Android dependency management
- [CocoaPods Integration](./COCOAPODS_INTEGRATION.md) - iOS dependency management
- [GitHub Packages Setup](./GITHUB_PACKAGES_SETUP.md) - Private repository access

### Platform Communication
The Flutter Reels module uses Pigeon for type-safe communication with native platforms:

- **6 Complete APIs** for bidirectional communication
- **Analytics tracking** - Monitor user behavior
- **Token management** - Handle authentication
- **Button events** - React to user interactions
- **State tracking** - Screen and video lifecycle
- **Navigation** - Gesture-based navigation
- **Native callbacks** - Asynchronous token retrieval

See [Pigeon README](./flutter_reels/pigeon/README.md) for complete API documentation.

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
