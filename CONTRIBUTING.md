# Contributing to Flutter Reels

Thank you for your interest in contributing to Flutter Reels! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Working with Pigeon](#working-with-pigeon)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Branch Protection](#branch-protection)
- [Coding Standards](#coding-standards)
- [Documentation](#documentation)
- [Release Process](#release-process)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to:

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK:** 3.35.6 or higher
- **Dart SDK:** 3.9.2 or higher
- **Android Studio** (for Android development)
  - Android SDK API 21+ (Android 5.0+)
  - Java 17+
- **Xcode** (for iOS development)
  - Xcode 14.0+
  - CocoaPods
- **Git** for version control

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/flutter-reels.git
   cd flutter-reels
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/eishon/flutter-reels.git
   ```

## Development Setup

Complete setup instructions are available in [SETUP.md](./SETUP.md). Quick start:

### 1. Flutter Module Setup

```bash
cd reels_flutter
flutter pub get
flutter test
```

### 2. Android SDK Setup

```bash
cd reels_android
./gradlew build
./gradlew test
```

### 3. iOS SDK Setup

```bash
cd reels_ios
pod install
pod lib lint
```

### 4. Example Apps

```bash
# Android example
cd example/android
./gradlew :app:assembleDebug

# iOS example
cd example/ios
pod install
open Runner.xcworkspace
```

## Making Changes

### Workflow

1. **Create a feature branch** from `main`:
   ```bash
   git checkout main
   git pull upstream main
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our coding standards

3. **Test thoroughly** on both platforms

4. **Commit your changes** with clear messages:
   ```bash
   git add .
   git commit -m "feat: add amazing new feature"
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

### Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks
- `perf:` Performance improvements

**Examples:**
```bash
feat: add video download functionality
fix: resolve crash on iOS when sharing video
docs: update pigeon API documentation
refactor: simplify analytics service implementation
test: add unit tests for video state tracking
chore: update dependencies to latest versions
```

## Working with Pigeon

Pigeon is used for type-safe communication between Flutter and native platforms.

### Modifying Pigeon APIs

1. **Edit the interface** in `reels_flutter/pigeons/messages.dart`

2. **Regenerate code:**
   ```bash
   cd reels_flutter
   dart run pigeon --input pigeons/messages.dart
   ```

3. **Format generated code:**
   ```bash
   dart format lib/core/pigeon_generated.dart
   ```

4. **Update implementations** in:
   - Flutter: Services using the generated APIs
   - Android: `reels_android/src/main/java/com/eishon/reels_android/PigeonGenerated.kt`
   - iOS: `reels_ios/Sources/ReelsIOS/PigeonGenerated.swift`

5. **Update documentation:**
   - Update `reels_flutter/pigeons/README.md` with new API details
   - Add usage examples

6. **Test on both platforms**

### Pigeon Best Practices

- Keep APIs simple and focused
- Use clear, descriptive names
- Document all public methods
- Use nullable types for optional values
- Test serialization/deserialization thoroughly

**Note:** The GitHub Actions workflow `.github/workflows/auto-format-pigeon.yml` automatically regenerates and formats Pigeon code when `messages.dart` is modified.

## Testing

### Running Tests

**Flutter Module:**
```bash
cd reels_flutter
flutter test
flutter test --coverage
```

**Android SDK:**
```bash
cd reels_android
./gradlew test
./gradlew jacocoTestReport  # For coverage
```

**iOS SDK:**
```bash
cd reels_ios
swift test
```

### Test Coverage

- Aim for **90%+ test coverage** for new code
- Write unit tests for all business logic
- Add integration tests for critical user flows
- Test edge cases and error conditions

### Code Analysis

Run static analysis before committing:

```bash
cd reels_flutter
flutter analyze
dart format --set-exit-if-changed .
```

## Submitting Changes

### Pull Request Process

1. **Update documentation** if you're changing functionality
2. **Ensure all tests pass** on both platforms
3. **Run code formatters and linters**
4. **Update CHANGELOG.md** if applicable
5. **Fill out the PR template** completely

### PR Requirements

- ✅ All CI checks must pass
- ✅ Code must be formatted according to project standards
- ✅ Tests must be included for new features
- ✅ Documentation must be updated
- ✅ At least **1 approval** from a maintainer
- ✅ No merge conflicts with `main` branch

### PR Template

When creating a PR, include:

- **Description:** What does this PR do?
- **Motivation:** Why is this change needed?
- **Testing:** How was this tested?
- **Screenshots:** For UI changes (required)
- **Breaking Changes:** List any breaking changes
- **Related Issues:** Link related issues

## Branch Protection

The `main` branch is protected and requires:

- ✅ Pull request before merging
- ✅ At least 1 approval from reviewers
- ✅ All status checks passing
- ❌ No direct pushes allowed

See [.github/BRANCH_PROTECTION.md](./.github/BRANCH_PROTECTION.md) for complete details.

### If You Accidentally Push to Main

Don't panic! Contact a maintainer who can help resolve the situation. In the future, always create feature branches:

```bash
git checkout -b feature/my-feature
```

## Coding Standards

### Dart/Flutter

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` for consistent formatting
- Maximum line length: 80 characters
- Use meaningful variable and function names
- Add documentation comments for public APIs

**Example:**
```dart
/// Tracks analytics events to native platforms.
///
/// This service provides a type-safe interface for sending analytics
/// events from Flutter to native Android and iOS code.
class AnalyticsService {
  /// Tracks a custom analytics event.
  ///
  /// [eventName] The name of the event to track
  /// [properties] Optional key-value pairs for event properties
  void trackEvent(String eventName, Map<String, String>? properties) {
    // Implementation
  }
}
```

### Kotlin (Android)

- Follow [Kotlin coding conventions](https://kotlinlang.org/docs/coding-conventions.html)
- Use meaningful class and function names
- Prefer immutability (`val` over `var`)
- Use extension functions appropriately
- Add KDoc comments for public APIs

**Example:**
```kotlin
/**
 * Service for tracking analytics events.
 *
 * This service receives analytics events from Flutter and forwards them
 * to the native analytics platform.
 */
class AnalyticsService {
    /**
     * Tracks a custom analytics event.
     *
     * @param eventName The name of the event
     * @param properties Optional event properties
     */
    fun trackEvent(eventName: String, properties: Map<String, Any>?) {
        // Implementation
    }
}
```

### Swift (iOS)

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful names for types and functions
- Prefer structs over classes when appropriate
- Use guard statements for early returns
- Add documentation comments for public APIs

**Example:**
```swift
/// Service for tracking analytics events.
///
/// This service receives analytics events from Flutter and forwards them
/// to the native analytics platform.
public class AnalyticsService {
    /// Tracks a custom analytics event.
    ///
    /// - Parameters:
    ///   - eventName: The name of the event
    ///   - properties: Optional event properties
    public func trackEvent(_ eventName: String, properties: [String: Any]?) {
        // Implementation
    }
}
```

## Documentation

### What to Document

- **Public APIs:** All public classes, methods, and properties
- **Pigeon Interfaces:** Complete API documentation in `reels_flutter/pigeons/README.md`
- **Architecture Decisions:** Major design decisions and rationale
- **Setup Instructions:** Any changes to setup or build process
- **Breaking Changes:** Document breaking changes in PR and CHANGELOG

### Documentation Guidelines

- Write clear, concise documentation
- Include code examples for complex APIs
- Update existing documentation when making changes
- Use proper markdown formatting
- Keep documentation up-to-date with code

### Documentation Files

- `README.md` - Project overview and quick start
- `SETUP.md` - Detailed setup and build instructions
- `CONTRIBUTING.md` - This file
- `.github/BRANCH_PROTECTION.md` - Branch protection rules
- `.github/SETUP_INSTRUCTIONS.md` - Initial setup instructions
- `reels_flutter/pigeons/README.md` - Pigeon API documentation
- `ADD_TO_APP_GUIDE.md` - Native integration guide
- `PUBLISHING.md` - Release and publishing process

## Release Process

Releases are handled by project maintainers. The process includes:

1. **Version Bump:** Update version numbers in:
   - `reels_flutter/pubspec.yaml`
   - `reels_android/build.gradle`
   - `reels_ios/ReelsIOS.podspec`

2. **Update CHANGELOG:** Document all changes since last release

3. **Create Release Branch:**
   ```bash
   git checkout -b release/v1.0.0
   ```

4. **Tag Release:**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

5. **Build Artifacts:** GitHub Actions automatically builds:
   - Android AAR files
   - iOS XCFramework
   - Documentation

6. **Publish Release:** Create GitHub release with artifacts and notes

See [PUBLISHING.md](./PUBLISHING.md) for detailed release instructions (maintainers only).

## Getting Help

### Resources

- **Documentation:** Check the `/docs` folder and README files
- **Issues:** Search [existing issues](https://github.com/eishon/flutter-reels/issues)
- **Discussions:** Join [GitHub Discussions](https://github.com/eishon/flutter-reels/discussions)
- **Setup Guide:** See [SETUP.md](./SETUP.md)
- **Pigeon Guide:** See [reels_flutter/pigeons/README.md](./reels_flutter/pigeons/README.md)

### Asking Questions

When asking for help:

1. Check documentation first
2. Search existing issues
3. Provide context and details:
   - What you're trying to achieve
   - What you've tried
   - Error messages
   - Platform (Android/iOS)
   - Flutter/Dart version
4. Include code samples if relevant
5. Be respectful and patient

### Reporting Bugs

Use the [issue template](https://github.com/eishon/flutter-reels/issues/new) and include:

- **Description:** Clear description of the bug
- **Steps to Reproduce:** Detailed steps to reproduce the issue
- **Expected Behavior:** What should happen
- **Actual Behavior:** What actually happens
- **Environment:** Platform, Flutter version, device info
- **Screenshots:** If applicable
- **Logs:** Relevant error logs or stack traces

### Suggesting Features

When suggesting new features:

1. **Search first:** Check if it's already suggested
2. **Describe use case:** Why is this feature needed?
3. **Propose solution:** How should it work?
4. **Consider alternatives:** What other approaches exist?
5. **Be open to feedback:** Discuss with maintainers

## Recognition

Contributors who make significant contributions will be:

- Listed in the project README
- Mentioned in release notes
- Credited in documentation

Thank you for contributing to Flutter Reels! 🎉

---

**Questions?** Open an issue or start a discussion.

**Need Setup Help?** See [SETUP.md](./SETUP.md) or [.github/SETUP_INSTRUCTIONS.md](./.github/SETUP_INSTRUCTIONS.md).

**Working with Pigeon?** See [reels_flutter/pigeons/README.md](./reels_flutter/pigeons/README.md).
