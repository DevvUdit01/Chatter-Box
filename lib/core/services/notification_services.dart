
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

/// Handles background notifications
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message received: ${message.notification?.title}');
}

class NotificationServices {
  
  /// Initializes Firebase Messaging and handles permission requests
  static Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted permission for notifications");

      // Set up background message handling
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages (when the app is open)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Foreground message received: ${message.notification?.title}');
      });

      // Handle messages when the app is opened by tapping on a notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('Notification clicked, opening app: ${message.notification?.title}');
      });

      log("Notification services initialized successfully");
    } else {
      log("User denied notification permissions");
    }
  }
}

/// Saves the user's FCM token in Firestore
Future<void> saveUserToken(String userId) async {
  String? fcmToken = await FirebaseMessaging.instance.getToken();

  // Save the FCM token to Firestore under the user's document
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'fcmToken': fcmToken,
  }, SetOptions(merge: true));  // Merge to avoid overwriting existing data
}

/// Sends a chat message and a notification to the receiver
Future<void> sendMessage(String senderId, String receiverId, String messageText) async {
  // Save the message in Firestore
  await FirebaseFirestore.instance.collection('chats').add({
    'senderId': senderId,
    'receiverId': receiverId,
    'messageText': messageText,
    'timestamp': FieldValue.serverTimestamp(),
  });

  // Get the receiver's FCM token from Firestore
  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
  String? receiverFcmToken = userSnapshot.get('fcmToken');

  // If the receiver has an FCM token, send the notification
  if (receiverFcmToken != null) {
    await sendNotification(receiverFcmToken, messageText);
  } else {
    log("No FCM token found for receiver: $receiverId");
  }
}

/// Sends a push notification using FCM
Future<void> sendNotification(String receiverFcmToken, String messageText) async {
  const String serverKey = 'YOUR_SERVER_KEY';  // Replace with your Firebase server key

  try {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        'to': receiverFcmToken,
        'notification': {
          'title': 'New Message',
          'body': messageText,
          'sound': 'default',
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'messageText': messageText,
        },
      }),
    );

    if (response.statusCode == 200) {
      log("Notification sent successfully");
    } else {
      log("Failed to send notification: ${response.body}");
    }
  } catch (e) {
    log("Error sending notification: $e");
  }
}
