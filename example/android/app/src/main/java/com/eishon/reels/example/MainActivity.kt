package com.eishon.reels.example

import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import com.eishon.reels_android.*
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    
    private val TAG = "MainActivity"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Initialize Reels SDK with Pigeon integration
        try {
            ReelsAndroidSDK.initialize(
                context = this,
                accessTokenProvider = {
                    // Provide user access token for authenticated requests
                    "demo_user_token_123"
                }
            )
            
            // Set listener for events from Flutter via Pigeon
            ReelsAndroidSDK.setListener(object : ReelsListener {
                override fun onReelViewed(videoId: String) {
                    Log.d(TAG, "Reel viewed: $videoId")
                }
                
                override fun onReelLiked(videoId: String, isLiked: Boolean) {
                    Log.d(TAG, "Reel liked: $videoId, isLiked: $isLiked")
                    // Update your backend or local state
                }
                
                override fun onReelShared(videoId: String) {
                    Log.d(TAG, "Reel shared: $videoId")
                    // Track share event in your analytics
                }
                
                override fun onReelsClosed() {
                    Log.d(TAG, "Reels screen closed")
                }
                
                override fun onError(errorMessage: String) {
                    Log.e(TAG, "Error: $errorMessage")
                }
            })
            
            Log.d(TAG, "Reels SDK initialized successfully with Pigeon APIs")
            
            // Setup button to launch Flutter reels
            setupLaunchButton()
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize Reels SDK", e)
        }
    }
    
    private fun setupLaunchButton() {
        // Find or create a button to launch reels
        val launchButton = findViewById<Button>(R.id.launch_reels_button)
        launchButton?.setOnClickListener {
            launchReels()
        }
    }
    
    private fun launchReels() {
        try {
            // Launch Flutter reels using cached engine
            val flutterEngine = ReelsAndroidSDK.getFlutterEngine()
            if (flutterEngine != null) {
                startActivity(
                    FlutterActivity
                        .withCachedEngine(ReelsAndroidSDK.getEngineId())
                        .build(this)
                )
            } else {
                Log.e(TAG, "Flutter engine not initialized")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to launch reels", e)
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        ReelsAndroidSDK.dispose()
    }
}
