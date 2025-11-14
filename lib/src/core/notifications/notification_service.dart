import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._(); // construtor privado

  static final NotificationService instance = NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const int syncNotificationId = 1001;

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidInit,
    );

    await _plugin.initialize(initializationSettings);
  }

  static Future<void> showSyncNotification({
    required String title,
    required String body,
    required int progress,     // qtd processada
    required int maxProgress,  // total
  }) async {
    // converte para porcentagem (0–100)
    final percent = maxProgress == 0 ? 0 : (progress * 100 ~/ maxProgress);

    final androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'Sincronização',
      channelDescription: 'Sincronização de pedidos',
      // ongoing: true,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: percent
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      syncNotificationId,
      title,
      '$body ($percent%)',
      details,
    );
  }


  static Future<void> completeSyncNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'Sincronização',
      channelDescription: 'Sincronização de pedidos',
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      syncNotificationId,
      title,
      body,
      details,
    );
  }
}
