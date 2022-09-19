import 'package:flutter/foundation.dart';
import 'package:notes/services/database_note.dart';

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
  final DataBaseNote note;
  const AddNote(this.note);
}

class UpdateNote extends NotesEvent {
  final DataBaseNote note;
  const UpdateNote(this.note);
}

class ChangeFavourity extends NotesEvent {
  final String favourity;
  final int noteId;
  const ChangeFavourity(this.favourity, this.noteId);
}