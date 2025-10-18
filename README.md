# Flutter Reels - Maven Repository

This branch contains the Maven repository for Flutter Reels AAR packages.

## Usage

Add this to your `settings.gradle`:

```gradle
dependencyResolutionManagement {
    repositories {
        maven {
            url = uri("https://raw.githubusercontent.com/eishon/flutter-reels/releases/")
        }
    }
}
```

Add the dependency in your `app/build.gradle`:

```gradle
dependencies {
    implementation 'com.github.eishon:flutter_reels:0.0.2'
}
```

For more information, visit: https://github.com/eishon/flutter-reels
