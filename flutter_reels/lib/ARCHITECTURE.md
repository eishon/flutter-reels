# Clean Architecture - Reels App

This project follows Clean Architecture principles to maintain separation of concerns and testability.

## 📁 Folder Structure

```
lib/
├── core/                          # Core functionality
│   ├── di/                        # Dependency injection
│   ├── error/                     # Error handling
│   └── utils/                     # Utilities & constants
│
├── domain/                        # Business Logic Layer (Pure Dart)
│   ├── entities/                  # Business objects (Plain Dart classes)
│   ├── repositories/              # Repository interfaces (Contracts)
│   └── usecases/                  # Business logic use cases
│
├── data/                          # Data Layer
│   ├── models/                    # Data models with JSON serialization
│   ├── datasources/               # Data sources (API, Local, Cache)
│   └── repositories/              # Repository implementations
│
└── presentation/                  # Presentation Layer (Flutter UI)
    ├── providers/                 # State management (Provider)
    ├── screens/                   # Full screen widgets
    └── widgets/                   # Reusable UI components
```

## 🔄 Data Flow

```
View → Provider → UseCase → Repository → DataSource → JSON
                    ↓
                 Entity
```

### Flow Explanation:

1. **View (Widget)** - Displays data and handles user interactions
2. **Provider** - Manages state and business logic coordination
3. **UseCase** - Contains specific business logic
4. **Repository** - Abstract interface (contract)
5. **Repository Implementation** - Concrete implementation
6. **DataSource** - Handles data retrieval (local/remote)
7. **Model** - Data structure with JSON parsing
8. **Entity** - Clean business object

## 📦 Layers

### Domain Layer (Pure Dart - No Flutter)
**Purpose**: Contains business logic and entities
- ✅ Independent of frameworks
- ✅ Testable without Flutter
- ✅ Defines contracts (interfaces)

### Data Layer
**Purpose**: Handles data operations
- Implements repository interfaces
- Manages data sources (JSON, API, Database)
- Transforms data models to domain entities

### Presentation Layer
**Purpose**: UI and user interactions
- Widgets and screens
- State management with Provider
- Depends on domain layer only

### Core Layer
**Purpose**: Shared utilities
- Dependency injection setup
- Error handling
- Constants and utilities

## 🎯 Benefits

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Clear separation of concerns
3. **Scalability**: Easy to add new features
4. **Flexibility**: Can swap implementations easily
5. **Independence**: Domain layer independent of frameworks

## 📝 Naming Conventions

- **Entities**: `VideoEntity`, `UserEntity`
- **Models**: `VideoModel`, `UserModel` 
- **Repositories**: `VideoRepository` (interface), `VideoRepositoryImpl` (implementation)
- **Use Cases**: `GetVideosUseCase`, `LikeVideoUseCase`
- **Providers**: `VideoProvider`, `UserProvider`
- **Screens**: `ReelsScreen`, `ProfileScreen`
- **Widgets**: `VideoPlayerWidget`, `ActionButton`

## 🔌 Dependency Rule

**Dependencies flow inward:**
- Presentation → Domain
- Data → Domain
- Core → (can be used by all)

**Domain layer should NOT depend on:**
- Flutter framework
- External libraries (except Dart core)
- Other layers
