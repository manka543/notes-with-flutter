import 'package:notes/const/routes.dart';
import 'package:notes/fuctions/to_bool.dart';
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
      await _database?.execute(createListItemsTable);
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
        NotificationActionButton(
            key: "DELETE",
            label: "Delete",
            buttonType: ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: "REMIND_IN_10_MIN",
            label: "10 min",
            buttonType: ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: "REMIND_IN_1_H",
            label: "1 h",
            buttonType: ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: "REMIND_IN_1_D",
            label: "1 day",
            buttonType: ActionButtonType.KeepOnTop),
      ],
    );
  }

  void createNotificationListeners(BuildContext context) {
    AwesomeNotifications().actionStream.listen((notification) async {
      if (notification.buttonKeyPressed == "DELETE") {
        await deleteNote(id: notification.id!);
      } else if (notification.buttonKeyPressed == "REMIND_IN_10_MIN") {
        final note = await getNote(id: notification.id!);
        await updateNote(
            note: DataBaseNote(
          title: note.title,
          text: note.text,
          favourite: note.favourite,
          date: note.date,
          rememberdate: DateTime.now().add(const Duration(minutes: 10)),
          id: notification.id,
        ));
      } else if (notification.buttonKeyPressed == "REMIND_IN_1_H") {
        final note = await getNote(id: notification.id!);
        await updateNote(
            note: DataBaseNote(
          title: note.title,
          text: note.text,
          favourite: note.favourite,
          date: note.date,
          rememberdate: DateTime.now().add(const Duration(hours: 1)),
          id: notification.id,
        ));
      } else if (notification.buttonKeyPressed == "REMIND_IN_1_D") {
        final note = await getNote(id: notification.id!);
        await updateNote(
            note: DataBaseNote(
          title: note.title,
          text: note.text,
          favourite: note.favourite,
          date: note.date,
          rememberdate: DateTime.now().add(const Duration(days: 1)),
          id: notification.id,
        ));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context,
            noteViewRoute,
            arguments: notification.id,
            (route) => route.isFirst);
      }
    });
  }

  void disposeStreams() {
    AwesomeNotifications().actionSink.close();
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
      notes.add(
        DataBaseNote(
            title: rawNote[title].toString(),
            text: rawNote[text].toString(),
            favourite: rawNote[favourite].toString(),
            date: DateTime.parse(rawNote[date].toString()),
            rememberdate: DateTime.tryParse(rawNote[rememberDate].toString()),
            id: int.parse(rawNote[noteId].toString()),
            archived: toBool(rawNote[archived] as String)),
      );
    }
    return notes;
  }

  Future<DataBaseNote> getNote({required int id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final rawNotes =
        await database.rawQuery("SELECT * FROM $table WHERE $noteId = $id ");
    if (rawNotes.isEmpty) {
      throw CouldNotFoundNoteException();
    }
    final rawNote = rawNotes[0];
    List<DataBaseNoteListItem>? items;
    if (rawNote[list] == "true") {
      final rawListItems = await database
          .rawQuery("SELECT * FROM $itemsTable WHERE $itemNoteID = $id");
      items = [];
      for (var rawItem in rawListItems) {
        items.add(DataBaseNoteListItem(
          rawItem[itemText] as String,
          toBool(rawItem[itemDone] as String),
          rawItem[itemId] as int,
        ));
      }
    }

    return DataBaseNote(
      title: rawNote[title].toString(),
      text: rawNote[text].toString(),
      favourite: rawNote[favourite].toString(),
      date: DateTime.parse(rawNote[date].toString()),
      rememberdate: DateTime.tryParse(rawNote[rememberDate].toString()),
      id: int.parse(rawNote[noteId].toString()),
      listName: rawNote[listTitle] as String?,
      listItems: items,
      archived: toBool(rawNote[archived] as String),
    );
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
          favourite: note.favourite,
          list: note.listItems?.isNotEmpty.toString() ?? false.toString(),
          listTitle: note.listName,
          archived: note.archived.toString(),
        },
        where: '$noteId = ?',
        whereArgs: [note.id]);
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    if (oldNote.listItems != null && oldNote.listItems!.isNotEmpty) {
      final deleteCount = await database
          .rawDelete("DELETE FROM $itemsTable WHERE $itemNoteID = ${note.id}");
      if (deleteCount != oldNote.listItems!.length) {
        throw CouldNotDeleteException();
      }
    }
    if (note.listItems != null) {
      for (var item in note.listItems!) {
        await createListItem(item: item, noteID: note.id!);
      }
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

  Future<DataBaseNote> changeFavourity(
      {required int id, required String favourity}) async {
    await _ensureDatabaseOpen();
    final dataBase = getDatabase();
    final updateCount = await dataBase.rawUpdate(
        "UPDATE $table SET $favourite = ? WHERE $noteId = ?", [favourity, id]);
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    return await getNote(id: id);
  }

  Future<DataBaseNote> createNote({required DataBaseNote note}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final insertId = await database.rawInsert(
      "INSERT INTO $table($title,$text,$date,$rememberDate,$favourite,$listTitle,$list,$archived) VALUES(?,?,?,?,?,?,?,?)",
      [
        note.title,
        note.text,
        note.date.toString(),
        note.rememberdate.toString(),
        note.favourite,
        note.listName,
        note.listItems?.isNotEmpty ?? false,
        note.archived.toString(),
      ],
    );
    if (insertId == 0) {
      throw CouldNotCreateNoteException();
    }
    if (note.listItems?.isNotEmpty ?? false) {
      for (var listItem in note.listItems!) {
        final insertItemId = await database.rawInsert(
            "INSERT INTO $itemsTable($itemText,$itemDone,$itemNoteID) VALUES(?,?,?,?)",
            [
              listItem.text,
              listItem.done,
              insertId,
            ]);
        if (insertItemId == 0) {
          throw CouldNotCreateNoteException();
        }
      }
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
    if (deletedNote.listItems?.isNotEmpty ?? false) {
      final deletedItemCount = database.rawDelete(
              "DELETE FROM $itemsTable WHERE $itemNoteID = ${deletedNote.id}")
          as int?;
      if (deletedItemCount != deletedNote.listItems?.length) {
        throw CouldNotDeleteException();
      }
    }
    final noteDeleteCount =
        await database.rawDelete("""DELETE FROM $table WHERE $noteId = $id """);
    if (deletedNote.rememberdate != null &&
        deletedNote.rememberdate!.isAfter(DateTime.now())) {
      cancelSheduledNotification(id: id);
    }

    if (noteDeleteCount != 1) {
      throw CouldNotDeleteException();
    }
  }

  Future<void> deleteListItem({required int id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final itemDeleteCount =
        await database.rawDelete("DELETE FROM $itemsTable WHERE $itemId = $id");
    if (itemDeleteCount != 1) {
      throw CouldNotDeleteException();
    }
  }

  Future<DataBaseNoteListItem> createListItem(
      {required DataBaseNoteListItem item, required int noteID}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final newItemId = await database.rawInsert(
      "INSERT INTO $itemsTable($itemText, $itemDone, $itemNoteID) VALUES(?,?,?)",
      [
        item.text,
        item.done,
        noteID,
      ],
    );
    if (newItemId != 0) {
      throw CouldNotCreateNoteException();
    }
    return await getListItem(id: newItemId);
  }

  Future<DataBaseNoteListItem> getListItem({required int id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final rawItems = await database
        .rawQuery("SELECT * FROM $itemsTable WHERE $itemId = $id");
    final rawItem = rawItems[0];
    final item = DataBaseNoteListItem(
        rawItem[itemText] as String, toBool(rawItem[itemDone] as String), id);

    return item;
  }

  Future<DataBaseNoteListItem> updateListItem(
      {required DataBaseNoteListItem item}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final updateCount = await database.rawUpdate(
        "UPDATE $itemsTable SET $itemText = ?, $itemDone = ?, $itemNoteID = ? WHERE $itemId = ${item.id}");
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    return await getListItem(id: item.id!);
  }
}
