# Pigeon - Native Platform Communication

This directory contains Pigeon interface definitions for type-safe communication between Flutter and native platforms (Android/iOS).

## What is Pigeon?

Pigeon is a code generator tool that creates type-safe communication channels between Flutter and native code. It generates:
- Dart code for Flutter
- Kotlin code for Android
- Swift code for iOS

## Files

- `messages.dart` - Source interface definitions
- Generated files (not tracked in git):
  - `lib/core/platform/messages.g.dart` - Flutter code
  - `android/src/main/kotlin/com/example/flutter_reels/Messages.g.kt` - Android code
  - `ios/Classes/Messages.g.swift` - iOS code

## How to Generate Code

After modifying `messages.dart`, regenerate the platform code:

```bash
cd flutter_reels
dart run pigeon --input pigeon/messages.dart
```

## Interfaces

### HostApi (Native → Flutter)
Methods that native platforms can call on Flutter:
- `updateAccessToken()` - Update auth token
- `clearAccessToken()` - Clear auth token
- `pauseVideos()` - Pause video playback
- `resumeVideos()` - Resume video playback

### FlutterApi (Flutter → Native)
Methods that Flutter can call on native platforms:

#### Analytics
- `trackEvent()` - Send analytics events (appear, click, page_view)

#### Button Events
- `onBeforeLikeButtonClick()` - Before like action
- `onAfterLikeButtonClick()` - After like action
- `onShareButtonClick()` - Share button clicked

#### State Events
- `onScreenStateChanged()` - Screen lifecycle changes
- `onVideoStateChanged()` - Video playback state changes

#### Navigation
- `onSwipeLeft()` - Swipe left gesture (navigate back)
- `onSwipeRight()` - Swipe right gesture (open native screen)

## Data Classes

- `AnalyticsEvent` - Analytics event with type and data
- `ShareData` - Share information (URL, title, description, thumbnail)
- `ScreenStateData` - Screen state information
- `VideoStateData` - Video playback state

## Usage Example

### In Flutter:
```dart
// Send analytics event
FlutterReelsAnalyticsApi.trackEvent(
  AnalyticsEvent(
    type: 'click',
    data: {'element': 'like_button', 'video_id': '123'}
  )
);

// Handle swipe right
FlutterReelsNavigationApi.onSwipeRight();
```

### In Android (Kotlin):
```kotlin
// Set up API listener
FlutterReelsAnalyticsApi.setUp(binaryMessenger) { event ->
    Analytics.track(event.type, event.data)
}

// Call Flutter
FlutterReelsHostApi(binaryMessenger).updateAccessToken("new_token")
```

### In iOS (Swift):
```swift
// Set up API listener
FlutterReelsAnalyticsApiSetup.setUp(
    binaryMessenger: binaryMessenger,
    api: AnalyticsHandler()
)

// Call Flutter
FlutterReelsHostApi(binaryMessenger: binaryMessenger)
    .updateAccessToken(token: "new_token")
```

## Best Practices

1. **Regenerate after changes** - Always run pigeon after modifying interfaces
2. **Document changes** - Add comments to explain new methods
3. **Version compatibility** - Test on both platforms after changes
4. **Error handling** - Handle PlatformExceptions in Flutter
5. **Null safety** - Use nullable types where appropriate

## Troubleshooting

### Code not generating?
- Check that pigeon is in dev_dependencies
- Run `flutter pub get` first
- Verify the input path is correct

### Compilation errors?
- Clean and rebuild: `flutter clean && flutter pub get`
- Check Pigeon version compatibility
- Verify import statements in generated code

### Runtime errors?
- Ensure native code implements the APIs
- Check that setup is called before use
- Verify data types match between platforms

## Learn More

- [Pigeon Documentation](https://pub.dev/packages/pigeon)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
