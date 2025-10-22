import Foundation
import Flutter

/// Main SDK class for integrating Flutter Reels into native iOS apps.
///
/// This SDK wraps the Flutter module and Pigeon communication, providing a clean
/// native iOS API. Users don't need to understand Flutter or Pigeon internals.
///
/// Usage:
/// ```swift
/// // Initialize once in your AppDelegate
/// ReelsIOSSDK.shared.initialize()
///
/// // Show reels
/// let videos = [VideoInfo(id: "1", url: "https://...")]
/// ReelsIOSSDK.shared.showReels(videos: videos)
///
/// // Listen to events
/// ReelsIOSSDK.shared.delegate = self
/// ```
@objc public class ReelsIOSSDK: NSObject {
    
    /// Shared singleton instance
    @objc public static let shared = ReelsIOSSDK()
    
    private var flutterEngine: FlutterEngine?
    private var isInitialized = false
    
    /// Delegate to receive reels events
    @objc public weak var delegate: ReelsDelegate?
    
    private override init() {
        super.init()
    }
    
    /// Initialize the Reels SDK.
    /// Must be called before using any other SDK methods.
    ///
    /// - Parameters:
    ///   - config: Optional configuration for reels behavior
    @objc public func initialize(config: ReelsConfig = ReelsConfig()) {
        guard !isInitialized else {
            print("ReelsIOSSDK: Already initialized")
            return
        }
        
        print("ReelsIOSSDK: Initializing...")
        
        // Create Flutter engine
        flutterEngine = FlutterEngine(name: "reels_flutter")
        
        // Run the Flutter engine
        flutterEngine?.run()
        
        // TODO: Setup Pigeon APIs when reels_flutter is integrated
        // let binaryMessenger = flutterEngine!.binaryMessenger
        // setupPigeonAPIs(binaryMessenger: binaryMessenger)
        
        isInitialized = true
        print("ReelsIOSSDK: Initialized successfully")
    }
    
    /// Show reels with the provided video list.
    ///
    /// - Parameters:
    ///   - videos: Array of videos to display
    /// - Throws: ReelsError if SDK not initialized
    @objc public func showReels(videos: [VideoInfo]) throws {
        try checkInitialized()
        print("ReelsIOSSDK: showReels called with \(videos.count) videos")
        // TODO: Call Pigeon API to show reels
    }
    
    /// Update a specific video's data (e.g., after user likes it)
    ///
    /// - Parameters:
    ///   - video: Updated video information
    @objc public func updateVideo(video: VideoInfo) throws {
        try checkInitialized()
        print("ReelsIOSSDK: updateVideo called for: \(video.id)")
        // TODO: Call Pigeon API to update video
    }
    
    /// Close the reels view
    @objc public func closeReels() throws {
        try checkInitialized()
        print("ReelsIOSSDK: closeReels called")
        // TODO: Call Pigeon API to close reels
    }
    
    /// Update SDK configuration
    ///
    /// - Parameters:
    ///   - config: New configuration
    @objc public func updateConfig(config: ReelsConfig) throws {
        try checkInitialized()
        print("ReelsIOSSDK: updateConfig called")
        // TODO: Call Pigeon API to update config
    }
    
    /// Get the Flutter engine instance (for advanced use cases)
    @objc public func getFlutterEngine() -> FlutterEngine? {
        return flutterEngine
    }
    
    /// Clean up resources
    @objc public func dispose() {
        flutterEngine?.destroyContext()
        flutterEngine = nil
        isInitialized = false
        print("ReelsIOSSDK: Disposed")
    }
    
    private func checkInitialized() throws {
        guard isInitialized else {
            throw ReelsError.notInitialized
        }
    }
}

// MARK: - Public Data Models (Native iOS, not Pigeon)

/// Configuration for Reels SDK behavior
@objc public class ReelsConfig: NSObject {
    @objc public let autoPlay: Bool
    @objc public let showControls: Bool
    @objc public let loopVideos: Bool
    
    @objc public init(autoPlay: Bool = true, showControls: Bool = true, loopVideos: Bool = true) {
        self.autoPlay = autoPlay
        self.showControls = showControls
        self.loopVideos = loopVideos
    }
}

/// Video information for reels
@objc public class VideoInfo: NSObject {
    @objc public let id: String
    @objc public let url: String
    @objc public let thumbnailUrl: String?
    @objc public let title: String?
    @objc public let description: String?
    @objc public let authorName: String?
    @objc public let authorAvatarUrl: String?
    @objc public let likeCount: Int
    @objc public let commentCount: Int
    @objc public let shareCount: Int
    @objc public let isLiked: Bool
    
    @objc public init(
        id: String,
        url: String,
        thumbnailUrl: String? = nil,
        title: String? = nil,
        description: String? = nil,
        authorName: String? = nil,
        authorAvatarUrl: String? = nil,
        likeCount: Int = 0,
        commentCount: Int = 0,
        shareCount: Int = 0,
        isLiked: Bool = false
    ) {
        self.id = id
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.title = title
        self.description = description
        self.authorName = authorName
        self.authorAvatarUrl = authorAvatarUrl
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.shareCount = shareCount
        self.isLiked = isLiked
    }
}

/// Product information for tagging
@objc public class ProductInfo: NSObject {
    @objc public let id: String
    @objc public let name: String
    @objc public let imageUrl: String?
    @objc public let price: Double
    @objc public let currency: String?
    
    @objc public init(
        id: String,
        name: String,
        imageUrl: String? = nil,
        price: Double = 0.0,
        currency: String? = nil
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.price = price
        self.currency = currency
    }
}

/// Delegate protocol for reels events
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
