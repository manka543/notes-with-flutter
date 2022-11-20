import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

@immutable
abstract class NotesState {
  final List<DataBaseNote>? notes;
  const NotesState(this.notes);
}

class NotesStateValid extends NotesState {
  const NotesStateValid(super.notes);
}

class ArchivedNotesStateValid extends NotesState {
  const ArchivedNotesStateValid(super.notes);
}

class NotesStateError extends NotesState {
  const NotesStateError(super.notes, this.exception, this.message);
  final Exception? exception;
  final String? message;
}

class NotesLoadingState extends NotesState {
  const NotesLoadingState(super.notes);
}

class NotesInitState extends NotesState {
  const NotesInitState(super.notes);
}
