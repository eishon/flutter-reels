# Flutter Reels - Gradle Integration Guide

## 🚀 Super Easy Integration (Recommended)

Just add Flutter Reels as a Gradle dependency - no manual downloads needed!

### Step 1: Update settings.gradle

Add the Flutter Reels Maven repository to your `settings.gradle`:

```gradle
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // Flutter repository (required for Flutter SDK)
        maven {
            url 'https://storage.googleapis.com/download.flutter.io'
        }
        
        // Flutter Reels Maven repository
        maven {
            url 'https://raw.githubusercontent.com/eishon/flutter-reels/releases/'
        }
    }
}
```

**For Kotlin DSL (settings.gradle.kts):**

```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        
        maven {
            url = uri("https://raw.githubusercontent.com/eishon/flutter-reels/releases/")
        }
    }
}
```

### Step 2: Add Dependency

Add the dependency to your `app/build.gradle`:

```gradle
dependencies {
    // Your existing dependencies
    implementation 'androidx.appcompat:appcompat:1.6.1'
    
    // Flutter Reels module
    implementation 'com.github.eishon:flutter_reels:0.0.1'
}
```

**For Kotlin DSL (build.gradle.kts):**

```kotlin
dependencies {
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.github.eishon:flutter_reels:0.0.1")
}
```

### Step 3: Sync Gradle

Click "Sync Now" in Android Studio or run:

```bash
./gradlew build
```

That's it! The AAR will be automatically downloaded and integrated.

## 📋 Complete Example

### settings.gradle (Full Example)

```gradle
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // Flutter SDK repository
        maven {
            url 'https://storage.googleapis.com/download.flutter.io'
        }
        
        // Flutter Reels Maven repository
        maven {
            url 'https://raw.githubusercontent.com/eishon/flutter-reels/releases/'
        }
    }
}

rootProject.name = "My App"
include ':app'
```

### app/build.gradle (Full Example)

```gradle
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace 'com.example.myapp'
    compileSdk 33

    defaultConfig {
        applicationId "com.example.myapp"
        minSdk 21
        targetSdk 33
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.10.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    
    // Flutter Reels module
    implementation 'com.github.eishon:flutter_reels:0.0.1'
    
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
```

## 🎯 Usage in Code

### Kotlin Example

```kotlin
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        findViewById<Button>(R.id.btnLaunchFlutter).setOnClickListener {
            startActivity(
                FlutterActivity.createDefaultIntent(this)
            )
        }
    }
}
```

### Java Example

```java
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        findViewById(R.id.btnLaunchFlutter).setOnClickListener(v -> {
            startActivity(
                FlutterActivity.createDefaultIntent(this)
            );
        });
    }
}
```

## 📦 Version Updates

To update to a newer version, simply change the version number:

```gradle
implementation 'com.github.eishon:flutter_reels:0.0.2'  // Updated version
```

Check available versions at: https://github.com/eishon/flutter-reels/releases

## ✅ Advantages of Gradle Dependency

- ✅ **No manual downloads** - Gradle handles everything
- ✅ **Easy updates** - Just change version number
- ✅ **Version control** - Track which version you're using
- ✅ **Team friendly** - Everyone gets the same version automatically
- ✅ **CI/CD ready** - Works seamlessly in automated builds

## 🔍 Troubleshooting

### Issue: Repository not found

Make sure you added the Maven repository correctly in `settings.gradle`, not in the module's `build.gradle`.

### Issue: Dependency not found

1. Check that the version number is correct
2. Verify you have internet connection
3. Try invalidating cache: Build → Clean Project → Rebuild Project

### Issue: Build errors

Make sure you have the Flutter repository added:

```gradle
maven {
    url 'https://storage.googleapis.com/download.flutter.io'
}
```

## 📚 More Information

- Full integration guide: [README.md](../flutter_reels/README.md)
- Example code: [android-integration.md](./android-integration.md)
- Repository: https://github.com/eishon/flutter-reels

---

**Made with ❤️ by eishon**
