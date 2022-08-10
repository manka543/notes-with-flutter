import 'package:notes/services/notes_service_exeptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  late final String dataBasePath;
  Database? _database;
  static String dbname = "databasenote.db";
  
  
  NotesService();

  Future<void> open() async {
    if(_database != null){
      throw DatabaseAlreadyOpenException();
    } 
    try{
    final appDir = await getApplicationDocumentsDirectory();
    final dataBasePath = appDir.path + dbname;
    final database = await openDatabase(dataBasePath);
    _database = database;
    await _database?.execute("SELECT * FROM notes");
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory;
    }
  }
}