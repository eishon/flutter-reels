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
- [Android Integration Guide](./flutter_reels/README.md#for-android-native)
- [iOS Integration Guide](./flutter_reels/README.md#for-ios-native)

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

## 📦 Releases

Pre-built releases are available on the [Releases](https://github.com/eishon/flutter-reels/releases) page, including:

- **Android AAR**: Ready-to-use Android Archive files
- **iOS Frameworks**: XCFramework bundles for iOS integration

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

- ✅ Simple "Hello World" screen (foundation)
- ✅ Native Android integration support
- ✅ Native iOS integration support
- ✅ Automated builds and releases
- ✅ Comprehensive documentation
- 🔄 More features coming soon!

## 🛠️ Technology Stack

- **Flutter**: 3.16.5
- **Dart**: 3.2.3
- **Android**: API 21+ (Android 5.0+)
- **iOS**: 12.0+

## 📖 Documentation

- [Module Integration Guide](./flutter_reels/README.md)
- [Flutter Add-to-App Official Documentation](https://docs.flutter.dev/add-to-app)

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

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
