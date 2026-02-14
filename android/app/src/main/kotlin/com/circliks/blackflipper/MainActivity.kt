package com.circliks.blackflipper

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.Serializable

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.circliks.blackflipper/overlay"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            val serviceIntent = Intent(this, OverlayService::class.java)
            when (call.method) {
                "startOverlay" -> {
                    if (!OverlayService.isRunning) {
                        val args = call.arguments as? Map<String, Any>
                        Log.d("MainActivity", "Arguments received: $args")
                        if (args != null) {
                            serviceIntent.putExtra("itemData", HashMap(args)) // Use HashMap
                        }

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(serviceIntent)
                        } else {
                            startService(serviceIntent)
                        }
                    } else {
                        val args = call.arguments as? Map<String, Any>
                        Log.d("MainActivity", "Arguments received: $args")
                        if (args != null) {
                            serviceIntent.putExtra("itemData", HashMap(args)) // Use HashMap
                            // Service is already running, just send new data
                            startService(serviceIntent) 
                        }
                    }
                    result.success(null)
                }
                "stopOverlay" -> {
                    stopService(serviceIntent)
                    result.success(null)
                }
                "isOverlayRunning" -> {
                    result.success(OverlayService.isRunning)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
