# iOS Integration Example

This directory contains example code for integrating the Flutter Reels module into a native iOS app.

## Quick Start Example

### ViewController.swift (UIKit)

```swift
import UIKit
import Flutter

class ViewController: UIViewController {
    
    // Lazy initialization of FlutterEngine for better performance
    lazy var flutterEngine = FlutterEngine(name: "flutter_reels_engine")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Pre-warm the Flutter engine for better performance
        flutterEngine.run()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Flutter Reels Integration Demo"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let simpleButton = UIButton(type: .system)
        simpleButton.setTitle("Launch Flutter (Simple)", for: .normal)
        simpleButton.addTarget(self, action: #selector(launchFlutterSimple), for: .touchUpInside)
        simpleButton.backgroundColor = .systemBlue
        simpleButton.setTitleColor(.white, for: .normal)
        simpleButton.layer.cornerRadius = 8
        simpleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let optimizedButton = UIButton(type: .system)
        optimizedButton.setTitle("Launch Flutter (Optimized)", for: .normal)
        optimizedButton.addTarget(self, action: #selector(launchFlutterOptimized), for: .touchUpInside)
        optimizedButton.backgroundColor = .systemGreen
        optimizedButton.setTitleColor(.white, for: .normal)
        optimizedButton.layer.cornerRadius = 8
        optimizedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(simpleButton)
        stackView.addArrangedSubview(optimizedButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    /**
     * Simple method to launch Flutter module
     * Creates a new FlutterViewController each time
     */
    @objc private func launchFlutterSimple() {
        let flutterViewController = FlutterViewController(
            engine: FlutterEngine(name: "my_engine_id"),
            nibName: nil,
            bundle: nil
        )
        
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true)
    }
    
    /**
     * Optimized method with pre-warmed FlutterEngine
     * Provides better performance and faster startup
     */
    @objc private func launchFlutterOptimized() {
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

### ContentView.swift (SwiftUI)

```swift
import SwiftUI
import Flutter

struct ContentView: View {
    @State private var showFlutter = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Flutter Reels Integration Demo")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                showFlutter = true
            }) {
                Text("Launch Flutter Module")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showFlutter) {
            FlutterView()
        }
    }
}

struct FlutterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FlutterViewController {
        let flutterEngine = FlutterEngine(name: "flutter_reels_engine")
        flutterEngine.run()
        
        return FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
    }
    
    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {
        // No update needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

### AppDelegate.swift

```swift
import UIKit
import Flutter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Pre-initialize FlutterEngine for better performance
    lazy var flutterEngine = FlutterEngine(name: "global_flutter_engine")
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Pre-warm the Flutter engine
        flutterEngine.run()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
```

### Podfile

```ruby
platform :ios, '12.0'

# Path to your Flutter module
flutter_application_path = '../flutter-reels/flutter_reels'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'YourApp' do
  use_frameworks!
  
  # Install all Flutter pods
  install_all_flutter_pods(flutter_application_path)
  
  # Your other pods
  # pod 'Alamofire', '~> 5.0'
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

### Info.plist

Add the following key to enable Flutter:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

## Advanced: Navigation Integration

### Passing Data to Flutter

```swift
import Flutter

class DataPassingViewController: UIViewController {
    
    func launchFlutterWithData() {
        let flutterEngine = FlutterEngine(name: "data_engine")
        flutterEngine.run()
        
        let channel = FlutterMethodChannel(
            name: "com.example.flutter_reels/data",
            binaryMessenger: flutterEngine.binaryMessenger
        )
        
        // Send data to Flutter
        channel.invokeMethod("setData", arguments: [
            "userId": "12345",
            "userName": "John Doe"
        ])
        
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        present(flutterViewController, animated: true)
    }
}
```

### Custom Presentation

```swift
extension ViewController {
    
    /// Present Flutter as a modal with custom presentation
    func presentFlutterModal() {
        let flutterVC = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        flutterVC.modalPresentationStyle = .pageSheet
        
        if let sheet = flutterVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(flutterVC, animated: true)
    }
    
    /// Push Flutter in navigation controller
    func pushFlutterInNavigation() {
        let flutterVC = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        navigationController?.pushViewController(flutterVC, animated: true)
    }
}
```

## Embedding Flutter in a View

```swift
import UIKit
import Flutter

class EmbeddedFlutterViewController: UIViewController {
    
    private var flutterEngine: FlutterEngine!
    private var flutterViewController: FlutterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flutterEngine = FlutterEngine(name: "embedded_engine")
        flutterEngine.run()
        
        flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        // Add as child view controller
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        
        // Setup constraints
        flutterViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flutterViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            flutterViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flutterViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flutterViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        flutterViewController.didMove(toParent: self)
    }
    
    deinit {
        flutterViewController.willMove(toParent: nil)
        flutterViewController.view.removeFromSuperview()
        flutterViewController.removeFromParent()
    }
}
```

## Troubleshooting

### Common Issues

1. **CocoaPods errors**: Run `pod deintegrate` followed by `pod install`
2. **Build errors**: Ensure your iOS deployment target is 12.0 or higher
3. **Black screen**: Make sure the Flutter engine is running before presenting the ViewController
4. **Memory issues**: Reuse FlutterEngine instances instead of creating new ones

### Performance Tips

1. Pre-warm the Flutter engine in `AppDelegate`
2. Reuse FlutterEngine instances across multiple presentations
3. Use a global FlutterEngine for frequently accessed Flutter screens

For more help, see the [main README](../flutter_reels/README.md).
