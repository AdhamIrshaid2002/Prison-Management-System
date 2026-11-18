import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  
  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prison_channel',
          'Prison Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

 
  static Future<void> sendAndSave({
    required String prisonerId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String type, 
  }) async {
    final docId = "${prisonerId}_$type"; 
    final docRef = FirebaseFirestore.instance.collection("notifications").doc(docId);

    final doc = await docRef.get();
    if (doc.exists) return; 

    
    await showNow(
      id: docId.hashCode,
      title: title,
      body: body,
    );

   
    await docRef.set({
      "prisonerId": prisonerId,
      "title": title,
      "body": body,
      "scheduledAt": scheduledAt,
      "type": type,
      "createdAt": DateTime.now(),
    });
  }
}
