package com.seedahabit.app

import android.app.LocaleManager
import android.os.Build
import android.os.LocaleList
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val channel = MethodChannel(messenger, APP_LOCALE_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "sdk" -> result.success(Build.VERSION.SDK_INT)
                "set" -> result.success(setAppLocale(call.arguments as? String))
                else -> result.notImplemented()
            }
        }
    }

    private fun setAppLocale(tag: String?): Boolean {
        if (tag == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            return false
        }
        getSystemService(LocaleManager::class.java).applicationLocales =
            LocaleList.forLanguageTags(tag)
        return true
    }

    private companion object {
        const val APP_LOCALE_CHANNEL = "seed/app_locale"
    }
}
