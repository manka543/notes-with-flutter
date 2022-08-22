import 'package:notes/services/database_note.dart';
import 'package:notes/services/databasequeries.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/services/to_icon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  late final String dataBasePath;
  Database? _database;
  static String dbname = "databasenote.db";
  List<DataBaseNote?>? _notes;

  NotesService();

  Future<void> open() async {
    if (_database != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dataBasePath = appDir.path + dbname;
      final database = await openDatabase(dataBasePath);
      _database = database;
      await _database?.execute(createNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory;
    }
    _notes = await getallNotes();
    
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
    final rawNotes =  await database.rawQuery("SELECT * FROM $table");
    List<DataBaseNote> notes = [];
    for (var rawNote in rawNotes) {
      notes.add(DataBaseNote(
        rawNote[title].toString(),
        rawNote[text].toString(),
        toIcon(rawNote[icon].toString()),
        DateTime.parse(rawNote[date].toString()),
        DateTime.parse(rawNote[rememberDate].toString()),
        int.parse([noteid].toString())));
    }
    return notes;
  }

  Future<DataBaseNote> getNote({required int id}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final rawNotes =
        await database.rawQuery("SELECT * FROM $table WHERE $noteid = $id ");
    if(rawNotes.isEmpty){
      throw CouldNotFoundNoteException();
    }
    final rawNote = rawNotes[0];
    return DataBaseNote(
        rawNote[title].toString(),
        rawNote[text].toString(),
        toIcon(rawNote[icon].toString()),
        DateTime.parse(rawNote[date].toString()),
        DateTime.parse(rawNote[rememberDate].toString()),
        int.parse([noteid].toString()));
  }

  Future<void> updateNote({required DataBaseNote note}) async {
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
  }

  Future<void> createNote({required DataBaseNote note}) async {
    await _ensureDatabaseOpen();
    final database = getDatabase();
    final insertCount = await database.rawInsert(
      "INSERT INTO $table($title,$text,$date,$rememberDate,$icon) VALUES(?,?,?,?,?) WHERE $noteid = ?",
      [
        note.title,
        note.text,
        note.date.toString(),
        note.rememberdate.toString(),
        note.iconData,
        note.id
      ],
    );
    if (insertCount != 1) {
      throw CouldNotCreateNoteException();
    }
    _notes = await getallNotes();
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
