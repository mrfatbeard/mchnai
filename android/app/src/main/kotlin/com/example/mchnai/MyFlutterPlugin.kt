package com.example.mchnai

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MyFlutterPlugin {
    private val CHANNEL = "com.example.grpc"
    private val EVENT_CHANNEL = "com.example.grpc/event"

    fun registerWith(flutterEngine: FlutterEngine) {
        //Log.d("lmmcx", "reg mcallback")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                result.success(mapOf(
                    "message" to "called: " + call.method,
                    "status" to "123"
                ))// Успешный вызов
                //Log.d("lmmcx", "call mcallback")
            /*if (call.method == "sayHelloStream") {
                val count = call.argument<Int>("count") ?: 0
                //sayHelloStream(count)
                result.success("null") // Успешный вызов
            } else {
                result.notImplemented()
            }*/
        }

        /*EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            private var eventSink: EventChannel.EventSink? = null

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }

            fun sendMessage(message: String) {
                eventSink?.success(message)
            }
        })*/
    }

    /*private fun sayHelloStream(count: Int) {
        for (i in 1..count) {
            // Отправляем сообщения через EventChannel
            sendMessage("Hello $i")
        }
    }*/
}
