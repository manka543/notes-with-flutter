import 'package:notes/services/database_note.dart';
import 'package:notes/services/databasequeries.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notes/const/notification_keys.dart';

class NotesService {
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  late final String dataBasePath;
  Database? _database;
  static String dbname = "databasenote.db";

  Future<void> open() async {
    if (_database != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dataBasePath = join(appDir.path, dbname);
      final database = await openDatabase(dataBasePath);
      _database = database;
      await _database?.execute(createNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory;
    }
  }

  void notificationInitialize() {
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

  Future<void> _ensureDatabaseOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // do nothing
    }
  }

  Future<void> close() async {
    final database = _database;
    if (database != null) {
      await database.close();
      _database = null;
    } else {
      throw DatabaseNotOpenException();
    }
  }

  Database getDatabase() {
    final database = _database;
    if (database == null) {
      throw DatabaseNotOpenException();
    } else {
      return database;
    }
  }

  Future<List<DataBaseNote>> getallNotes() async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final rawNotes = await database.rawQuery("SELECT * FROM $table");
    List<DataBaseNote> notes = [];
    for (var rawNote in rawNotes) {
      notes.add(DataBaseNote(
          title: rawNote[title].toString(),
          text: rawNote[text].toString(),
          icon: rawNote[icon].toString(),
          date: DateTime.parse(rawNote[date].toString()),
          rememberdate: DateTime.tryParse(rawNote[rememberDate].toString()),
          id: int.parse(rawNote[noteid].toString())));
    }
    return notes;
  }

  Future<DataBaseNote> getNote({required int id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final rawNotes =
        await database.rawQuery("SELECT * FROM $table WHERE $noteid = $id ");
    if (rawNotes.isEmpty) {
      throw CouldNotFoundNoteException();
    }
    final rawNote = rawNotes[0];
    return DataBaseNote(
        title: rawNote[title].toString(),
        text: rawNote[text].toString(),
        icon: rawNote[icon].toString(),
        date: DateTime.parse(rawNote[date].toString()),
        rememberdate: DateTime.tryParse(rawNote[rememberDate].toString()),
        id: int.parse(rawNote[noteid].toString()));
  }

  Future<DataBaseNote> updateNote({required DataBaseNote note}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final oldNote = await getNote(id: note.id!);
    final updateCount = await database.update(
        table,
        {
          title: note.title,
          text: note.text,
          rememberDate: note.rememberdate.toString(),
          icon: note.icon,
        },
        where: '$noteid = ?',
        whereArgs: [note.id]);
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    if (oldNote.rememberdate != null &&
        oldNote.rememberdate!.isAfter(DateTime.now())) {
      cancelSheduledNotification(id: note.id!);
    }
    if (note.rememberdate != null &&
        note.rememberdate!.isAfter(DateTime.now())) {
      showScheduledNotification(
        id: note.id!,
        title: note.title,
        text: note.text,
        date: note.rememberdate!,
      );
    }
    return await getNote(id: note.id!);
  }

  Future<DataBaseNote> createNote({required DataBaseNote note}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final insertId = await database.rawInsert(
      "INSERT INTO $table($title,$text,$date,$rememberDate,$icon) VALUES(?,?,?,?,?)",
      [
        note.title,
        note.text,
        note.date.toString(),
        note.rememberdate.toString(),
        note.icon,
      ],
    );
    if (insertId == 0) {
      throw CouldNotCreateNoteException();
    }
    if (note.rememberdate != null &&
        note.rememberdate!.isAfter(DateTime.now())) {
      showScheduledNotification(
        id: note.id!,
        title: note.title,
        text: note.text,
        date: note.rememberdate!,
      );
    }
    return await getNote(id: insertId);
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final deletedNote = await getNote(id: id);
    final noteDeleteCount =
        await database.rawDelete("""DELETE FROM $table WHERE $noteid = $id """);
    if (deletedNote.rememberdate != null &&
        deletedNote.rememberdate!.isAfter(DateTime.now())) {
      cancelSheduledNotification(id: id);
    }

    if (noteDeleteCount != 1) {
      throw CouldNotDeleteException();
    }
  }
}
