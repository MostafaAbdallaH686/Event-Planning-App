package com.example.event_planning_app

import android.app.Application
import com.google.firebase.Firebase
import com.google.firebase.crashlytics.crashlytics
import io.flutter.embedding.engine.FlutterEngine

/**
 * Android-specific initialization for Crashlytics and other Firebase services
 */
class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        initializeCrashlytics()
    }

    private fun initializeCrashlytics() {
        try {
            // Crashlytics is automatically initialized by Firebase Core
            // Enable/disable collection based on build variant
            val crashlytics = Firebase.crashlytics
            
            // Set collection enabled (typically true for release, false for debug)
            // This can be overridden in Dart code
            val isDebug = 0 != applicationInfo.flags and android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE
            crashlytics.isCrashlyticsCollectionEnabled = !isDebug
            
            // Log app start
            val buildType = if (isDebug) "debug" else "release"
            crashlytics.log("Application started - Build: $buildType")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
