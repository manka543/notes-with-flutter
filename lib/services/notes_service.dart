import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/databasequeries.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/services/to_icon.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;


  late final String dataBasePath;
  Database? _database;
  static String dbname = "databasenote.db";
  List<DataBaseNote?>? _notes;


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
      //final czysieudalo = await _database?.rawInsert(""" INSERT INTO $table($title,$text,$date,$rememberDate,$icon) VALUES("testitle","testext","2022-08-22 15:02","2022-08-23 15:02","share") """);
      //if(czysieudalo == 1){
      //  print("udalo sie");
      //}
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory;
    }
    
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
          rawNote[title].toString(),
          rawNote[text].toString(),
          rawNote[icon].toString(),
          DateTime.parse(rawNote[date].toString()),
          DateTime.tryParse(rawNote[rememberDate].toString()),
          int.parse(rawNote[noteid].toString())));
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
        rawNote[title].toString(),
        rawNote[text].toString(),
        rawNote[icon].toString(),
        DateTime.parse(rawNote[date].toString()),
        DateTime.tryParse(rawNote[rememberDate].toString()),
        int.parse(rawNote[noteid].toString()));
  }

  Future<DataBaseNote> updateNote({required DataBaseNote note}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final updateCount = await database.rawUpdate(
      """UPDATE $table SET $title = ?, $text = ?, $rememberDate = ? WHERE $noteid = ? """,
      [note.title, note.text, note.rememberdate.toString(), note.id],
    );
    if (updateCount != 1) {
      throw CouldNotUpdateNoteException();
    }
    _notes = await getallNotes();
    return await getNote(id: note.id!);
  }

  Future<DataBaseNote> createNote({required DataBaseNote note}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final insertCount = await database.rawInsert(
      "INSERT INTO $table($title,$text,$date,$rememberDate,$icon) VALUES(?,?,?,?,?)",
      [
        note.title,
        note.text,
        note.date.toString(),
        note.rememberdate.toString(),
        note.icon,
      ],
    );
    if (insertCount != 1) {
      //throw CouldNotCreateNoteException();
    }
    _notes = await getallNotes();
    return await getNote(id: insertCount);
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final noteDeleteCount =
        await database.rawDelete("""DELETE FROM $table WHERE $noteid = $id """);
    if (noteDeleteCount != 1) {
      throw CouldNotDeleteException();
    }
    _notes = await getallNotes();
  }
}
