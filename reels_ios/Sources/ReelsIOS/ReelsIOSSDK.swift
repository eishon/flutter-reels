import Foundation

/// Reels iOS SDK
///
/// Main entry point for the Flutter Reels iOS library
@objc public class ReelsIOSSDK: NSObject {
    
    /// Shared singleton instance
    @objc public static let shared = ReelsIOSSDK()
    
    private override init() {
        super.init()
    }
    
    /// Initialize the SDK
    @objc public func initialize() {
        // TODO: Initialize Flutter engine and Pigeon communication
    }
}
