# Flutter Reels

[![CI](https://github.com/eishon/flutter-reels/actions/workflows/ci.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/ci.yml)
[![Build Android](https://github.com/eishon/flutter-reels/actions/workflows/build-android.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/build-android.yml)
[![Build iOS](https://github.com/eishon/flutter-reels/actions/workflows/build-ios.yml/badge.svg)](https://github.com/eishon/flutter-reels/actions/workflows/build-ios.yml)

A Flutter module designed to be integrated into native Android and iOS applications. This module provides a reels/stories viewing experience that can be seamlessly embedded in your existing native apps.

## 📋 Overview

This repository contains a Flutter module (`flutter_reels`) that can be distributed as a library for native Android and iOS projects. The module is built with native integration in mind and includes automated CI/CD pipelines for easy distribution.

## 🚀 Quick Start

### For Integration

Visit the [flutter_reels](./flutter_reels) directory for detailed integration instructions for both Android and iOS.

**Quick Links:**
- [**🚀 Native Initialization Quick Start**](./NATIVE_INITIALIZATION.md) ⭐ **START HERE** (Step-by-step setup)
- [**Native Integration Guide**](./NATIVE_INTEGRATION.md) (Complete native platform integration)
- [**Pigeon API Documentation**](./flutter_reels/pigeon/README.md) (Platform communication APIs)
- [Android Integration Guide](./flutter_reels/README.md#for-android-native)
- [iOS Integration Guide](./flutter_reels/README.md#for-ios-native)
- [Gradle Integration Guide](./GRADLE_INTEGRATION.md) (Android Dependency)
- [CocoaPods Integration Guide](./COCOAPODS_INTEGRATION.md) (iOS Dependency)
- [Multi-Instance Navigation](./MULTI_INSTANCE_NAVIGATION.md) (Advanced navigation patterns)
- [GitHub Packages Setup](./GITHUB_PACKAGES_SETUP.md) (For Private Repository Access)

### For Development

```bash
# Clone the repository
git clone https://github.com/eishon/flutter-reels.git
cd flutter-reels/flutter_reels

# Get dependencies
flutter pub get

# Run the module in standalone mode
flutter run
```

## 📦 Releases & Distribution

### For Private Repository Access

This repository is currently **private**. To use it in your projects:

1. **GitHub Packages** (Recommended for Private Repos)
   - See [GitHub Packages Setup Guide](./GITHUB_PACKAGES_SETUP.md)
   - Requires Personal Access Token (PAT)
   - Works with Gradle (Android) and CocoaPods (iOS)

2. **Direct Downloads**
   - Pre-built releases available on [Releases](https://github.com/eishon/flutter-reels/releases) page
   - Requires repository access
   - **Android AAR**: Ready-to-use Android Archive files
   - **iOS Frameworks**: XCFramework bundles for iOS integration

### For Public Repository

If you make this repository public, users can use simple dependency management:
- **Android**: One-line Gradle dependency
- **iOS**: One-line CocoaPods dependency
- No authentication required

### Creating a New Release

To create a new release:

```bash
# Tag your commit with a version
git tag v1.0.0
git push origin v1.0.0
```

The GitHub Actions workflows will automatically:
1. Build Android AAR files
2. Build iOS frameworks
3. Create a GitHub release with all artifacts
4. Generate release notes

## 🔧 Development Workflow

### Prerequisites

- Flutter SDK 3.16.5 or higher
- For Android:
  - Android Studio
  - Java 17+
  - Android SDK (API 21+)
- For iOS:
  - macOS
  - Xcode 14.0+
  - CocoaPods

### Project Structure

```
flutter-reels/
├── .github/
│   └── workflows/          # GitHub Actions CI/CD workflows
│       ├── ci.yml          # Continuous integration
│       ├── build-android.yml
│       ├── build-ios.yml
│       └── release.yml     # Release automation
├── flutter_reels/          # The Flutter module
│   ├── lib/
│   │   └── main.dart       # Main entry point
│   ├── test/               # Unit tests
│   ├── .android/           # Android-specific files
│   ├── .ios/               # iOS-specific files
│   └── pubspec.yaml        # Dependencies
└── README.md               # This file
```

### Running Tests

```bash
cd flutter_reels
flutter test
```

### Code Analysis

```bash
cd flutter_reels
flutter analyze
```

### Building for Production

#### Android:
```bash
cd flutter_reels
flutter build aar --release
```

Output location: `build/host/outputs/repo/`

#### iOS:
```bash
cd flutter_reels
flutter build ios-framework --release
```

Output location: `build/ios/framework/Release/`

## 🤖 CI/CD

This project uses GitHub Actions for continuous integration and deployment:

### Workflows

1. **CI** (`ci.yml`): Runs on every push and PR
   - Code formatting check
   - Static analysis
   - Unit tests
   - Test coverage report

2. **Build Android** (`build-android.yml`): Builds Android AAR
   - Triggered on tags and manual dispatch
   - Uploads AAR artifacts

3. **Build iOS** (`build-ios.yml`): Builds iOS frameworks
   - Triggered on tags and manual dispatch
   - Uploads framework artifacts

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
