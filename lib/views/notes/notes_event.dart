import 'package:flutter/foundation.dart';

@immutable
abstract class NotesEvent {
  const NotesEvent();
}

class GetAllNotes extends NotesEvent {
  const GetAllNotes();
}

class DeleteNote extends NotesEvent {
  final int id;
  const DeleteNote(this.id);
}

class AddNote extends NotesEvent {
  final int id;
  const AddNote(this.id);
}