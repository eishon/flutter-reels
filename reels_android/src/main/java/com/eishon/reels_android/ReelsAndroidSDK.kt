package com.eishon.reels_android

import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

/**
 * Main SDK class for integrating Flutter Reels into native Android apps.
 * 
 * This SDK wraps the Flutter module and Pigeon communication, providing a clean
 * native Android API. Users don't need to understand Flutter or Pigeon internals.
 * 
 * Usage:
 * ```
 * // Initialize once in your Application or Activity
 * ReelsAndroidSDK.initialize(context)
 * 
 * // Show reels
 * val videos = listOf(VideoInfo(id = "1", url = "https://..."))
 * ReelsAndroidSDK.showReels(videos)
 * 
 * // Listen to events
 * ReelsAndroidSDK.setListener(object : ReelsListener {
 *     override fun onReelViewed(videoId: String) {
 *         Log.d("Reels", "Viewed: $videoId")
 *     }
 * })
 * ```
 */
class ReelsAndroidSDK private constructor() {
    companion object {
        private const val TAG = "ReelsAndroidSDK"
        
        private var flutterEngine: FlutterEngine? = null
        private var listener: ReelsListener? = null
        private var isInitialized = false
        
        /**
         * Initialize the Reels SDK.
         * Must be called before using any other SDK methods.
         * 
         * @param context Application or Activity context
         * @param config Optional configuration for reels behavior
         */
        @JvmStatic
        @JvmOverloads
        fun initialize(
            context: Context,
            config: ReelsConfig = ReelsConfig()
        ) {
            if (isInitialized) {
                Log.w(TAG, "SDK already initialized")
                return
            }
            
            try {
                Log.d(TAG, "Initializing Reels SDK...")
                
                // Create Flutter engine
                flutterEngine = FlutterEngine(context.applicationContext)
                
                // Start executing Dart code
                flutterEngine?.dartExecutor?.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )
                
                // TODO: Setup Pigeon APIs when reels_flutter is integrated
                // val binaryMessenger = flutterEngine!!.dartExecutor.binaryMessenger
                // reelsFlutterApi = ReelsFlutterApi(binaryMessenger)
                // ReelsNativeApi.setUp(binaryMessenger, NativeApiHandler())
                
                isInitialized = true
                Log.d(TAG, "Reels SDK initialized successfully")
                
            } catch (e: Exception) {
                Log.e(TAG, "Failed to initialize SDK", e)
                throw ReelsException("SDK initialization failed", e)
            }
        }
        
        /**
         * Show reels with the provided video list.
         * 
         * @param videos List of videos to display
         * @throws ReelsException if SDK not initialized
         */
        @JvmStatic
        fun showReels(videos: List<VideoInfo>) {
            checkInitialized()
            Log.d(TAG, "showReels called with ${videos.size} videos")
            // TODO: Call Pigeon API to show reels
        }
        
        /**
         * Update a specific video's data (e.g., after user likes it)
         * 
         * @param video Updated video information
         */
        @JvmStatic
        fun updateVideo(video: VideoInfo) {
            checkInitialized()
            Log.d(TAG, "updateVideo called for: ${video.id}")
            // TODO: Call Pigeon API to update video
        }
        
        /**
         * Close the reels view
         */
        @JvmStatic
        fun closeReels() {
            checkInitialized()
            Log.d(TAG, "closeReels called")
            // TODO: Call Pigeon API to close reels
        }
        
        /**
         * Update SDK configuration
         * 
         * @param config New configuration
         */
        @JvmStatic
        fun updateConfig(config: ReelsConfig) {
            checkInitialized()
            Log.d(TAG, "updateConfig called")
            // TODO: Call Pigeon API to update config
        }
        
        /**
         * Set listener for reels events
         * 
         * @param listener Listener to receive events
         */
        @JvmStatic
        fun setListener(listener: ReelsListener?) {
            this.listener = listener
        }
        
        /**
         * Get the Flutter engine instance (for advanced use cases)
         */
        @JvmStatic
        fun getFlutterEngine(): FlutterEngine? = flutterEngine
        
        /**
         * Clean up resources
         */
        @JvmStatic
        fun dispose() {
            try {
                flutterEngine?.destroy()
                flutterEngine = null
                listener = null
                isInitialized = false
                Log.d(TAG, "SDK disposed")
            } catch (e: Exception) {
                Log.e(TAG, "Error disposing SDK", e)
            }
        }
        
        private fun checkInitialized() {
            if (!isInitialized) {
                throw ReelsException("SDK not initialized. Call initialize() first.")
            }
        }
    }
}

// Native data classes (not Pigeon generated - user-friendly)

/**
 * Configuration for Reels SDK behavior
 */
data class ReelsConfig(
    val autoPlay: Boolean = true,
    val showControls: Boolean = true,
    val loopVideos: Boolean = true
)

/**
 * Video information for reels
 */
data class VideoInfo(
    val id: String,
    val url: String,
    val thumbnailUrl: String? = null,
    val title: String? = null,
    val description: String? = null,
    val authorName: String? = null,
    val authorAvatarUrl: String? = null,
    val likeCount: Int = 0,
    val commentCount: Int = 0,
    val shareCount: Int = 0,
    val isLiked: Boolean = false
)

/**
 * Product information for tagging
 */
data class ProductInfo(
    val id: String,
    val name: String,
    val imageUrl: String? = null,
    val price: Double? = null,
    val currency: String? = null
)

/**
 * Listener interface for reels events
 */
interface ReelsListener {
    fun onReelViewed(videoId: String) {}
    fun onReelLiked(videoId: String, isLiked: Boolean) {}
    fun onReelShared(videoId: String) {}
    fun onReelCommented(videoId: String) {}
    fun onProductClicked(productId: String, videoId: String) {}
    fun onReelsClosed() {}
    fun onError(errorMessage: String) {}
    fun getAccessToken(): String? = null
}

/**
 * Exception thrown by Reels SDK
 */
class ReelsException(message: String, cause: Throwable? = null) : RuntimeException(message, cause)
