package com.example.mchnai

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    private val EVENT_CHANNEL = "com.example.yourapp/greeterStream"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Настройка EventChannel для потоковой передачи данных
        EventChannel(flutterEngine?.dartExecutor?.binaryMessenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                val numMessages = arguments as? Int ?: return
                GlobalScope.launch {
                    for (i in 0 until numMessages) {
                        delay(1000) // Имитация задержки
                        events?.success("Message #$i from Kotlin")
                    }
                }
            }

            override fun onCancel(arguments: Any?) {
                // Обработка отмены
            }
        })
    }
}
