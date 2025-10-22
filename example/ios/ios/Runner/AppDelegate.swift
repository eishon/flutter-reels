import Flutter
import UIKit
// import ReelsIOS // Will be enabled after CocoaPods integration

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Initialize Reels SDK
    // ReelsIOSSDK.shared.initialize() // Will be enabled after integration
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
