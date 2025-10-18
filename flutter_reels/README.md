# Flutter Reels Module

A Flutter module that can be integrated into native Android and iOS applications. This module displays a simple "Hello World" screen and serves as a foundation for building reels/stories functionality.

## 📱 Features

- ✅ Simple "Hello World" screen
- ✅ Ready for integration into native Android apps
- ✅ Ready for integration into native iOS apps
- ✅ Automated builds via GitHub Actions
- ✅ Published releases for easy distribution

## 🚀 Integration Guide

### For Android (Native)

#### Prerequisites
- Android Studio
- Minimum SDK: 21 (Android 5.0)
- Gradle 7.0 or higher

#### Step 1: Add Flutter Module as Dependency

There are three methods to integrate the Flutter module:

##### Method A: Using Gradle Dependency (Recommended - Easiest)

1. Update your `settings.gradle` (or `settings.gradle.kts`):
   ```gradle
   dependencyResolutionManagement {
       repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
       repositories {
           google()
           mavenCentral()
           
           // Flutter repository
           maven {
               url 'https://storage.googleapis.com/download.flutter.io'
           }
           
           // Flutter Reels repository
           maven {
               url 'https://raw.githubusercontent.com/eishon/flutter-reels/releases/'
           }
       }
   }
   ```

2. Update your `app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 33
       
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 33
       }
       
       compileOptions {
           sourceCompatibility JavaVersion.VERSION_1_8
           targetCompatibility JavaVersion.VERSION_1_8
       }
   }

   dependencies {
       // Flutter Reels module
       implementation 'com.github.eishon:flutter_reels:0.0.1'
       
       // Required for Flutter
       implementation 'androidx.appcompat:appcompat:1.6.1'
       implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.1'
   }
   ```

3. Sync your project with Gradle files

That's it! The AAR will be automatically downloaded and integrated.

##### Method B: Using AAR File Manually

1. Download the latest AAR from the [Releases](https://github.com/eishon/flutter-reels/releases) page

2. Add the AAR to your Android project:
   ```
   your-android-app/
     app/
       libs/
         flutter_reels-release.aar  // Place the AAR here
   ```

3. Update your `app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 33
       
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 33
       }
       
       compileOptions {
           sourceCompatibility JavaVersion.VERSION_1_8
           targetCompatibility JavaVersion.VERSION_1_8
       }
   }

   dependencies {
       implementation fileTree(dir: 'libs', include: ['*.aar'])
       
       // Required for Flutter
       implementation 'androidx.appcompat:appcompat:1.6.1'
       implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.1'
   }
   ```

4. Update your `settings.gradle`:
   ```gradle
   dependencyResolutionManagement {
       repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
       repositories {
           google()
           mavenCentral()
           maven {
               url 'https://storage.googleapis.com/download.flutter.io'
           }
       }
   }
   ```

##### Method C: Using Source (For Development)

1. Clone this repository next to your Android project:
   ```
   your-projects/
     flutter-reels/
       flutter_reels/
     your-android-app/
   ```

2. Update your `settings.gradle`:
   ```gradle
   setBinding(new Binding([gradle: this]))
   evaluate(new File(
       settingsDir.parentFile,
       'flutter-reels/flutter_reels/.android/include_flutter.groovy'
   ))

   include ':app'
   ```

3. Update your `app/build.gradle`:
   ```gradle
   dependencies {
       implementation project(':flutter')
   }
   ```

#### Step 2: Add Flutter Activity to Your App

##### For Kotlin:

```kotlin
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Launch Flutter module
        findViewById<Button>(R.id.launchFlutterButton).setOnClickListener {
            startActivity(
                FlutterActivity.createDefaultIntent(this)
            )
        }
    }
}
```

##### For Java:

```java
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Launch Flutter module
        findViewById(R.id.launchFlutterButton).setOnClickListener(v -> {
            startActivity(
                FlutterActivity.createDefaultIntent(this)
            );
        });
    }
}
```

#### Step 3: Update AndroidManifest.xml

Add the Flutter activity to your `AndroidManifest.xml`:

```xml
<application>
    <!-- Your existing activities -->
    
    <activity
        android:name="io.flutter.embedding.android.FlutterActivity"
        android:theme="@style/LaunchTheme"
        android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
        android:hardwareAccelerated="true"
        android:windowSoftInputMode="adjustResize"
        />
</application>
```

---

### For iOS (Native)

#### Prerequisites
- Xcode 14.0 or higher
- CocoaPods 1.10 or higher
- iOS 12.0 or higher

#### Step 1: Add Flutter Module

There are two methods to integrate the Flutter module:

##### Method A: Using Framework (Recommended for Release)

1. Download the latest iOS framework from the [Releases](https://github.com/eishon/flutter-reels/releases) page

2. Create a `Flutter` folder in your iOS project:
   ```
   your-ios-app/
     Flutter/
       Flutter.xcframework
       App.xcframework
   ```

3. In Xcode, add the frameworks to your project:
   - Select your project in the navigator
   - Select your target
   - Go to "General" tab → "Frameworks, Libraries, and Embedded Content"
   - Click "+" and add both `.xcframework` files
   - Set "Embed & Sign" for both frameworks

4. Update your Build Settings:
   - Build Settings → Framework Search Paths: `$(PROJECT_DIR)/Flutter`

##### Method B: Using Source (For Development)

1. Clone this repository next to your iOS project:
   ```
   your-projects/
     flutter-reels/
       flutter_reels/
     your-ios-app/
   ```

2. Create/update your `Podfile`:
   ```ruby
   platform :ios, '12.0'

   flutter_application_path = '../flutter-reels/flutter_reels'
   load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

   target 'YourApp' do
     use_frameworks!
     install_all_flutter_pods(flutter_application_path)
   end

   post_install do |installer|
     flutter_post_install(installer) if defined?(flutter_post_install)
   end
   ```

3. Run:
   ```bash
   pod install
   ```

#### Step 2: Add Flutter View Controller

##### For Swift:

```swift
import UIKit
import Flutter

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func launchFlutterModule(_ sender: UIButton) {
        let flutterEngine = FlutterEngine(name: "flutter_reels_engine")
        flutterEngine.run()
        
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        present(flutterViewController, animated: true, completion: nil)
    }
}
```

##### For Objective-C:

```objective-c
#import <Flutter/Flutter.h>
#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)launchFlutterModule:(UIButton *)sender {
    FlutterEngine *flutterEngine = [[FlutterEngine alloc] initWithName:@"flutter_reels_engine"];
    [flutterEngine run];
    
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] 
                                                    initWithEngine:flutterEngine 
                                                    nibName:nil 
                                                    bundle:nil];
    
    [self presentViewController:flutterViewController animated:YES completion:nil];
}

@end
```

#### Step 3: Update Info.plist

Add the following to your `Info.plist`:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

---

## 🔧 Development

### Running the Module Standalone

You can run the Flutter module standalone for development:

```bash
cd flutter_reels
flutter run
```

### Building for Release

#### Android AAR:
```bash
cd flutter_reels
flutter build aar
```

The AAR will be generated at:
```
flutter_reels/build/host/outputs/repo/com/example/flutter_reels/flutter_release/1.0/
```

#### iOS Framework:
```bash
cd flutter_reels
flutter build ios-framework
```

The frameworks will be generated at:
```
flutter_reels/build/ios/framework/Release/
```

---

## 📦 Automated Releases

This repository includes GitHub Actions workflows that automatically build and publish releases:

1. **Android Build**: Generates AAR files for Android integration
2. **iOS Build**: Generates XCFramework files for iOS integration
3. **Release Publishing**: Creates GitHub releases with downloadable artifacts

To trigger a release:
1. Push a tag: `git tag v1.0.0 && git push origin v1.0.0`
2. GitHub Actions will automatically build and create a release

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 💬 Support

For issues, questions, or suggestions, please [open an issue](https://github.com/eishon/flutter-reels/issues) on GitHub.

---

Made with ❤️ using Flutter
