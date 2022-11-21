import 'package:notes/const/routes.dart';
import 'package:notes/functions/to_bool.dart';
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
  static const String dbname = "databasenote.db";

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
      required String? title,
      required String? text,
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
      //     schedule: NotificationAndroidCrontab(
      //   allowWhileIdle: true,
      //   repeats: false,
      //   preciseSchedules: [date],
      //   initialDateTime: date.subtract(Duration(hours: date.hour, minutes: date.minute)),
      //   expirationDateTime: date.add(const Duration(days: 365)),
      //   preciseAlarm: true,
      //   // crontabExpression: "5 42 22 ? * MON-FRI *",
      // ),
      schedule: NotificationCalendar(
        allowWhileIdle: true,
        preciseAlarm: true,
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
      Duration? pressedDuration;
      if (notification.buttonKeyPressed == "DELETE") {
        await deleteNote(id: notification.id!);
        return;
      } else if (notification.buttonKeyPressed == "REMIND_IN_10_MIN") {
        pressedDuration = const Duration(minutes: 10);
      } else if (notification.buttonKeyPressed == "REMIND_IN_1_H") {
        pressedDuration = const Duration(hours: 1);
      } else if (notification.buttonKeyPressed == "REMIND_IN_1_D") {
        pressedDuration = const Duration(days: 1);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context,
            noteViewRoute,
            arguments: notification.id,
            (route) => route.isFirst);
      }
      switch (notification.actionLifeCycle) {
        case NotificationLifeCycle.Foreground:
        case NotificationLifeCycle.Background:
          final note = await getNote(id: notification.id!);
          await updateNote(
              note: DataBaseNote(
            title: note.title,
            text: note.text,
            favourite: note.favourite,
            date: note.date,
            rememberdate: DateTime.now().add(pressedDuration ??=
                pressedDuration ?? const Duration(seconds: 0)),
            id: notification.id,
          ));
          break;
        case NotificationLifeCycle.AppKilled:
          showScheduledNotification(
              id: notification.id!,
              title: notification.title,
              text: notification.body,
              date: DateTime.now().add(pressedDuration ??=
                  pressedDuration ?? const Duration(seconds: 0)));
          break;
        case null:
          break;
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
    final rawNotes = await database
        .rawQuery("""SELECT * FROM $table WHERE $archived = "false" """);
    List<DataBaseNote> notes = [];
    for (var rawNote in rawNotes) {
      notes.add(
        DataBaseNote(
          title: rawNote[title].toString(),
          text: rawNote[text].toString(),
          favourite: toBool(rawNote[favourite] as String),
          date: DateTime.parse(rawNote[date].toString()),
          rememberdate: DateTime.tryParse(rawNote[rememberDate].toString()),
          id: int.parse(rawNote[noteId].toString()),
          archived: toBool(rawNote[archived] as String),
          order: rawNote[position] as int?,
        ),
      );
    }
    notes.sort(
      (a, b) =>
          a.order?.compareTo(b.order ?? b.id!) ??
          a.id!.compareTo(b.order ?? b.id!),
    );
    return notes;
  }

  Future<List<DataBaseNote>> getArchivedNotes() async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final rawNotes = await database
        .rawQuery("""SELECT * FROM $table WHERE $archived = "true" """);
    List<DataBaseNote> notes = [];
    for (var rawNote in rawNotes) {
      notes.add(
        DataBaseNote(
          title: rawNote[title].toString(),
          text: rawNote[text].toString(),
          favourite: toBool(rawNote[favourite] as String),
          date: DateTime.parse(rawNote[date].toString()),
          rememberdate: DateTime.tryParse(rawNote[rememberDate].toString()),
          id: int.parse(rawNote[noteId].toString()),
          archived: toBool(rawNote[archived] as String),
          order: rawNote[position] as int?,
        ),
      );
    }
    notes.sort(
      (a, b) =>
          a.order?.compareTo(b.order ?? b.id!) ??
          a.id!.compareTo(b.order ?? b.id!),
    );
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
      items = await getAllListItems(id: id);
    }

    return DataBaseNote(
      title: rawNote[title].toString(),
      text: rawNote[text].toString(),
      favourite: toBool(rawNote[favourite] as String),
      date: DateTime.parse(rawNote[date].toString()),
      rememberdate: DateTime.tryParse(rawNote[rememberDate].toString()),
      id: int.parse(rawNote[noteId].toString()),
      listName: rawNote[listTitle] as String?,
      listItems: items,
      archived: toBool(rawNote[archived] as String),
    );
  }

  Future<List<DataBaseNoteListItem>?> getAllListItems({required id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    List<DataBaseNoteListItem>? items = [];
    final rawListItems = await database
        .rawQuery("SELECT * FROM $itemsTable WHERE $itemNoteID = $id");
    for (var rawItem in rawListItems) {
      items.add(DataBaseNoteListItem(
        text: rawItem[itemText] as String,
        done: toBool(rawItem[itemDone] as String),
        id: rawItem[itemId] as int,
      ));
    }
    return items;
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
          favourite: note.favourite.toString(),
          list: note.listItems?.isNotEmpty.toString() ?? false.toString(),
          listTitle: note.listName,
          archived: note.archived.toString(),
          position: note.order,
        },
        where: '$noteId = ?',
        whereArgs: [note.id]);
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    // if (oldNote.listItems != null && oldNote.listItems!.isNotEmpty) {
    //   final deleteCount = await database
    //       .rawDelete("DELETE FROM $itemsTable WHERE $itemNoteID = ${note.id}");
    //   if (deleteCount != oldNote.listItems!.length) {
    //     throw CouldNotDeleteException();
    //   }
    // }
    // if (note.listItems != null) {
    //   for (var item in note.listItems!) {
    //     await createListItem(item: item, noteID: note.id!);
    //   }
    // }
    if (note.listItems == null) {
      if (oldNote.listItems != null) {
        final itemDeleteCount = await database.rawDelete(
            "DELETE FROM $itemsTable WHERE $itemNoteID = ${note.id}");
        if (itemDeleteCount != oldNote.listItems?.length) {
          throw CouldNotDeleteException();
        }
      }
    } else {
      List<int> oldItemsIds = [];
      if (oldNote.listItems?.isNotEmpty ?? false) {
        for (var element in oldNote.listItems!) {
          oldItemsIds.add(element.id!);
        }
      }
      print(note.listItems);
      for (var element in note.listItems!) {
        if (element.id == null) {
          print("i am creating list item: $element");
          createListItem(item: element, noteID: note.id!);
        } else {
          print("i am updating list item: $element");

          final itemUpdateCount = await database.rawUpdate(
            "UPDATE $itemsTable SET $itemDone = ?, $itemText = ? WHERE $itemId = ${element.id}",
            [
              element.done.toString(),
              element.text,
            ],
          );
          if (itemUpdateCount != 1) {
            throw CouldNotUpdateNoteException();
          }

          print("1${oldItemsIds.remove(element.id)}");
          print("here $oldItemsIds");
        }
      }
      for (var element1 in oldItemsIds) {
        final deleted = await database
            .rawDelete("DELETE FROM $itemsTable WHERE $itemId = $element1");
        if (deleted != 1) {
          throw CouldNotUpdateNoteException();
        }
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

  Future<DataBaseNote> changeFavourity({
    required int id,
    required String favourity,
  }) async {
    await _ensureDatabaseOpen();
    final dataBase = getDatabase();
    final updateCount = await dataBase.rawUpdate(
        "UPDATE $table SET $favourite = ? WHERE $noteId = ?", [favourity, id]);
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    return await getNote(id: id);
  }

  Future<DataBaseNote> changeArchive({
    required int id,
    required bool archiveStatus,
  }) async {
    await _ensureDatabaseOpen();
    final dataBase = getDatabase();
    final updateCount = await dataBase.rawUpdate(
        "UPDATE $table SET $archived = ? WHERE $noteId = ?",
        [archiveStatus.toString(), id]);
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
        note.favourite.toString(),
        note.listName,
        note.listItems?.isNotEmpty ?? false.toString(),
        note.archived.toString(),
      ],
    );
    if (insertId == 0) {
      throw CouldNotCreateNoteException();
    }
    if (note.listItems?.isNotEmpty ?? false) {
      for (var listItem in note.listItems!) {
        final insertItemId = await database.rawInsert(
            "INSERT INTO $itemsTable($itemText,$itemDone,$itemNoteID) VALUES(?,?,?)",
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
      final deletedItemCount = await database.rawDelete(
          "DELETE FROM $itemsTable WHERE $itemNoteID = ${deletedNote.id}");
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
        item.done.toString(),
        noteID,
      ],
    );
    if (newItemId == 0) {
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
        text: rawItem[itemText] as String,
        done: toBool(rawItem[itemDone] as String),
        id: id);

    return item;
  }

  Future<DataBaseNoteListItem> updateListItem(
      {required DataBaseNoteListItem item}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final updateCount = await database.rawUpdate(
        "UPDATE $itemsTable SET $itemText = ?, $itemDone = ? WHERE $itemId = ${item.id}",
        [item.text, item.done]);
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    return await getListItem(id: item.id!);
  }

  Future<DataBaseNoteListItem> changeItemProgress(
      {required int id, required bool progress}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final updateCount = await database.rawUpdate(
        "UPDATE $itemsTable SET $itemDone = ? WHERE $itemId = ?",
        [progress.toString(), id]);
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    return await getListItem(id: id);
  }

  Future<void> changeNoteOrder({
    required int index,
    required int id,
  }) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final updateCount1 = await database
        .rawUpdate("UPDATE $table SET $position = $index WHERE $noteId = $id");
    if (updateCount1 != 1) {
      throw CouldNotUpdateNoteException();
    }
  }
}
