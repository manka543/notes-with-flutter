import 'package:flutter/services.dart';

class DatabaseException implements Exception{}

class DatabaseAlreadyOpenException implements Exception{}

class DatabaseNotOpenException implements Exception{}

class CouldNotFoundNoteException implements Exception{}

class CouldNotDeleteException implements Exception{}

class CouldNotCreateNoteException implements Exception{}

class CouldNotUpdateNoteException implements Exception{}

class NoteAlreadyExistException implements Exception{}

class UnableToGetDocumentDirectory implements Exception{}