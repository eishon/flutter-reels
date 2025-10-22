# reels_flutter# reels_flutter



**Flutter Module for Add-to-App Integration**A new Flutter module project.



This is a Flutter module that provides the reels UI implementation. It's designed to be embedded in native Android and iOS apps using Flutter's Add-to-App pattern.## Getting Started



---For help getting started with Flutter development, view the online

[documentation](https://flutter.dev/).

## ⚠️ Important Note for Users

For instructions integrating Flutter modules to your existing applications,

**Don't integrate this module directly!** see the [add-to-app documentation](https://flutter.dev/to/add-to-app).


Instead, use our native SDKs:
- **Android**: Use `reels_android` (Kotlin wrapper)
- **iOS**: Use `reels_ios` (Swift wrapper)

These SDKs embed this Flutter module for you and provide clean, native APIs. You don't need Flutter or Pigeon knowledge to use them.

**👉 See [ADD_TO_APP_GUIDE.md](../ADD_TO_APP_GUIDE.md) for integration instructions**

---

## 📚 For Contributors

If you're contributing to this project, here's what this module contains:

### Structure

```
reels_flutter/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── core/
│   │   ├── di/                      # Dependency injection
│   │   └── pigeon_generated.dart    # Generated platform code
│   ├── data/                        # Data layer
│   │   ├── datasources/            # Local data sources
│   │   ├── models/                 # Data models
│   │   └── repositories/           # Repository implementations
│   ├── domain/                      # Domain layer
│   │   ├── entities/               # Business entities
│   │   ├── repositories/           # Repository contracts
│   │   └── usecases/               # Business logic
│   └── presentation/                # Presentation layer
│       ├── providers/              # State management
│       ├── screens/                # UI screens
│       └── widgets/                # Reusable widgets
├── pigeons/
│   └── messages.dart                # Pigeon API definitions
├── test/                            # Tests (329+)
└── .android/                        # Android integration
    └── .ios/                        # iOS integration
```

### Key Technologies

- **Clean Architecture**: Separation of concerns (Domain, Data, Presentation)
- **Pigeon**: Type-safe platform channel communication
- **Dependency Injection**: Using `get_it`
- **State Management**: Using `provider`
- **Testing**: 329+ unit tests with 95%+ coverage

### Development Setup

See [../SETUP.md](../SETUP.md) for complete development environment setup.

### Building

```bash
# Get dependencies
flutter pub get

# Generate Pigeon code
dart run pigeon --input pigeons/messages.dart

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

### Pigeon API

The module communicates with native platforms through Pigeon-generated APIs:

- **Analytics**: Track video views, likes, shares
- **Token Management**: Handle authentication
- **Button Events**: Before/after like and share callbacks
- **Screen State**: Track screen lifecycle
- **Video Playback**: Track playback states
- **Navigation**: Handle swipe gestures

See `pigeons/messages.dart` for API definitions.

### Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/unit/data/datasources/video_local_data_source_test.dart

# Run with coverage
flutter test --coverage
```

**Test Coverage**: 95%+ across all layers

### Architecture

This module follows Clean Architecture principles:

1. **Domain Layer**: Business logic and entities (independent of frameworks)
2. **Data Layer**: Data sources and repository implementations
3. **Presentation Layer**: UI and state management

**Dependency Rule**: Dependencies point inward (Presentation → Data → Domain)

---

## 🔗 Related Documentation

- [ADD_TO_APP_GUIDE.md](../ADD_TO_APP_GUIDE.md) - For users integrating the native SDKs
- [SETUP.md](../SETUP.md) - For contributors setting up development environment
- [PUBLISHING.md](../PUBLISHING.md) - For maintainers releasing new versions

---

## 📄 License

See [../LICENSE](../LICENSE)
