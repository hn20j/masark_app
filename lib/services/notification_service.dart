import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../screens/notifications_screen.dart';

class NotificationService {
  NotificationService._();

  static const _channel = AndroidNotificationChannel(
    'masarak_notifications',
    'Masarak notifications',
    description: 'Notifications about your Masarak account and activity.',
    importance: Importance.high,
  );

  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static bool _pendingTap = false;
  static bool _localNotificationsInitialized = false;

  static Future<void> initialize() async {
    await _initializeLocalNotifications(onTap: _handleLocalNotificationTap);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteNotificationTap);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _pendingTap = true;
    }

    final launchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _pendingTap = true;
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (defaultTargetPlatform != TargetPlatform.android ||
        message.notification != null) {
      return;
    }
    await _showLocalNotification(message);
  }

  static void handlePendingTap() {
    if (!_pendingTap || navigatorKey.currentState == null) {
      return;
    }
    _pendingTap = false;
    _openNotifications();
  }

  static Future<void> _initializeLocalNotifications({
    DidReceiveNotificationResponseCallback? onTap,
  }) async {
    if (_localNotificationsInitialized) {
      return;
    }

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: onTap,
    );

    final androidNotifications =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidNotifications?.createNotificationChannel(_channel);
    _localNotificationsInitialized = true;
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _showLocalNotification(message);
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];
    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    await _initializeLocalNotifications();
    await _localNotifications.show(
      id: message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'notifications',
    );
  }

  static void _handleRemoteNotificationTap(RemoteMessage message) {
    _openNotifications();
  }

  static void _handleLocalNotificationTap(NotificationResponse response) {
    _openNotifications();
  }

  static void _openNotifications() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      _pendingTap = true;
      return;
    }
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  }
}
