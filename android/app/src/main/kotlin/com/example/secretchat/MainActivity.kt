package com.example.secretchat

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter

import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
	private val CHANNEL = "ourApp.manavAndrishabh.secretChat/networkCheck"


	override fun configureFlutterEngine(@NonNull FlutterEngine : FlutterEngine){
		super.configureFlutterEngine(FlutterEngine);
//		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//			// Note: this method is invoked on the main thread.
//			call, result ->
//			if (call.method == "isOnline") {
//				val isConnectedToInternet = isOnline()
//
////				if (isConnectedToInternet != -1) {
//					result.success(isConnectedToInternet)
////				}
////				else {
////					result.error("UNAVAILABLE", "Battery level not available.", null)
////				}
//			} else {
//				result.notImplemented()
//			}
//		}
	}

//	fun isOnline(): Boolean {
//		val connectivityManager =
//				context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
//		if (connectivityManager != null) {
//			val capabilities =
//					connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
//			if (capabilities != null) {
//				if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
//					Log.i("Internet", "NetworkCapabilities.TRANSPORT_CELLULAR")
//					return true
//				} else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
//					Log.i("Internet", "NetworkCapabilities.TRANSPORT_WIFI")
//					return true
//				} else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
//					Log.i("Internet", "NetworkCapabilities.TRANSPORT_ETHERNET")
//					return true
//				}
//			}
//		}
//		return false
//	}
	
}
