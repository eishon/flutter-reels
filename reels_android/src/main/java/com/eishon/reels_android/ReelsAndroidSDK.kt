package com.eishon.reels_android

import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger
// Pigeon generated classes are now in the same package (reels_android)

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
            // Host API: Provide access token to Flutter (Flutter calls, Kotlin implements)
            ReelsFlutterTokenApi.setUp(binaryMessenger, object : ReelsFlutterTokenApi {
                override fun getAccessToken(): String? {
                    val token = accessTokenProvider?.invoke() ?: listener?.getAccessToken()
                    Log.d(TAG, "Token requested: ${if (token != null) "provided" else "null"}")
                    return token
                }
            })
            
            // Note: Flutter APIs (Kotlin calls, Flutter implements) will be called when needed
            // They are instantiated with the binaryMessenger when we need to call Flutter
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
