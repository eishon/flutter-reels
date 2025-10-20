# Native Integration Implementation Plan

**Date:** October 21, 2025  
**Version:** 0.0.3  
**Purpose:** Integrate Flutter Reels with native Android/iOS applications

---

## Overview

This document outlines the native integration strategy using **Pigeon** for type-safe communication between Flutter and native platforms.

---

## 1. Technology Choice: Pigeon

### Why Pigeon?

✅ **Type Safety** - Compile-time error checking  
✅ **Auto-generated Code** - Less boilerplate  
✅ **Bi-directional Communication** - Host → Flutter and Flutter → Host  
✅ **Complex Data Structures** - Easy to define and maintain  
✅ **Null Safety** - Built-in support  

### Pigeon Setup

```yaml
# pubspec.yaml
dev_dependencies:
  pigeon: ^22.0.0
```

---

## 2. Communication Interfaces

### 2.1 Access Token Management

**Use Case:** Native app passes auth token to Flutter (can change periodically)

**Direction:** Native → Flutter

**Interface:**
```dart
// pigeon/messages.dart
@HostApi()
abstract class FlutterReelsHostApi {
  void updateAccessToken(String token);
  void clearAccessToken();
}
```

**Usage:**
- Native app calls `updateAccessToken()` when token refreshes
- Flutter stores token in memory
- Used for video API calls, analytics, etc.

---

### 2.2 Analytics Events

**Use Case:** Send analytics from Flutter to native analytics SDK

**Direction:** Flutter → Native

**Event Types:**
1. **appear** - Screen/video appeared
2. **click** - User interaction (button, element)
3. **page_view** - Page navigation

**Interface:**
```dart
@FlutterApi()
abstract class FlutterReelsAnalyticsApi {
  void trackEvent(AnalyticsEvent event);
}

class AnalyticsEvent {
  final String type; // "appear", "click", "page_view"
  final Map<String, Object> data;
}
```

**Examples:**
```dart
// Video appeared
trackEvent(AnalyticsEvent(
  type: 'appear',
  data: {'video_id': '123', 'position': 0}
));

// Like button clicked
trackEvent(AnalyticsEvent(
  type: 'click',
  data: {'element': 'like_button', 'video_id': '123'}
));

// Page view
trackEvent(AnalyticsEvent(
  type: 'page_view',
  data: {'screen': 'reels_screen'}
));
```

---

### 2.3 Like Button Events

**Use Case:** Notify native before/after like button interaction

**Direction:** Flutter → Native

**Interface:**
```dart
@FlutterApi()
abstract class FlutterReelsButtonEventsApi {
  void onBeforeLikeButtonClick(String videoId);
  void onAfterLikeButtonClick(String videoId, bool isLiked);
}
```

**Flow:**
1. User taps like button
2. `onBeforeLikeButtonClick()` called → Native can show loading
3. Like action processed
4. `onAfterLikeButtonClick()` called → Native updates state

---

### 2.4 Share Button Events

**Use Case:** Notify native when share is triggered

**Direction:** Flutter → Native

**Interface:**
```dart
@FlutterApi()
abstract class FlutterReelsButtonEventsApi {
  void onShareButtonClick(String videoId, ShareData shareData);
}

class ShareData {
  final String videoUrl;
  final String title;
  final String description;
  final String? thumbnailUrl;
}
```

---

### 2.5 Screen State Events

**Use Case:** Track video playback and screen lifecycle

**Direction:** Flutter → Native

**States:**
- **focus** - Screen is active and visible
- **playing** - Video is currently playing
- **idle** - Video paused/not playing
- **paused** - Explicitly paused (e.g., native screen overlay)

**Interface:**
```dart
@FlutterApi()
abstract class FlutterReelsStateApi {
  void onScreenStateChanged(ScreenState state);
}

enum ScreenState {
  focused,
  unfocused,
  playing,
  idle,
  paused
}
```

**Use Cases:**
- `focused` - ReelsScreen gains focus
- `unfocused` - User navigates away or native screen opens
- `playing` - Video starts playing
- `idle` - Video stopped/ended
- `paused` - Video paused (manual or automatic)

---

### 2.6 Navigation & Swipe Events

**Use Case:** 
- Swipe left → Navigate back (native navigation)
- Swipe right → Open native screen on top of Flutter

**Direction:** Flutter → Native

**Interface:**
```dart
@FlutterApi()
abstract class FlutterReelsNavigationApi {
  void onSwipeLeft(); // Trigger native back navigation
  void onSwipeRight(); // Open native screen
  void onNativeScreenOpened(); // Notify Flutter to pause video
  void onNativeScreenClosed(); // Notify Flutter to resume video
}
```

**Native → Flutter (for pause/resume):**
```dart
@HostApi()
abstract class FlutterReelsHostApi {
  void pauseVideos(); // Called when native screen opens
  void resumeVideos(); // Called when native screen closes
}
```

---

## 3. Multi-Screen Support

**Scenario:** Multiple Flutter screens mixed with native screens

```
Native Screen A
  └─ Flutter Reels Screen 1
      └─ Native Screen B (opened from swipe right)
          └─ Flutter Reels Screen 2
              └─ Native Screen C
```

**Requirements:**
1. Each Flutter screen instance maintains its own state
2. Videos pause when screen loses focus
3. Videos resume when screen regains focus
4. Proper lifecycle management

**Implementation:**
- Use `RouteAware` (already implemented) to detect focus
- Use `WidgetsBindingObserver` for app lifecycle
- Native screens trigger pause/resume via Pigeon

---

## 4. Implementation Phases

### Phase 1: Setup Pigeon ✅
- Add Pigeon dependency
- Create `pigeon/messages.dart` with all interfaces
- Generate platform code
- **Commit:** "chore: add Pigeon for native integration"

### Phase 2: Access Token Interface ✅
- Implement `FlutterReelsHostApi` for token management
- Create token storage service in Flutter
- Update video repository to use token
- **Commit:** "feat: add access token interface for native integration"

### Phase 3: Analytics Interface ✅
- Implement `FlutterReelsAnalyticsApi`
- Create analytics service wrapper
- Track video views, likes, shares
- **Commit:** "feat: add analytics interface for native event tracking"

### Phase 4: Button Events ✅
- Implement like button callbacks (before/after)
- Implement share button callback
- Update UI widgets to trigger events
- **Commit:** "feat: add button event callbacks for native integration"

### Phase 5: Screen State Events ✅
- Implement `FlutterReelsStateApi`
- Track screen focus/unfocus
- Track video playing/idle/paused
- **Commit:** "feat: add screen state tracking for native integration"

### Phase 6: Navigation & Swipe ✅
- Update swipe gesture handlers
- Add pause/resume on native screen overlay
- **Commit:** "feat: add navigation and swipe gesture integration"

### Phase 7: Documentation ✅
- Create native integration guide
- Add code examples for iOS/Android
- Update README
- **Commit:** "docs: add native integration guide and examples"

---

## 5. File Structure

```
flutter_reels/
├── pigeon/
│   └── messages.dart           # Pigeon interface definitions
├── lib/
│   ├── core/
│   │   ├── platform/
│   │   │   ├── flutter_reels_host_api.dart       # Native → Flutter
│   │   │   ├── flutter_reels_analytics_api.dart  # Flutter → Native
│   │   │   ├── flutter_reels_button_events_api.dart
│   │   │   ├── flutter_reels_state_api.dart
│   │   │   └── flutter_reels_navigation_api.dart
│   │   └── services/
│   │       ├── access_token_service.dart
│   │       └── native_analytics_service.dart
├── android/
│   └── src/main/kotlin/.../
│       └── FlutterReelsPlugin.kt    # Generated + custom code
├── ios/
│   └── Classes/
│       └── FlutterReelsPlugin.swift # Generated + custom code
└── docs/
    └── NATIVE_INTEGRATION.md        # Integration guide
```

---

## 6. Data Flow Examples

### Example 1: Video Like Flow

```
User taps Like Button
    ↓
Flutter: onBeforeLikeButtonClick("video123")
    ↓
Native: Show loading indicator
    ↓
Flutter: Process like (update state, call API)
    ↓
Flutter: onAfterLikeButtonClick("video123", true)
    ↓
Native: Hide loading, update UI
    ↓
Flutter: trackEvent(type: "click", data: {element: "like", video_id: "123"})
    ↓
Native: Send to analytics SDK (Firebase, Mixpanel, etc.)
```

### Example 2: Swipe Right Flow

```
User swipes right
    ↓
Flutter: onSwipeRight()
    ↓
Native: Open native detail screen
    ↓
Native: Call pauseVideos()
    ↓
Flutter: Pause all video players
    ↓
Native: User closes detail screen
    ↓
Native: Call resumeVideos()
    ↓
Flutter: Resume video playback
```

### Example 3: Token Refresh Flow

```
Native: Token about to expire
    ↓
Native: Fetch new token from auth server
    ↓
Native: updateAccessToken("new_token_xyz")
    ↓
Flutter: Store new token
    ↓
Flutter: Use new token for subsequent API calls
```

---

## 7. Testing Strategy

### Unit Tests
- Token service logic
- Analytics event formatting
- State management

### Integration Tests
- Native → Flutter communication
- Flutter → Native callbacks
- Multi-screen scenarios

### Platform Tests
- **Android:** ExoPlayer integration
- **iOS:** AVPlayer integration
- Lifecycle events

---

## 8. Performance Considerations

### Memory Management
- Dispose video controllers when screens go background
- Clear analytics event queue periodically
- Limit number of Flutter instances

### Battery Optimization
- Pause videos when app backgrounds
- Reduce analytics frequency if needed
- Use efficient native players

### Network Efficiency
- Use token for authenticated requests
- Batch analytics events
- Implement retry logic

---

## 9. Security Considerations

### Access Token
- Never log tokens
- Clear token on logout
- Validate token expiry
- Secure storage on native side

### Analytics Data
- Sanitize PII (Personally Identifiable Information)
- Comply with GDPR/privacy regulations
- Allow analytics opt-out

---

## 10. Migration Path for Existing Apps

### For Native Apps Adding Flutter Reels

**Step 1:** Add Flutter module dependency
```gradle
// Android - settings.gradle
include ':flutter_reels'
project(':flutter_reels').projectDir = new File('../flutter_reels/.android')
```

**Step 2:** Initialize Pigeon APIs
```kotlin
// Android
class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Set up Pigeon APIs
        setupFlutterReelsHost()
        setupAnalyticsListener()
    }
}
```

**Step 3:** Pass initial token
```kotlin
FlutterReelsHostApi.updateAccessToken("initial_token")
```

**Step 4:** Listen for events
```kotlin
FlutterReelsAnalyticsApi.setup(binaryMessenger) { event ->
    // Send to your analytics SDK
    Analytics.track(event.type, event.data)
}
```

---

## Next Steps

1. Review and approve this plan
2. Begin Phase 1 implementation
3. Test each phase before proceeding
4. Update documentation incrementally
5. Create example native apps (Android & iOS)

---

*This is a living document - will be updated as implementation progresses*
