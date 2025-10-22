import Flutter
import UIKit
import ReelsIOS

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Initialize Reels SDK with Pigeon integration
    ReelsIOSSDK.shared.initialize(accessTokenProvider: {
        // Provide user access token for authenticated requests
        return "demo_user_token_123"
    })
    
    // Set delegate for events from Flutter via Pigeon
    ReelsIOSSDK.shared.delegate = self
    
    print("Reels SDK initialized successfully with Pigeon APIs")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// MARK: - ReelsDelegate Implementation

extension AppDelegate: ReelsDelegate {
    func onReelViewed(videoId: String) {
        print("Reel viewed: \(videoId)")
    }
    
    func onReelLiked(videoId: String, isLiked: Bool) {
        print("Reel liked: \(videoId), isLiked: \(isLiked)")
        // Update your backend or local state
    }
    
    func onReelShared(videoId: String) {
        print("Reel shared: \(videoId)")
        // Track share event in your analytics
    }
    
    func onReelsClosed() {
        print("Reels screen closed")
    }
    
    func onError(errorMessage: String) {
        print("Error: \(errorMessage)")
    }
}
