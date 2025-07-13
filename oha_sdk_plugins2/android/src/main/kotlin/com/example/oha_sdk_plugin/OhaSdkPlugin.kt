package com.example.oha_sdk_plugin

import android.app.Activity
import android.content.Context
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OhaSdkPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var flutterEngine: FlutterEngine? = null
  private var activity: Activity? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "oha_sdk_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    if (call.method == "startFlutterSdk") {
      println("startFlutterSdk tetiklendi!")
      if (flutterEngine == null) {
        flutterEngine = FlutterEngine(context)

        flutterEngine!!.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault(),
                 
        )

        FlutterEngineCache.getInstance().put("oha_engine", flutterEngine)

        activity?.let {
          val intent = FlutterActivity.withCachedEngine("oha_engine").build(it)
          it.startActivity(intent)

          Log.d("OhaSdkPlugin", "FlutterEngine başlatıldı ve ekran gösterildi")
          result.success("SDK UI gösterildi")
        }
                ?: run {
                  Log.e("OhaSdkPlugin", "Activity null")
                  result.error("NO_ACTIVITY", "Activity null, cannot start SDK", null)
                }
      } else {
        result.success("Zaten başlatılmıştı")
      }
    } else {
      result.notImplemented()
    }
  }
/*
  // JSON modelin
  @Serializable
  data class OHARequestData(
          val ohaBaseUrl: String,
          val primaryColor: String,
          val secondaryColor: String,
          val appLogoPath: String,
          val isForTesting: Boolean,
          val isCloseOnExit: Boolean
  )

  private fun createRequestDataJson(): String {
    val baseUrl = "https://example.com"
    val primaryColor = "#000000"
    val secondaryColor = "#FFFFFF"
    val logoBase64 = "..." // logo base64
    val isForTesting = true
    val isCloseOnExit = true

    val data =
            OHARequestData(
                    baseUrl,
                    primaryColor,
                    secondaryColor,
                    logoBase64,
                    isForTesting,
                    isCloseOnExit
            )
    return Json.encodeToString(data)
  }
*/
  // 🔁 ActivityAware uygulamaları
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

/*
class OhaSdkPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var flutterEngine: FlutterEngine? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "oha_sdk_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    if (call.method == "startFlutterSdk") {
      if (flutterEngine == null) {
        flutterEngine = FlutterEngine(context)

        val jsonParam = createRequestDataJson()

        flutterEngine!!.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault(),
                listOf(jsonParam)
        )

        FlutterEngineCache.getInstance().put("oha_engine", flutterEngine)

        result.success("FlutterEngine başlatıldı ve JSON gönderildi")
      } else {
        result.success("Zaten başlatılmış")
      }
    } else {
      result.notImplemented()
    }
  }

  @Serializable
  data class OHARequestData(
          val ohaBaseUrl: String,
          val primaryColor: String,
          val secondaryColor: String,
          val appLogoPath: String,
          val isForTesting: Boolean,
          val isCloseOnExit: Boolean
  )

  private fun createRequestDataJson(): String {

    val baseUrl = "https://example.com"
    val primaryColor = "#000000"
    val secondaryColor = "#FFFFFF"
    val logoBase64 = "..." // base64 logon
    val isForTesting = true
    val isCloseOnExit = true

    val data =
            OHARequestData(
                    baseUrl,
                    primaryColor,
                    secondaryColor,
                    logoBase64,
                    isForTesting,
                    isCloseOnExit
            )
    return Json.encodeToString(data)
  }

 override fun onAttachedToActivity(binding: ActivityPluginBinding) {}
  override fun onDetachedFromActivity() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
*/
