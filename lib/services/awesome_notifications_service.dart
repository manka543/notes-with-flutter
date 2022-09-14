import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

const notesChannelKey = "notesChannel";

class AwesomeNotificationService {
  AwesomeNotificationService();

  void ensureInitializaed() {
    AwesomeNotifications().initialize(
      "resource://drawable/res_ic_notes",
      [
        NotificationChannel(
          channelName: "Notes channel",
          channelShowBadge: true,
          channelDescription: "Notification channel to for user notes",
          defaultColor: Colors.yellow,
          channelKey: notesChannelKey,
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
        )
      ],
    );
  }

  Future<void> cancelSheduledNotification({required int id}) async {
    AwesomeNotifications().cancelSchedule(id);
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String text,
      required DateTime date}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          channelKey: notesChannelKey,
          id: id,
          title: title,
          body: text,
          color: Colors.yellow,
          category: NotificationCategory.Reminder,
          notificationLayout: NotificationLayout.Default),
      schedule: NotificationCalendar(
        allowWhileIdle: true,
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        second: 0,
        millisecond: 0,
      ),
      actionButtons: [
        NotificationActionButton(key: "DELETE_NOTE", label: "Delete note"),
        NotificationActionButton(key: "OPEN_NOTE", label: "Open note"),
      ],
    );
  }
}
