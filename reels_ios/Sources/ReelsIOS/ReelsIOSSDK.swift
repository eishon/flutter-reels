import Foundation
import Flutter

/// Main SDK class for integrating Flutter Reels into native iOS apps.
///
/// This SDK wraps the Flutter module and Pigeon communication, providing a clean
/// native iOS API integrated with Pigeon APIs.
///
/// Usage:
/// ```swift
/// // Initialize once in your AppDelegate
/// ReelsIOSSDK.shared.initialize(accessTokenProvider: {
///     return "user_token_123"
/// })
///
/// // Set delegate for events
/// ReelsIOSSDK.shared.delegate = self
///
/// // Show reels using FlutterViewController
/// let flutterVC = FlutterViewController(engine: ReelsIOSSDK.shared.getFlutterEngine()!, nibName: nil, bundle: nil)
/// present(flutterVC, animated: true)
/// ```
@objc public class ReelsIOSSDK: NSObject {
    
    /// Shared singleton instance
    @objc public static let shared = ReelsIOSSDK()
    
    private var flutterEngine: FlutterEngine?
    private var isInitialized = false
    private var accessTokenProvider: (() -> String?)?
    
    /// Delegate to receive reels events from Flutter via Pigeon
    @objc public weak var delegate: ReelsDelegate?
    
    private override init() {
        super.init()
    }
    
    /// Initialize the Reels SDK with Pigeon API integration.
    /// Must be called before using any other SDK methods.
    ///
    /// - Parameters:
    ///   - accessTokenProvider: Closure to provide user access token
    @objc public func initialize(accessTokenProvider: (() -> String?)? = nil) {
        guard !isInitialized else {
            print("ReelsIOSSDK: Already initialized")
            return
        }
        
        print("ReelsIOSSDK: Initializing with Pigeon APIs...")
        
        self.accessTokenProvider = accessTokenProvider
        
        // Create Flutter engine
        flutterEngine = FlutterEngine(name: "reels_engine")
        
        // Run the Flutter engine
        flutterEngine?.run()
        
        // Setup Pigeon APIs
        if let engine = flutterEngine {
            setupPigeonAPIs(binaryMessenger: engine.binaryMessenger)
        }
        
        isInitialized = true
        print("ReelsIOSSDK: Initialized successfully with Pigeon APIs")
    }
    
    /// Setup all Pigeon API handlers
    private func setupPigeonAPIs(binaryMessenger: FlutterBinaryMessenger) {
        // Host API: Provide access token to Flutter
        ReelsFlutterTokenApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        
        // Flutter API: Analytics events from Flutter
        ReelsFlutterAnalyticsApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        
        // Flutter API: Button interaction callbacks
        ReelsFlutterButtonEventsApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        
        // Flutter API: Screen and video state changes
        ReelsFlutterStateApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        
        // Flutter API: Navigation gestures
        ReelsFlutterNavigationApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
    }
    
    /// Get the Flutter engine instance.
    /// Use this to create FlutterViewController for showing reels.
    @objc public func getFlutterEngine() -> FlutterEngine? {
        return flutterEngine
    }
    
    /// Clean up resources
    @objc public func dispose() {
        flutterEngine = nil
        isInitialized = false
        accessTokenProvider = nil
        print("ReelsIOSSDK: Disposed")
    }
    
    private func checkInitialized() throws {
        guard isInitialized else {
            throw ReelsError.notInitialized
        }
    }
}

// MARK: - Pigeon Host API Implementation

extension ReelsIOSSDK: ReelsFlutterTokenApi {
    public func getAccessToken() throws -> String? {
        let token = accessTokenProvider?() ?? delegate?.getAccessToken?()
        print("ReelsIOSSDK: Token requested: \(token != nil ? "provided" : "null")")
        return token
    }
}

// MARK: - Pigeon Flutter API Implementations

extension ReelsIOSSDK: ReelsFlutterAnalyticsApi {
    public func trackEvent(event: AnalyticsEvent) throws {
        print("ReelsIOSSDK: Analytics event: \(event.eventName) with \(event.eventProperties.count) properties")
        // Native apps can forward to their analytics SDK here
    }
}

extension ReelsIOSSDK: ReelsFlutterButtonEventsApi {
    public func onBeforeLikeButtonClick(videoId: String) throws {
        print("ReelsIOSSDK: Before like click: \(videoId)")
        // Can be used for optimistic UI updates
    }
    
    public func onAfterLikeButtonClick(videoId: String, isLiked: Bool, likeCount: Int64) throws {
        print("ReelsIOSSDK: After like click: \(videoId), isLiked=\(isLiked), count=\(likeCount)")
        delegate?.onReelLiked?(videoId: videoId, isLiked: isLiked)
    }
    
    public func onShareButtonClick(shareData: ShareData) throws {
        print("ReelsIOSSDK: Share button clicked: \(shareData.videoId)")
        delegate?.onReelShared?(videoId: shareData.videoId)
    }
}

extension ReelsIOSSDK: ReelsFlutterStateApi {
    public func onScreenStateChanged(state: ScreenStateData) throws {
        print("ReelsIOSSDK: Screen state: \(state.screenName) - \(state.state)")
        if state.state == "disappeared" {
            delegate?.onReelsClosed?()
        }
    }
    
    public func onVideoStateChanged(state: VideoStateData) throws {
        print("ReelsIOSSDK: Video state: \(state.videoId) - \(state.state)")
        switch state.state {
        case "completed":
            delegate?.onReelViewed?(videoId: state.videoId)
        case "error":
            delegate?.onError?(errorMessage: "Video playback error: \(state.videoId)")
        default:
            break // Handle playing, paused, buffering, etc.
        }
    }
}

extension ReelsIOSSDK: ReelsFlutterNavigationApi {
    public func onSwipeLeft() throws {
        print("ReelsIOSSDK: Swipe left gesture")
    }
    
    public func onSwipeRight() throws {
        print("ReelsIOSSDK: Swipe right gesture")
    }
}

// MARK: - Public Data Models
@objc public protocol ReelsDelegate: AnyObject {
    @objc optional func onReelViewed(videoId: String)
    @objc optional func onReelLiked(videoId: String, isLiked: Bool)
    @objc optional func onReelShared(videoId: String)
    @objc optional func onReelCommented(videoId: String)
    @objc optional func onProductClicked(productId: String, videoId: String)
    @objc optional func onReelsClosed()
    @objc optional func onError(errorMessage: String)
    @objc optional func getAccessToken() -> String?
}

/// Errors thrown by Reels SDK
@objc public enum ReelsError: Int, Error {
    case notInitialized
    case invalidConfiguration
    case flutterEngineError
    
    public var localizedDescription: String {
        switch self {
        case .notInitialized:
            return "SDK not initialized. Call initialize() first."
        case .invalidConfiguration:
            return "Invalid configuration provided."
        case .flutterEngineError:
            return "Flutter engine error occurred."
        }
    }
}
