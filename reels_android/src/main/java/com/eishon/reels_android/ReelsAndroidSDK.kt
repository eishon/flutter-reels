package com.eishon.reels_android

import android.content.Context
import android.util.Log
// Pigeon generated classes (now in reels_android package for Add-to-App)
import com.eishon.reels_android.AnalyticsEvent
import com.eishon.reels_android.ReelsFlutterAnalyticsApi
import com.eishon.reels_android.ReelsFlutterButtonEventsApi
import com.eishon.reels_android.ReelsFlutterNavigationApi
import com.eishon.reels_android.ReelsFlutterStateApi
import com.eishon.reels_android.ReelsFlutterTokenApi
import com.eishon.reels_android.ScreenStateData
import com.eishon.reels_android.ShareData
import com.eishon.reels_android.VideoStateData
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger

/**
 * Main SDK class for integrating Flutter Reels into native Android apps.
 * 
 * This SDK wraps the Flutter module and Pigeon communication, providing a clean
 * native Android API integrated with Pigeon APIs.
 * 
 * Usage:
 * ```
 * // Initialize once in your Application or Activity
 * ReelsAndroidSDK.initialize(
 *     context = this,
 *     accessTokenProvider = { "user_token_123" }
 * )
 * 
 * // Set listener for events
 * ReelsAndroidSDK.setListener(object : ReelsListener {
 *     override fun onReelLiked(videoId: String, isLiked: Boolean) {
 *         Log.d("Reels", "Liked: $videoId = $isLiked")
 *     }
 *     override fun onReelShared(videoId: String) {
 *         Log.d("Reels", "Shared: $videoId")
 *     }
 * })
 * 
 * // Show reels using FlutterActivity
 * val intent = FlutterActivity
 *     .withCachedEngine("reels_engine")
 *     .build(this)
 * startActivity(intent)
 * ```
 */
class ReelsAndroidSDK private constructor() {
    companion object {
        private const val TAG = "ReelsAndroidSDK"
        
        private var flutterEngine: FlutterEngine? = null
        private var listener: ReelsListener? = null
        private var accessTokenProvider: (() -> String?)? = null
        private var isInitialized = false
        
        /**
         * Initialize the Reels SDK with Pigeon API integration.
         * Must be called before using any other SDK methods.
         * 
         * @param context Application or Activity context
         * @param accessTokenProvider Lambda to provide user access token
         */
        @JvmStatic
        fun initialize(
            context: Context,
            accessTokenProvider: (() -> String?)? = null
        ) {
            if (isInitialized) {
                Log.w(TAG, "SDK already initialized")
                return
            }
            
            try {
                Log.d(TAG, "Initializing Reels SDK with Pigeon integration...")
                
                this.accessTokenProvider = accessTokenProvider
                
                // Create Flutter engine
                flutterEngine = FlutterEngine(context.applicationContext, null, false)
                
                // Start executing Dart code
                flutterEngine?.dartExecutor?.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )
                
                // Setup Pigeon APIs
                val binaryMessenger = flutterEngine!!.dartExecutor.binaryMessenger
                setupPigeonAPIs(binaryMessenger)
                
                isInitialized = true
                Log.d(TAG, "Reels SDK initialized successfully with Pigeon APIs")
                
            } catch (e: Exception) {
                Log.e(TAG, "Failed to initialize SDK", e)
                throw ReelsException("SDK initialization failed: ${e.message}", e)
            }
        }
        
        /**
         * Setup all Pigeon API handlers
         */
        private fun setupPigeonAPIs(binaryMessenger: BinaryMessenger) {
            // Host API: Provide access token to Flutter
            ReelsFlutterTokenApi.setUp(binaryMessenger, object : ReelsFlutterTokenApi {
                override fun getAccessToken(): String? {
                    val token = accessTokenProvider?.invoke() ?: listener?.getAccessToken()
                    Log.d(TAG, "Token requested: ${if (token != null) "provided" else "null"}")
                    return token
                }
            })
            
            // Flutter API: Analytics events from Flutter
            ReelsFlutterAnalyticsApi.setUp(binaryMessenger, object : ReelsFlutterAnalyticsApi {
                override fun trackEvent(event: AnalyticsEvent) {
                    Log.d(TAG, "Analytics event: ${event.eventName} with ${event.eventProperties.size} properties")
                    // Native apps can forward to their analytics SDK here
                }
            })
            
            // Flutter API: Button interaction callbacks
            ReelsFlutterButtonEventsApi.setUp(binaryMessenger, object : ReelsFlutterButtonEventsApi {
                override fun onBeforeLikeButtonClick(videoId: String) {
                    Log.d(TAG, "Before like click: $videoId")
                    // Can be used for optimistic UI updates
                }
                
                override fun onAfterLikeButtonClick(videoId: String, isLiked: Boolean, likeCount: Long) {
                    Log.d(TAG, "After like click: $videoId, isLiked=$isLiked, count=$likeCount")
                    listener?.onReelLiked(videoId, isLiked)
                }
                
                override fun onShareButtonClick(shareData: ShareData) {
                    Log.d(TAG, "Share button clicked: ${shareData.videoId}")
                    listener?.onReelShared(shareData.videoId)
                }
            })
            
            // Flutter API: Screen and video state changes
            ReelsFlutterStateApi.setUp(binaryMessenger, object : ReelsFlutterStateApi {
                override fun onScreenStateChanged(state: ScreenStateData) {
                    Log.d(TAG, "Screen state: ${state.screenName} - ${state.state}")
                    when (state.state) {
                        "disappeared" -> listener?.onReelsClosed()
                        else -> {} // Handle other states if needed
                    }
                }
                
                override fun onVideoStateChanged(state: VideoStateData) {
                    Log.d(TAG, "Video state: ${state.videoId} - ${state.state}")
                    when (state.state) {
                        "completed" -> listener?.onReelViewed(state.videoId)
                        "error" -> listener?.onError("Video playback error: ${state.videoId}")
                        else -> {} // Handle playing, paused, buffering, etc.
                    }
                }
            })
            
            // Flutter API: Navigation gestures
            ReelsFlutterNavigationApi.setUp(binaryMessenger, object : ReelsFlutterNavigationApi {
                override fun onSwipeLeft() {
                    Log.d(TAG, "Swipe left gesture")
                }
                
                override fun onSwipeRight() {
                    Log.d(TAG, "Swipe right gesture")
                }
            })
        }
        
        /**
         * Set listener for reels events
         * 
         * @param listener Listener to receive events from Flutter via Pigeon
         */
        @JvmStatic
        fun setListener(listener: ReelsListener?) {
            this.listener = listener
        }
        
        /**
         * Get the Flutter engine instance.
         * Use this with FlutterActivity.withCachedEngine() to show reels.
         */
        @JvmStatic
        fun getFlutterEngine(): FlutterEngine? = flutterEngine
        
        /**
         * Get the Flutter engine ID for use with FlutterActivity
         */
        @JvmStatic
        fun getEngineId(): String = "reels_engine"
        
        /**
         * Clean up resources
         */
        @JvmStatic
        fun dispose() {
            try {
        /**
         * Clean up resources
         */
        @JvmStatic
        fun dispose() {
            try {
                flutterEngine?.destroy()
                flutterEngine = null
                listener = null
                accessTokenProvider = null
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

// Native data classes (for user convenience, not required by Pigeon)

/**
 * Listener interface for reels events (callbacks from Flutter via Pigeon)
 */
interface ReelsListener {
    /**
     * Called when a reel video completes playback
     */
    fun onReelViewed(videoId: String) {}
    
    /**
     * Called after user likes/unlikes a reel
     */
    fun onReelLiked(videoId: String, isLiked: Boolean) {}
    
    /**
     * Called when user shares a reel
     */
    fun onReelShared(videoId: String) {}
    
    /**
     * Called when reels screen is closed
     */
    fun onReelsClosed() {}
    
    /**
     * Called on any error
     */
    fun onError(errorMessage: String) {}
    
    /**
     * Provide access token for authenticated API calls
     * (Alternative to passing accessTokenProvider in initialize)
     */
    fun getAccessToken(): String? = null
}

/**
 * Exception thrown by Reels SDK
 */
class ReelsException(message: String, cause: Throwable? = null) : RuntimeException(message, cause)
