# CocoaPods Integration Guide

This comprehensive guide explains how to integrate the Flutter Reels module into your native iOS app using CocoaPods.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup](#detailed-setup)
- [Usage Examples](#usage-examples)
- [Advanced Configuration](#advanced-configuration)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## Prerequisites

Before you begin, ensure you have:

- Xcode 14.0 or higher
- iOS deployment target 12.0 or higher
- CocoaPods 1.10 or higher
- An existing iOS app (Swift or Objective-C)

### Installing CocoaPods

If you don't have CocoaPods installed:

```bash
sudo gem install cocoapods
```

Verify installation:

```bash
pod --version
```

## Quick Start

### 1. Initialize CocoaPods (if not already done)

If your project doesn't have a `Podfile`:

```bash
cd YourProject
pod init
```

### 2. Add Flutter Reels to Podfile

Edit your `Podfile`:

```ruby
source 'https://github.com/eishon/flutter-reels.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '12.0'

target 'YourApp' do
  use_frameworks!
  
  # Flutter Reels module
  pod 'FlutterReels', '~> 0.0.1'
end
```

### 3. Install Dependencies

```bash
pod install
```

### 4. Open Workspace

**Important:** From now on, always open the `.xcworkspace` file, not the `.xcodeproj`:

```bash
open YourApp.xcworkspace
```

## Detailed Setup

### Understanding the Podspec

The `FlutterReels.podspec` does the following:

1. **Downloads Frameworks**: Automatically downloads the pre-built Flutter frameworks from GitHub releases
2. **Configures Dependencies**: Sets up required Flutter dependencies
3. **Links Frameworks**: Properly links all frameworks to your project

### Version Management

#### Using Specific Versions

To use a specific version:

```ruby
pod 'FlutterReels', '0.0.1'
```

#### Using Version Ranges

To allow minor updates:

```ruby
pod 'FlutterReels', '~> 0.0.1'  # Allows 0.0.x updates
```

To allow patch updates only:

```ruby
pod 'FlutterReels', '~> 0.0.1'  # Allows 0.0.1.x updates
```

#### Using Latest Version

To always use the latest version (not recommended for production):

```ruby
pod 'FlutterReels'
```

### Complete Podfile Example

Here's a complete example with common configurations:

```ruby
source 'https://github.com/eishon/flutter-reels.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '12.0'
use_frameworks!

# Disable warnings from all pods
inhibit_all_warnings!

target 'YourApp' do
  # UI
  pod 'SnapKit', '~> 5.0'
  
  # Networking
  pod 'Alamofire', '~> 5.0'
  
  # Flutter Reels module
  pod 'FlutterReels', '~> 0.0.1'
end

target 'YourAppTests' do
  inherit! :search_paths
  # Test dependencies
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

## Usage Examples

### Swift Implementation

#### Basic Usage

```swift
import UIKit
import Flutter
import FlutterPluginRegistrant

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("Open Flutter Reels", for: .normal)
        button.addTarget(self, action: #selector(openFlutterReels), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        view.addSubview(button)
    }
    
    @objc func openFlutterReels() {
        let flutterViewController = FlutterViewController(
            engine: FlutterEngine(name: "flutter_reels_engine"),
            nibName: nil,
            bundle: nil
        )
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true)
    }
}
```

#### With Pre-warmed Engine (Recommended)

```swift
import UIKit
import Flutter
import FlutterPluginRegistrant

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Shared Flutter engine for better performance
    lazy var flutterEngine = FlutterEngine(name: "shared_engine")
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Pre-warm the Flutter engine
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        return true
    }
}

class ViewController: UIViewController {
    
    var flutterEngine: FlutterEngine {
        return (UIApplication.shared.delegate as! AppDelegate).flutterEngine
    }
    
    @objc func openFlutterReels() {
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true)
    }
}
```

#### With Method Channel Communication

```swift
import UIKit
import Flutter

class ViewController: UIViewController {
    
    lazy var flutterEngine = FlutterEngine(name: "method_channel_engine")
    private var methodChannel: FlutterMethodChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlutterEngine()
    }
    
    private func setupFlutterEngine() {
        flutterEngine.run()
        
        // Setup method channel
        let binaryMessenger = flutterEngine.binaryMessenger
        methodChannel = FlutterMethodChannel(
            name: "com.example.flutter_reels/native",
            binaryMessenger: binaryMessenger
        )
        
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call, result: result)
        }
    }
    
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getNativeData":
            let data = ["message": "Hello from iOS!"]
            result(data)
        case "closeFlutter":
            dismiss(animated: true)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @objc func openFlutterReels() {
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true)
    }
}
```

### Objective-C Implementation

#### AppDelegate.h

```objc
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) FlutterEngine *flutterEngine;

@end
```

#### AppDelegate.m

```objc
#import "AppDelegate.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize Flutter engine
    self.flutterEngine = [[FlutterEngine alloc] initWithName:@"shared_engine"];
    [self.flutterEngine run];
    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
    
    return YES;
}

@end
```

#### ViewController.m

```objc
#import "ViewController.h"
#import "AppDelegate.h"
#import <Flutter/Flutter.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Open Flutter Reels" forState:UIControlStateNormal];
    [button addTarget:self 
               action:@selector(openFlutterReels) 
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 200, 50);
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)openFlutterReels {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FlutterEngine *engine = appDelegate.flutterEngine;
    
    FlutterViewController *flutterViewController = 
        [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
    flutterViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:flutterViewController animated:YES completion:nil];
}

@end
```

## Advanced Configuration

### Using Multiple Flutter Modules

If you're using multiple Flutter modules:

```ruby
pod 'FlutterReels', '~> 0.0.1'
pod 'AnotherFlutterModule', '~> 1.0.0'
```

### Custom Build Configurations

For different build configurations:

```ruby
target 'YourApp' do
  use_frameworks!
  
  pod 'FlutterReels', '~> 0.0.1'
  
  target 'YourAppDebug' do
    inherit! :complete
    # Debug-specific pods
  end
  
  target 'YourAppRelease' do
    inherit! :complete
    # Release-specific pods
  end
end
```

### Excluding Architectures

If you need to exclude specific architectures:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
```

## Troubleshooting

### Common Issues

#### 1. "Unable to find a specification for FlutterReels"

**Solution:**
```bash
pod repo update
pod install --repo-update
```

#### 2. Build Fails with Framework Not Found

**Solution:**
Make sure you're opening the `.xcworkspace` file, not `.xcodeproj`:
```bash
open YourApp.xcworkspace
```

#### 3. Frameworks Not Downloading

**Solution:**
Clean and reinstall:
```bash
pod deintegrate
pod install
```

#### 4. Multiple Commands Produce Framework

**Solution:**
Add to your Podfile:
```ruby
install! 'cocoapods', :disable_input_output_paths => true
```

#### 5. DT_TOOLCHAIN_DIR Cannot Be Used

**Solution:**
Update CocoaPods:
```bash
sudo gem install cocoapods
```

### Debugging Tips

#### Verbose Installation

```bash
pod install --verbose
```

#### Clear CocoaPods Cache

```bash
pod cache clean --all
pod install
```

#### Check Installed Pods

```bash
pod list
```

## Best Practices

### 1. Version Pinning

For production apps, pin to specific versions:

```ruby
pod 'FlutterReels', '0.0.1'
```

### 2. Pre-warm Flutter Engine

Initialize the Flutter engine in `AppDelegate` for faster startup:

```swift
lazy var flutterEngine = FlutterEngine(name: "shared_engine")

func application(_ application: UIApplication,
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    flutterEngine.run()
    return true
}
```

### 3. Memory Management

Release Flutter resources when not needed:

```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isBeingDismissed {
        // Clean up Flutter resources
        flutterEngine.destroyContext()
    }
}
```

### 4. Background Execution

Handle app lifecycle for Flutter:

```swift
func applicationDidEnterBackground(_ application: UIApplication) {
    flutterEngine.lifecycleChannel.sendMessage("AppLifecycleState.inactive")
}

func applicationWillEnterForeground(_ application: UIApplication) {
    flutterEngine.lifecycleChannel.sendMessage("AppLifecycleState.resumed")
}
```

### 5. Network Requirements

Ensure your app has network permissions in `Info.plist` for framework downloads (first install only):

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 6. Regular Updates

Keep your dependencies updated:

```bash
pod update FlutterReels
```

## Additional Resources

- [Flutter iOS Integration](https://docs.flutter.dev/development/add-to-app/ios/project-setup)
- [CocoaPods Guide](https://guides.cocoapods.org/)
- [Flutter Reels Examples](./examples/ios-integration.md)
- [GitHub Repository](https://github.com/eishon/flutter-reels)

## Support

For issues and questions:
- Open an issue on [GitHub](https://github.com/eishon/flutter-reels/issues)
- Check existing [documentation](./README.md)
- Review [examples](./examples/)

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
