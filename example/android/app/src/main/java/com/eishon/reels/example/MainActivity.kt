package com.eishon.reels.example

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.eishon.reels_android.ReelsAndroidSDK

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Initialize Reels SDK
        ReelsAndroidSDK.initialize()
    }
}
