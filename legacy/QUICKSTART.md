# Flutter Reels - Quick Start Guide

This guide will help you get started with the Flutter Reels module in just a few minutes!

## 📋 Table of Contents

1. [For Native App Developers (Integration)](#for-native-app-developers)
2. [For Flutter Developers (Contributing)](#for-flutter-developers)
3. [For Release Managers](#for-release-managers)

---

## For Native App Developers

Want to integrate Flutter Reels into your existing native app? Follow these steps:

### Android (5 Minutes)

1. **Download the AAR**
   - Go to [Releases](https://github.com/eishon/flutter-reels/releases)
   - Download `flutter_reels-android.zip`
   - Extract and place AAR files in `app/libs/`

2. **Update build.gradle**
   ```gradle
   dependencies {
       implementation fileTree(dir: 'libs', include: ['*.aar'])
   }
   ```

3. **Launch Flutter**
   ```kotlin
   startActivity(FlutterActivity.createDefaultIntent(this))
   ```

**📚 Full Guide**: [Android Integration](./examples/android-integration.md)

### iOS (5 Minutes)

1. **Download Frameworks**
   - Go to [Releases](https://github.com/eishon/flutter-reels/releases)
   - Download `flutter_reels-ios.zip`
   - Extract to a `Flutter/` folder in your project

2. **Add to Xcode**
   - Drag frameworks to your project
   - Set "Embed & Sign"

3. **Launch Flutter**
   ```swift
   let flutterVC = FlutterViewController(engine: FlutterEngine(name: "engine"), nibName: nil, bundle: nil)
   present(flutterVC, animated: true)
   ```

**📚 Full Guide**: [iOS Integration](./examples/ios-integration.md)

---

## For Flutter Developers

Want to contribute or modify the module?

### Setup (2 Minutes)

```bash
# Clone the repository
git clone https://github.com/eishon/flutter-reels.git
cd flutter-reels/flutter_reels

# Install dependencies
flutter pub get

# Run the module
flutter run
```

### Development Workflow

```bash
# Format code
dart format lib test

# Run analysis
flutter analyze

# Run tests
flutter test

# Build for Android
flutter build aar

# Build for iOS
flutter build ios-framework
```

**📚 Full Guide**: [Contributing](./CONTRIBUTING.md)

---

## For Release Managers

### Creating a New Release

```bash
# 1. Update version in pubspec.yaml
# Edit: flutter_reels/pubspec.yaml

# 2. Update CHANGELOG.md
# Add release notes

# 3. Commit changes
git add .
git commit -m "Release v1.0.0"

# 4. Create and push tag
git tag v1.0.0
git push origin v1.0.0

# 5. GitHub Actions will automatically:
#    - Build Android AAR
#    - Build iOS frameworks
#    - Create GitHub release
#    - Upload all artifacts
```

### Manual Builds (if needed)

```bash
cd flutter_reels

# Android
flutter build aar --release
# Output: build/host/outputs/repo/

# iOS
flutter build ios-framework --release
# Output: build/ios/framework/Release/
```

---

## 🚀 What's Next?

### New to Flutter Modules?
- Read the [official Flutter documentation](https://docs.flutter.dev/add-to-app)
- Check out our [integration examples](./examples/)

### Ready to Integrate?
- **Android**: [Detailed Integration Guide](./examples/android-integration.md)
- **iOS**: [Detailed Integration Guide](./examples/ios-integration.md)

### Want to Contribute?
- Read [CONTRIBUTING.md](./CONTRIBUTING.md)
- Check [open issues](https://github.com/eishon/flutter-reels/issues)
- Join the discussion

---

## 📞 Need Help?

- **Issues**: [GitHub Issues](https://github.com/eishon/flutter-reels/issues)
- **Documentation**: [Main README](./README.md)
- **Examples**: [Integration Examples](./examples/)

---

## 📊 Project Structure

```
flutter-reels/
├── .github/workflows/      # CI/CD automation
│   ├── ci.yml             # Continuous integration
│   ├── build-android.yml  # Android AAR builds
│   ├── build-ios.yml      # iOS framework builds
│   └── release.yml        # Release automation
├── flutter_reels/          # The Flutter module
│   ├── lib/               # Source code
│   ├── test/              # Tests
│   └── README.md          # Integration guide
├── examples/              # Integration examples
│   ├── android-integration.md
│   └── ios-integration.md
├── CHANGELOG.md           # Version history
├── CONTRIBUTING.md        # Contribution guide
├── LICENSE                # MIT License
└── README.md              # Project overview
```

---

**Happy Coding! 🎉**
