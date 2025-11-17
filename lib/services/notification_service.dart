import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Function(AppNotification)? onNotificationReceived;

  Future<void> initialize() async {
    // Request permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final isImportant = message.data['important'] == 'true';

    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      isImportant: isImportant,
      timestamp: DateTime.now(),
    );

    // Play alert sound
    _playAlertSound(isImportant);

    // Notify listener
    onNotificationReceived?.call(notification);
  }

  Future<void> _playAlertSound(bool isImportant) async {
    try {
      // Use system sounds or custom sound
      if (isImportant) {
        await _audioPlayer.play(AssetSource('sounds/alert.mp3'));
      } else {
        await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}