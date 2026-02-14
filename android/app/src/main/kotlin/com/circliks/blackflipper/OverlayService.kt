package com.circliks.blackflipper

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.util.DisplayMetrics
import android.util.Log
import android.view.*
import android.widget.Button
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.app.NotificationCompat
import java.text.NumberFormat
import java.util.Locale

class OverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private var overlayView: View? = null
    private var menuView: View? = null
    private lateinit var overlayParams: WindowManager.LayoutParams
    private lateinit var menuParams: WindowManager.LayoutParams

    private val itemList = ArrayList<Map<String, Any>>()

    companion object {
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "OverlayServiceChannel"
        const val TAG = "OverlayService"
        var isRunning = false
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "onCreate")
        isRunning = true

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(CHANNEL_ID, "Overlay Service Notifications", NotificationManager.IMPORTANCE_LOW)
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Overlay is Active")
            .setSmallIcon(R.drawable.icl)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .build()
        
        startForeground(NOTIFICATION_ID, notification)

        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

        val layoutFlag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            WindowManager.LayoutParams.TYPE_PHONE
        }

        overlayParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            layoutFlag,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        overlayParams.gravity = Gravity.TOP or Gravity.START
        overlayParams.x = 0
        overlayParams.y = 100

        val metrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(metrics)
        val width = (metrics.widthPixels * 0.9).toInt()
        val height = (metrics.heightPixels * 0.5).toInt()

        menuParams = WindowManager.LayoutParams(
            width,
            height,
            layoutFlag,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        menuParams.gravity = Gravity.CENTER

        showDraggableButton()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "onStartCommand received")
        if (!isRunning) {
            // Service was recreated, re-initialize
            onCreate()
        }
        intent?.getSerializableExtra("itemData")?.let {
            val itemData = it as HashMap<String, Any>
            Log.d(TAG, "itemData received: $itemData")
            itemList.add(itemData)
        }
        return START_STICKY
    }

    private fun showDraggableButton() {
        if (overlayView != null) return
        overlayView = LayoutInflater.from(this).inflate(R.layout.overlay_layout, null)
        windowManager.addView(overlayView, overlayParams)

        val draggableButton = overlayView?.findViewById<ImageButton>(R.id.draggable_button)

        draggableButton?.setOnTouchListener(object : View.OnTouchListener {
            private var initialX: Int = 0
            private var initialY: Int = 0
            private var initialTouchX: Float = 0f
            private var initialTouchY: Float = 0f
            private var isClick: Boolean = false

            override fun onTouch(v: View, event: MotionEvent): Boolean {
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        initialX = overlayParams.x
                        initialY = overlayParams.y
                        initialTouchX = event.rawX
                        initialTouchY = event.rawY
                        isClick = true
                        return true
                    }
                    MotionEvent.ACTION_MOVE -> {
                        val dx = event.rawX - initialTouchX
                        val dy = event.rawY - initialTouchY
                        if (Math.sqrt((dx * dx + dy * dy).toDouble()) > 20) {
                            isClick = false
                        }
                        // Always update the position during move
                        overlayParams.x = initialX + dx.toInt()
                        overlayParams.y = initialY + dy.toInt()
                        windowManager.updateViewLayout(overlayView, overlayParams)
                        return true
                    }
                    MotionEvent.ACTION_UP -> {
                        if (isClick) {
                            showMenu()
                        }
                        return true
                    }
                }
                return false
            }
        })
    }

    private fun showMenu() {
        if (menuView != null) return

        // Hide draggable button
        if (overlayView != null) {
            windowManager.removeView(overlayView)
            overlayView = null
        }

        // Inflate menu layout
        menuView = LayoutInflater.from(this).inflate(R.layout.mod_menu_layout, null)
        val cardContainer = menuView?.findViewById<LinearLayout>(R.id.card_container) // Assuming you have a LinearLayout with this ID
        
        cardContainer?.removeAllViews() // Clear old views

        if (itemList.isEmpty()) {
            // Optionally, show a message that the list is empty
            val emptyTextView = TextView(this)
            emptyTextView.text = "No items to display."
            emptyTextView.setTextColor(resources.getColor(android.R.color.white))
            cardContainer?.addView(emptyTextView)
        } else {
            // Add a card for each item in the list
            for ((index, itemData) in itemList.withIndex()) {
                val card = LayoutInflater.from(this).inflate(R.layout.card_item_layout, cardContainer, false)
                
                val title = card.findViewById<TextView>(R.id.item_title_text)
                val buyCity = card.findViewById<TextView>(R.id.buy_city_text)
                val buyPrice = card.findViewById<TextView>(R.id.buy_price_text)
                val sellCity = card.findViewById<TextView>(R.id.sell_city_text)
                val sellPrice = card.findViewById<TextView>(R.id.sell_price_text)
                val profit = card.findViewById<TextView>(R.id.profit_text)
                val tier = card.findViewById<TextView>(R.id.tier_text)
                val enchant = card.findViewById<TextView>(R.id.enchant_text)
                val quality = card.findViewById<TextView>(R.id.quality_text)
                val removeButton = card.findViewById<Button>(R.id.remove_button)

                title?.text = itemData["title"] as? String ?: "N/A"
                buyCity?.text = itemData["buyCity"] as? String ?: "N/A"
                buyPrice?.text = "${itemData["buyPrice"]} Silver"
                sellCity?.text = itemData["sellCity"] as? String ?: "N/A"
                sellPrice?.text = "${itemData["sellPrice"]} Silver"
                profit?.text = "Profit: ${itemData["profit"]} (${String.format("%.2f", itemData["profitMargin"] as? Double)}%)"
                tier?.text = "Tier: ${itemData["tier"]}"
                enchant?.text = "Enchant: ${itemData["enchantment"]}"
                quality?.text = "Quality: ${getQualityString(itemData["quality"] as? Int ?: 0)}"

                removeButton.setOnClickListener {
                    itemList.removeAt(index)
                    if (menuView != null) {
                        windowManager.removeView(menuView)
                        menuView = null
                    }
                    showMenu()
                }

                cardContainer?.addView(card)
            }
        }

        // Close button logic
        val closeButton = menuView?.findViewById<Button>(R.id.btn_close_menu)
        closeButton?.setOnClickListener {
            if (menuView != null) {
                windowManager.removeView(menuView)
                menuView = null
                showDraggableButton()
            }
        }

        windowManager.addView(menuView, menuParams)
    }

    private fun getQualityString(quality: Int): String {
        return when (quality) {
            1 -> "Normal"
            2 -> "Good"
            3 -> "Outstanding"
            4 -> "Excellent"
            5 -> "Masterpiece"
            else -> "Unknown"
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (overlayView != null) windowManager.removeView(overlayView)
        if (menuView != null) windowManager.removeView(menuView)
        isRunning = false
    }
}