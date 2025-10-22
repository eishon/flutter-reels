package com.eishon.reels.example

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.eishon.reels_android.*

class MainActivity : AppCompatActivity() {
    
    private val TAG = "MainActivity"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Initialize Reels SDK
        try {
            ReelsAndroidSDK.initialize(
                context = this,
                config = ReelsConfig(
                    autoPlay = true,
                    showControls = true,
                    loopVideos = true
                )
            )
            
            // Set event listener
            ReelsAndroidSDK.setListener(object : ReelsListener {
                override fun onReelViewed(videoId: String) {
                    Log.d(TAG, "Reel viewed: $videoId")
                }
                
                override fun onReelLiked(videoId: String, isLiked: Boolean) {
                    Log.d(TAG, "Reel liked: $videoId, isLiked: $isLiked")
                }
                
                override fun onReelShared(videoId: String) {
                    Log.d(TAG, "Reel shared: $videoId")
                }
                
                override fun onError(errorMessage: String) {
                    Log.e(TAG, "Error: $errorMessage")
                }
            })
            
            Log.d(TAG, "Reels SDK initialized successfully")
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize Reels SDK", e)
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        ReelsAndroidSDK.dispose()
    }
}
