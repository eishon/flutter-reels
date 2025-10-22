# Flutter Reels Integration Flow

This document provides a visual overview of how Flutter Reels integrates with your native Android and iOS applications.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Native Application                           │
│                   (Android/iOS Main App)                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Initialize FlutterEngine
                              │ Setup Pigeon APIs
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FlutterEngine                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Platform Communication Layer                 │   │
│  │                  (Pigeon APIs)                           │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │  1. Analytics API      → Track events                    │   │
│  │  2. Token API          → Provide auth tokens             │   │
│  │  3. ButtonEvents API   → Handle like/share actions       │   │
│  │  4. StateEvents API    → Track screen/video states       │   │
│  │  5. Navigation API     → Handle swipe gestures           │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Bidirectional Communication
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Flutter Reels Module                          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                 Presentation Layer                        │   │
│  │  - ReelsScreen (Full-screen vertical video player)       │   │
│  │  - VideoPlayerWidget                                     │   │
│  │  - EngagementButtons (Like, Share, Comments)             │   │
│  │  - VideoDescription                                      │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                   Business Logic                          │   │
│  │  - VideoProvider (State management)                      │   │
│  │  - UseCases (GetVideos, ToggleLike, Share, etc.)        │   │
│  │  - Platform Services (Analytics, Token, Events)          │   │
│  └──────────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    Data Layer                             │   │
│  │  - Video Repository                                      │   │
│  │  - Local Data Source (Mock videos)                       │   │
│  │  - Models & Entities (Video, User, Product)              │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Initialization Flow

### Android (Kotlin)

```
App Startup
    │
    ├─► Application.onCreate()
    │       │
    │       ├─► Create FlutterEngine
    │       │       └─► executeDartEntrypoint()
    │       │
    │       ├─► Cache Engine (FlutterEngineCache)
    │       │
    │       └─► Setup Pigeon APIs
    │               ├─► Analytics API
    │               ├─► Token API
    │               ├─► ButtonEvents API
    │               ├─► StateEvents API
    │               └─► Navigation API
    │
    └─► User Clicks "Open Reels"
            │
            └─► ReelsActivity.launch()
                    │
                    ├─► getCachedEngineId()
                    │       └─► Return "flutter_reels_engine"
                    │
                    └─► Flutter Reels Displays
                            └─► Start playing videos
```

### iOS (Swift)

```
App Startup
    │
    ├─► AppDelegate.didFinishLaunchingWithOptions
    │       │
    │       ├─► Create FlutterEngine
    │       │       └─► engine.run()
    │       │
    │       ├─► Store Engine Reference
    │       │
    │       └─► Setup Pigeon APIs
    │               ├─► Analytics API
    │               ├─► Token API
    │               ├─► ButtonEvents API
    │               ├─► StateEvents API
    │               └─► Navigation API
    │
    └─► User Taps "Open Reels"
            │
            └─► Present ReelsViewController
                    │
                    ├─► Initialize with cached engine
                    │
                    └─► Flutter Reels Displays
                            └─► Start playing videos
```

## 📡 Communication Flow

### Flutter → Native (Events)

```
Flutter Reels                           Native App
    │                                       │
    ├─► Video Appears                       │
    │   └─► AnalyticsApi.trackEvent() ─────►│─► Track in analytics platform
    │                                       │
    ├─► User Clicks Like                    │
    │   ├─► ButtonEventsApi.onBeforeLike()─►│─► Check authentication
    │   │                                   │
    │   ├─► Toggle like state               │
    │   │                                   │
    │   └─► ButtonEventsApi.onAfterLike()──►│─► Sync with backend
    │                                       │
    ├─► User Clicks Share                   │
    │   └─► ButtonEventsApi.onAfterShare()─►│─► Open native share sheet
    │                                       │
    ├─► Screen State Changes                │
    │   └─► StateApi.onScreenStateChanged()►│─► Pause/resume videos
    │                                       │
    ├─► Video State Changes                 │
    │   └─► StateApi.onVideoStateChanged()─►│─► Track playback metrics
    │                                       │
    └─► User Swipes Left/Right              │
        └─► NavigationApi.onSwipe()────────►│─► Navigate to profile/back
```

### Native → Flutter (Data)

```
Native App                             Flutter Reels
    │                                       │
    └─► Flutter Needs Access Token          │
            │                               │
            └─► TokenApi.getAccessToken()───►│─► Callback invoked
                    │                       │
                    ├─► Fetch from keychain │
                    │                       │
                    └─► Return token ───────►│─► Use for API calls
```

## 🚀 Launch Sequence

```
┌─────────────────────────────────────────────────────────────────┐
│  Phase 1: App Startup (Background - Happens Once)               │
├─────────────────────────────────────────────────────────────────┤
│  1. Initialize FlutterEngine          [~200-300ms]              │
│  2. Execute Dart entrypoint            [~300-500ms]              │
│  3. Setup Pigeon APIs                  [~10-20ms]                │
│  4. Cache engine                       [~5ms]                    │
│                                                                  │
│  Total First Initialization: ~515-825ms                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 2: First Reels Launch                                    │
├─────────────────────────────────────────────────────────────────┤
│  1. Create ReelsActivity/ViewController [~50ms]                  │
│  2. Attach cached engine                [~10ms]                  │
│  3. Flutter renders first frame         [~100-200ms]             │
│  4. Load video data                     [~50-100ms]              │
│  5. Start video playback                [~100-200ms]             │
│                                                                  │
│  Total First Launch: ~310-560ms                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 3: Subsequent Launches (Engine Warm)                     │
├─────────────────────────────────────────────────────────────────┤
│  1. Create Activity/ViewController      [~50ms]                  │
│  2. Attach cached engine                [~10ms]                  │
│  3. Flutter renders (already warm)      [~50-100ms]              │
│                                                                  │
│  Total: ~110-160ms ⚡ (Much faster!)                             │
└─────────────────────────────────────────────────────────────────┘
```

## 🎯 Integration Steps Summary

### Android

```
1. MyApplication.kt
   └─► Initialize FlutterEngine
   └─► Setup all 5 Pigeon APIs
   └─► Implement handler callbacks

2. AndroidManifest.xml
   └─► Set android:name=".MyApplication"

3. ReelsActivity.kt
   └─► Extend FlutterActivity
   └─► Return cached engine ID
   └─► Set shouldDestroyEngineWithHost = false

4. Launch
   └─► ReelsActivity.launch(context)
```

### iOS

```
1. AppDelegate.swift
   └─► Initialize FlutterEngine in didFinishLaunchingWithOptions
   └─► Setup all 5 Pigeon APIs
   └─► Implement handler classes

2. Handler Classes
   └─► AnalyticsHandler
   └─► ButtonEventsHandler
   └─► StateEventsHandler
   └─► NavigationHandler
   └─► TokenProvider

3. ReelsViewController.swift
   └─► Extend FlutterViewController
   └─► Initialize with cached engine

4. Launch
   └─► present(ReelsViewController(), animated: true)
```

## 📊 API Communication Matrix

| API                  | Direction         | Purpose                      | When Called                    |
|----------------------|-------------------|------------------------------|--------------------------------|
| Analytics API        | Flutter → Native  | Track events                 | Video view, clicks, page views |
| Token API            | Native → Flutter  | Provide auth token           | When Flutter needs token       |
| ButtonEvents API     | Flutter → Native  | Like/Share callbacks         | Before/after user actions      |
| StateEvents API      | Flutter → Native  | Screen/video states          | State changes                  |
| Navigation API       | Flutter → Native  | Swipe gestures               | User swipes left/right         |

## 🔐 Security Flow (Token API)

```
Flutter Needs Token
    │
    └─► Call TokenApi.getAccessToken()
            │
            ▼
    Native Token Provider
            │
            ├─► Check if token exists
            │
            ├─► If exists:
            │   └─► callback.onTokenReceived(token)
            │
            └─► If not exists:
                └─► callback.onTokenError("No token")
```

## 💡 Best Practices

1. **Initialize Early**: Setup FlutterEngine in Application/AppDelegate
2. **Cache Engine**: Reuse same engine for faster launches
3. **Keep Engine Alive**: Don't destroy engine when host closes
4. **Implement All APIs**: Even if you don't need them now, implement with empty callbacks
5. **Handle Errors**: Always handle token errors and API failures gracefully

## 📚 Documentation References

- **Quick Start**: [NATIVE_INITIALIZATION.md](./NATIVE_INITIALIZATION.md)
- **Complete Guide**: [NATIVE_INTEGRATION.md](./NATIVE_INTEGRATION.md)
- **API Details**: [pigeon/README.md](./flutter_reels/pigeon/README.md)
- **Advanced Navigation**: [MULTI_INSTANCE_NAVIGATION.md](./MULTI_INSTANCE_NAVIGATION.md)

---

**Ready to integrate?** Start with [NATIVE_INITIALIZATION.md](./NATIVE_INITIALIZATION.md) for step-by-step instructions!
