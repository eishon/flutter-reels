import UIKit
// import ReelsIOS  // Uncomment after pod install

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ReelsDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Reels SDK
        // let config = ReelsConfig(autoPlay: true, showControls: true, loopVideos: true)
        // ReelsIOSSDK.shared.initialize(config: config)
        // ReelsIOSSDK.shared.delegate = self
        print("Reels SDK will be initialized after pod install")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - ReelsDelegate
    
    func onReelViewed(videoId: String) {
        print("Reel viewed: \(videoId)")
    }
    
    func onReelLiked(videoId: String, isLiked: Bool) {
        print("Reel liked: \(videoId), isLiked: \(isLiked)")
    }
    
    func onReelShared(videoId: String) {
        print("Reel shared: \(videoId)")
    }
    
    func onError(errorMessage: String) {
        print("Error: \(errorMessage)")
    }
}
