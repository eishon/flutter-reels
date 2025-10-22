# iOS Example App - Setup Instructions

## Option 1: Manual Xcode Setup (Recommended)

Since Xcode project files are complex to generate manually, follow these steps:

1. **Create Project in Xcode:**
   ```bash
   cd example/ios
   ```
   - Open Xcode
   - Create New Project → iOS → App
   - Product Name: `ReelsExample`
   - Organization Identifier: `com.eishon.reels`
   - Bundle Identifier: `com.eishon.reels.example`
   - Interface: Storyboard
   - Language: Swift
   - Save in: `example/ios/`

2. **Replace Files:**
   - Replace `AppDelegate.swift` with the provided file
   - Replace `ViewController.swift` with the provided file
   - Use the provided `Info.plist`

3. **Install Dependencies:**
   ```bash
   cd example/ios
   pod install
   ```

4. **Open Workspace:**
   ```bash
   open ReelsExample.xcworkspace
   ```

5. **Build and Run:**
   - Select a simulator or device
   - Press Cmd+R to build and run

## Option 2: Use Provided Files

The following files are ready to use:
- `ReelsExample/AppDelegate.swift` - App delegate with SDK initialization
- `ReelsExample/ViewController.swift` - Main view controller
- `ReelsExample/Info.plist` - App configuration
- `Podfile` - CocoaPods dependencies (ReelsIOS pod)

## Project Structure

```
example/ios/
├── Podfile                           # CocoaPods dependencies
├── ReelsExample/
│   ├── AppDelegate.swift            # App entry point with SDK init
│   ├── ViewController.swift         # Main UI
│   └── Info.plist                   # App configuration
└── ReelsExample.xcodeproj/          # Xcode project (to be created)
```

## SDK Integration

The `AppDelegate.swift` already includes the SDK initialization:

```swift
import UIKit
// import ReelsIOS  // Uncomment after pod install

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, 
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // ReelsIOSSDK.shared.initialize()  // Uncomment after integration
        return true
    }
}
```

## Testing

After setup:
1. Build succeeds
2. App launches showing "Flutter Reels Example"
3. Console shows "Reels SDK initialized"

## Requirements

- Xcode 14.0+
- iOS 12.0+ deployment target
- CocoaPods installed
- Swift 5.0+
