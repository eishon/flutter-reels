# Android Integration Example

This directory contains example code for integrating the Flutter Reels module into a native Android app.

## Quick Start Example

### MainActivity.kt

```kotlin
package com.example.myapp

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : AppCompatActivity() {
    
    companion object {
        private const val FLUTTER_ENGINE_ID = "flutter_reels_engine"
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Method 1: Simple approach - Launch directly
        findViewById<Button>(R.id.btnLaunchFlutterSimple).setOnClickListener {
            launchFlutterSimple()
        }
        
        // Method 2: Pre-warmed engine approach (recommended for better performance)
        findViewById<Button>(R.id.btnLaunchFlutterOptimized).setOnClickListener {
            launchFlutterOptimized()
        }
    }
    
    /**
     * Simple method to launch Flutter module
     * This creates a new FlutterActivity each time
     */
    private fun launchFlutterSimple() {
        startActivity(
            FlutterActivity.createDefaultIntent(this)
        )
    }
    
    /**
     * Optimized method with pre-warmed FlutterEngine
     * This provides better performance and faster startup
     */
    private fun launchFlutterOptimized() {
        // Get or create a cached FlutterEngine
        var flutterEngine = FlutterEngineCache
            .getInstance()
            .get(FLUTTER_ENGINE_ID)
        
        if (flutterEngine == null) {
            // Create and cache the FlutterEngine
            flutterEngine = FlutterEngine(this)
            flutterEngine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            FlutterEngineCache
                .getInstance()
                .put(FLUTTER_ENGINE_ID, flutterEngine)
        }
        
        // Launch FlutterActivity with the cached engine
        startActivity(
            FlutterActivity
                .withCachedEngine(FLUTTER_ENGINE_ID)
                .build(this)
        )
    }
    
    override fun onDestroy() {
        // Optional: Remove the cached engine when no longer needed
        // FlutterEngineCache.getInstance().remove(FLUTTER_ENGINE_ID)
        super.onDestroy()
    }
}
```

### activity_main.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Flutter Reels Integration Demo"
        android:textSize="24sp"
        android:textStyle="bold"
        android:layout_marginBottom="32dp"/>

    <Button
        android:id="@+id/btnLaunchFlutterSimple"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Launch Flutter (Simple)"
        android:layout_marginBottom="16dp"/>

    <Button
        android:id="@+id/btnLaunchFlutterOptimized"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Launch Flutter (Optimized)"/>

</LinearLayout>
```

### app/build.gradle

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
    
    // Flutter module dependency
    // Method A: Using AAR from libs folder
    implementation fileTree(dir: 'libs', include: ['*.aar'])
    
    // Method B: Using project dependency (for source integration)
    // implementation project(':flutter')
}
```

### AndroidManifest.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/Theme.AppCompat.Light">
        
        <!-- Your main activity -->
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
        <!-- Flutter activity -->
        <activity
            android:name="io.flutter.embedding.android.FlutterActivity"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize"
            android:exported="false" />
            
    </application>

</manifest>
```

## Using with Jetpack Compose

If you're using Jetpack Compose, here's how to integrate:

```kotlin
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import io.flutter.embedding.android.FlutterActivity

@Composable
fun MainScreen() {
    val context = LocalContext.current
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "Flutter Reels Integration",
            style = MaterialTheme.typography.headlineMedium
        )
        
        Spacer(modifier = Modifier.height(32.dp))
        
        Button(
            onClick = {
                context.startActivity(
                    FlutterActivity.createDefaultIntent(context)
                )
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Launch Flutter Module")
        }
    }
}
```

## Advanced: Using FlutterFragment

For embedding Flutter within your activity:

```kotlin
import io.flutter.embedding.android.FlutterFragment

class ContainerActivity : AppCompatActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_container)
        
        if (savedInstanceState == null) {
            val flutterFragment = FlutterFragment.createDefault()
            
            supportFragmentManager
                .beginTransaction()
                .add(R.id.fragment_container, flutterFragment)
                .commit()
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Build errors**: Ensure you have the correct Gradle version and dependencies
2. **Runtime crashes**: Check that all required Flutter dependencies are included
3. **Performance issues**: Use the pre-warmed engine approach for better performance

For more help, see the [main README](../flutter_reels/README.md).
