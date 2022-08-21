import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

@immutable
abstract class NotesState {
  final List<DataBaseNote>? _notes;
  const NotesState(this._notes);
}

class NotesStateValid extends NotesState {
  const NotesStateValid(super.notes);
}

class NotesStateError extends NotesState {
  const NotesStateError(super.notes, this.exception, this.message);
  final Exception? exception;
  final String? message;
}

class NotesLoadingState extends NotesState {
  const NotesLoadingState(super.notes);
}
