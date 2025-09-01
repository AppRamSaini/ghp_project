package com.fp.ghpsocietyapp

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d("FCM", "Message received (Kotlin placeholder): ${remoteMessage.data}")
        // DO NOT call FlutterCallkitIncomingPlugin here
        // All incoming call handling will be in Dart
    }
}
