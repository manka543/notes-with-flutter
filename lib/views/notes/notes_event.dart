import 'package:flutter/foundation.dart';
import 'package:notes/services/database_note.dart';

@immutable
abstract class NotesEvent {
  final bool archiveView;
  const NotesEvent(this.archiveView);
}

class GetAllNotes extends NotesEvent {
  const GetAllNotes(super.archiveView);
}

class DeleteNote extends NotesEvent {
  final int id;
  const DeleteNote(this.id, super.archiveView);
}

class ChangeFavourity extends NotesEvent {
  final String favourity;
  final int noteId;
  const ChangeFavourity(this.favourity, this.noteId, super.archiveView);
}

class ChangeNotesOrder extends NotesEvent {
  final List<DataBaseNote> notes;
  const ChangeNotesOrder(this.notes, super.archiveView);
}
