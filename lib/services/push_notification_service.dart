import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  static const _channelId = 'masarak_notifications';
  static const _channelName = 'Masarak notifications';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _tokenChanges =
      StreamController<String>.broadcast();
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  bool _initialized = false;

  Stream<String> get tokenChanges => _tokenChanges.stream;

  Future<void> initialize() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    if (_initialized) return;

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _localNotifications.initialize(settings: initializationSettings);

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Updates and alerts from Masarak',
      importance: Importance.max,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _foregroundMessageSubscription =
        FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    _tokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen(_tokenChanges.add);
    _initialized = true;
  }

  Future<String?> requestPermissionAndGetToken() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError(
        'Push notification setup is currently available on Android only.',
      );
    }
    if (!_initialized) {
      throw StateError('Push notifications have not been initialized.');
    }

    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return null;
    }

    return FirebaseMessaging.instance.getToken();
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();
    if (title == null && body == null) return;

    await _localNotifications.show(
      id: message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Updates and alerts from Masarak',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> dispose() async {
    await _foregroundMessageSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    await _tokenChanges.close();
  }
}
