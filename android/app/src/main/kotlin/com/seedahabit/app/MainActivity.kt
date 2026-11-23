package com.seedahabit.app

import android.app.LocaleManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.LocaleList
import android.provider.Settings
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
        val settings = MethodChannel(messenger, APP_SETTINGS_CHANNEL)
        settings.setMethodCallHandler { call, result ->
            when (call.method) {
                "notifications" -> {
                    startActivity(notificationSettingsIntent())
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun notificationSettingsIntent(): Intent =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
        } else {
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                .setData(Uri.fromParts("package", packageName, null))
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
        const val APP_SETTINGS_CHANNEL = "seed/app_settings"
    }
}
