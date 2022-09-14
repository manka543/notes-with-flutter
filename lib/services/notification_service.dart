import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final _notificationService = AndroidFlutterLocalNotificationsPlugin();

  Future<void> ensureInitializaed() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_notes");
    tz.initializeTimeZones();
    await _notificationService.initialize(androidInitializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  AndroidNotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'chanel_id',
      'channelName',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
    return androidNotificationDetails;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String text,
  }) async {
    ensureInitializaed();
    final AndroidNotificationDetails details = _notificationDetails();
    await _notificationService.show(id, title, text,
        notificationDetails: _notificationDetails());
  }

  Future<void> cancelSheduledNotification({
    required int id,
  }) async {
    ensureInitializaed();
    await _notificationService.cancel(id);
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String text,
      required DateTime date,
      required}) async {
    ensureInitializaed();
    final AndroidNotificationDetails details = _notificationDetails();
    await _notificationService.zonedSchedule(
      id,
      title,
      text,
      tz.TZDateTime.from(date, tz.local),
      _notificationDetails(),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}

// void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload){
//  print('id: $id');
// }

void _onSelectNotification(String? payload) {
  print("payload: $payload");
}
