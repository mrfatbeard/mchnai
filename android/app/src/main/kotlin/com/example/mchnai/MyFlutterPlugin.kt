package com.example.mchnai

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class MyFlutterPlugin : FlutterPlugin, CoroutineScope {


    fun registerWith(binaryMessenger: BinaryMessenger) {
        //Log.d("lmmcx", "reg mcallback")
        MethodChannel(binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                result.success(
                    mapOf(
                        "message" to "called: " + call.method,
                        "status" to "123"
                    )
                )// Успешный вызов
                //Log.d("lmmcx", "call mcallback")
                /*if (call.method == "sayHelloStream") {
                    val count = call.argument<Int>("count") ?: 0
                    //sayHelloStream(count)
                    result.success("null") // Успешный вызов
                } else {
                    result.notImplemented()
                }*/
            }

        // создаем по каналу на каждый стримовый метод
        EventChannel(binaryMessenger, HELLO_CHANNEL).setStreamHandler(HelloStreamHandler())
//        EventChannel(binaryMessenger, SOME_OTHER_CHANNEL).setStreamHandler(SomeOtherStreamHandler())
    }

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.IO

    override fun onAttachedToEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        registerWith(p0.binaryMessenger);
    }

    override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        coroutineContext.cancelChildren()
    }

    /*private fun sayHelloStream(count: Int) {
        for (i in 1..count) {
            // Отправляем сообщения через EventChannel
            sendMessage("Hello $i")
        }
    }*/

    companion object {
        private const val CHANNEL = "com.example.grpc"
        private const val HELLO_CHANNEL = "com.example.grpc/event"
    }
}

// создаем свой хендлер для каждого стримового метода
class HelloStreamHandler() : EventChannel.StreamHandler, CoroutineScope {
    override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
        launch {
            p1?.run {
                sendMessage("1")
                sendMessage("2")
                sendMessage("3")
                sendDone()
            }
        }
    }

    override fun onCancel(p0: Any?) {
        coroutineContext.cancelChildren()
    }

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.IO

    suspend fun EventChannel.EventSink.sendMessage(message: String) = withContext(Dispatchers.Main) {
        success(message)
    }

    suspend fun EventChannel.EventSink.sendDone() = withContext(Dispatchers.Main) { endOfStream() }
}