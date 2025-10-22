# Flutter Reels - Setup & Build Guide

This document captures all the setup requirements, build fixes, and artifacts needed to successfully build this project.

---

## Prerequisites

### Required Software

1. **Flutter SDK** 3.35.6 or higher
   - Download: https://flutter.dev/docs/get-started/install
   - Required for: Add-to-App integration
   - Engine version: d2913632a4 (must match)

2. **Android Development** (for Android build)
   - Android SDK (API 21+, recommend API 34)
   - Android NDK 27.0.12077973
   - Gradle 8.12 (wrapper included)
   - Java 17 or higher

3. **iOS Development** (for iOS build - macOS only)
   - Xcode 14.0+
   - CocoaPods 1.11+
   - iOS 13.0+ deployment target

4. **Dart SDK** 3.9.2+ (included with Flutter)

---

## Initial Setup

### 1. Clone Repository

```bash
git clone https://github.com/eishon/flutter-reels.git
cd flutter-reels
```

### 2. Configure local.properties

**For Flutter Module** (`reels_flutter/.android/`):
```bash
cd reels_flutter/.android
cp local.properties.template local.properties
# Edit local.properties with your paths
```

**For Android Example** (`example/android/`):
```bash
cd example/android
cp local.properties.template local.properties
# Edit local.properties with your paths
```

**Required content**:
```properties
sdk.dir=/path/to/android-sdk
flutter.sdk=/path/to/flutter
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
```

### 3. Install Flutter Dependencies

```bash
cd reels_flutter
flutter pub get
```

---

## Android Build Setup

### Critical Configuration

**Issue Encountered**: Flutter Gradle Plugin couldn't find engine artifacts  
**Solution**: Use `PREFER_PROJECT` repository mode

In `example/android/settings.gradle`:
```gradle
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)  // NOT FAIL_ON_PROJECT_REPOS
    repositories {
        google()
        mavenCentral()
    }
}
```

**Why**: This allows Flutter Gradle Plugin to add its own Maven repositories for Flutter engine artifacts while still respecting project repositories.

### Build Android Example

```bash
cd example/android
./gradlew :app:assembleDebug
```

**Output**: `example/android/app/build/outputs/apk/debug/app-debug.apk` (5.4MB)

### Common Issues & Fixes

#### 1. SDK Location Not Found
```
Error: SDK location not found
```
**Fix**: Ensure `local.properties` exists with correct `sdk.dir` path

#### 2. Flutter Engine Artifacts Missing
```
Could not find io.flutter:flutter_embedding_debug:1.0.0-xxx
```
**Fix**: 
- Change `repositoriesMode` to `PREFER_PROJECT`
- Run `flutter precache --android`

#### 3. Launcher Icon Missing
```
error: resource mipmap/ic_launcher not found
```
**Fix**: Use drawable icon in AndroidManifest.xml:
```xml
android:icon="@drawable/ic_launcher"
```

---

## iOS Build Setup

### CocoaPods Configuration

**Critical**: iOS 13.0+ deployment target required

In `example/ios/Podfile`:
```ruby
platform :ios, '13.0'  # Minimum iOS 13.0

flutter_application_path = '../../reels_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'Runner' do
  use_frameworks!
  
  pod 'ReelsIOS', :path => '../../reels_ios'
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

### Build iOS Example

```bash
cd example/ios
pod install
open ReelsExample.xcworkspace
# Build in Xcode (Cmd+B)
```

**Pods Installed**:
- Flutter (1.0.0)
- FlutterPluginRegistrant (0.0.1)
- ReelsIOS (0.1.0)

### Common Issues & Fixes

#### 1. Pod Install Fails - Target Not Found
```
[!] Unable to find a target named `ReelsExample`
```
**Fix**: Use `Runner` as target name (Flutter convention)

#### 2. Deployment Target Too Low
```
[!] CocoaPods could not find compatible versions for pod "Flutter"
```
**Fix**: Update to iOS 13.0+ in Podfile and post_install

#### 3. Base Configuration Warnings
```
[!] CocoaPods did not set the base configuration
```
**Fix**: This is expected with Flutter's xcconfig files. Can be safely ignored.

---

## Gradle Wrapper Artifacts

### Included Files (Committed to Git)

These are **required** and should remain committed:

1. **Flutter Module Gradle Wrapper**:
   - `reels_flutter/android/gradle/wrapper/gradle-wrapper.jar`
   - `reels_flutter/android/gradle/wrapper/gradle-wrapper.properties`

2. **Example App Gradle Wrapper**:
   - `example/android/gradle/wrapper/gradle-wrapper.jar`
   - `example/android/gradle/wrapper/gradle-wrapper.properties`

**Why Committed**: Ensures consistent Gradle version across all machines and CI/CD.

### Gradle Version
- **Wrapper Version**: 8.12
- **Android Gradle Plugin**: 8.1.4
- **Kotlin**: 1.9.0

---

## Flutter Artifacts

### Generated Files (NOT Committed)

These are generated during build and excluded via `.gitignore`:

- `reels_flutter/.android/Flutter/build/`
- `example/android/app/build/`
- `example/ios/Pods/`
- All `*.jar`, `*.aar` files in build directories

### Required Generated Artifacts

Run these commands to regenerate:

```bash
# Flutter dependencies
cd reels_flutter
flutter pub get

# Android build artifacts (auto-generated)
cd example/android
./gradlew :app:assembleDebug

# iOS build artifacts (auto-generated)
cd example/ios
pod install
```

---

## Pigeon Generated Code

### Source Files (Committed)

- `reels_flutter/pigeons/messages.dart` - API definitions

### Generated Files (Committed)

These **ARE** committed because they're source code:

- `reels_flutter/lib/src/pigeon_generated.dart` (Dart)
- `reels_flutter/android/src/main/kotlin/.../PigeonGenerated.kt` (Kotlin)
- `reels_flutter/ios/Classes/PigeonGenerated.swift` (Swift)

### Regenerate Pigeon Code

If you modify `pigeons/messages.dart`:

```bash
cd reels_flutter
dart run pigeon --input pigeons/messages.dart
```

---

## GitHub Actions / CI Requirements

### Environment Variables Needed

```yaml
env:
  ANDROID_SDK_ROOT: ${{ env.ANDROID_HOME }}
  FLUTTER_ROOT: /path/to/flutter
```

### Setup Steps for CI

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.35.6'
    
- name: Setup Android SDK
  uses: android-actions/setup-android@v2
  
- name: Create local.properties
  run: |
    echo "sdk.dir=$ANDROID_SDK_ROOT" > example/android/local.properties
    echo "flutter.sdk=$FLUTTER_ROOT" >> example/android/local.properties
    
- name: Build Android
  run: |
    cd example/android
    ./gradlew assembleDebug
    
- name: Setup CocoaPods (macOS only)
  run: sudo gem install cocoapods
  
- name: Build iOS (macOS only)
  run: |
    cd example/ios
    pod install
    xcodebuild -workspace ReelsExample.xcworkspace \
               -scheme Runner \
               -sdk iphonesimulator \
               build
```

---

## Build Verification Checklist

### Android
- [ ] `local.properties` configured with SDK paths
- [ ] `./gradlew :app:assembleDebug` succeeds
- [ ] APK generated in `app/build/outputs/apk/debug/`
- [ ] APK size approximately 5-6MB (includes Flutter debug engine)
- [ ] No critical warnings (AGP/Kotlin version warnings OK)

### iOS
- [ ] `local.properties` configured (if needed)
- [ ] `pod install` succeeds with 3 pods
- [ ] `ReelsExample.xcworkspace` generated
- [ ] Swift syntax validation passes
- [ ] No critical CocoaPods errors

---

## Troubleshooting

### Flutter Command Not Found

```bash
# Add to .bashrc or .zshrc
export PATH="$PATH:/path/to/flutter/bin"
```

### Gradle Daemon Issues

```bash
cd example/android
./gradlew --stop  # Kill all daemons
./gradlew clean   # Clean build
./gradlew :app:assembleDebug
```

### CocoaPods Cache Issues

```bash
cd example/ios
rm -rf Pods Podfile.lock
pod install --repo-update
```

### Flutter Module Not Found

```bash
cd reels_flutter
flutter clean
flutter pub get
```

---

## Key Architecture Decisions Affecting Build

### 1. Add-to-App Pattern (Option C)
- **Decision**: Use Flutter module as source dependency, not binary
- **Impact**: Requires Flutter SDK on build machine
- **Benefit**: Reliable builds, no AAR generation issues

### 2. Repository Mode: PREFER_PROJECT
- **Decision**: Allow plugins to add repositories
- **Impact**: Flutter Gradle Plugin can fetch engine artifacts
- **Benefit**: No manual artifact management

### 3. Native SDK Wrappers
- **Decision**: Separate Android/iOS SDKs wrapping Flutter
- **Impact**: Users only need to integrate native SDKs
- **Benefit**: Hides Pigeon complexity, clean APIs

---

## Sharing with Teams

### What to Share

1. **This Repository** - Contains all code and build configurations
2. **local.properties.template** - Template for SDK paths
3. **This SETUP.md** - Complete build instructions
4. **BUILD_VERIFICATION.md** - Proof that builds work

### What Teams Need

- Flutter SDK 3.35.6+
- Android SDK (for Android builds)
- Xcode + CocoaPods (for iOS builds, macOS only)
- 30 minutes to follow setup instructions

### What They DON'T Need

- Pre-built AAR or Framework files
- Manual Flutter engine downloads
- Pigeon knowledge
- Previous project history (it's in `legacy/`)

---

## Summary of Fixes Applied

| Issue | Solution | Status |
|-------|----------|--------|
| Flutter AAR build fails | Switched to Add-to-App (Option C) | ✅ Fixed |
| Maven repository conflicts | Changed to PREFER_PROJECT mode | ✅ Fixed |
| Flutter engine artifacts missing | repositoriesMode + flutter precache | ✅ Fixed |
| Launcher icon not found | Use drawable icon in manifest | ✅ Fixed |
| iOS deployment target | Updated to iOS 13.0+ | ✅ Fixed |
| CocoaPods target not found | Changed to 'Runner' target | ✅ Fixed |
| local.properties missing | Created templates + docs | ✅ Fixed |
| Gradle wrapper missing | Committed to repository | ✅ Fixed |

---

## Version Information

- **Last Updated**: October 22, 2025
- **Flutter Version**: 3.35.6
- **Flutter Engine**: d2913632a4
- **Dart Version**: 3.9.2
- **Android Gradle Plugin**: 8.1.4
- **Kotlin**: 1.9.0
- **Gradle**: 8.12
- **iOS Deployment**: 13.0+
- **Pigeon**: 22.7.4

---

## Additional Resources

- **Integration Guide**: See `INTEGRATION_GUIDE.md` for user-facing docs
- **Architecture**: See `ARCHITECTURE_RECOMMENDATION.md` for design decisions
- **Progress**: See `PROGRESS.md` for development status
- **Build Verification**: See `BUILD_VERIFICATION.md` for test results

---

**Questions?** Check the troubleshooting section or review commit history for specific fixes.
