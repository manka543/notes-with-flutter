import 'package:flutter/foundation.dart';
import 'package:notes/services/database_note.dart';

@immutable
abstract class AddOrEditNoteState {
  final DataBaseNote? note;

  const AddOrEditNoteState(this.note);
}

class AddOrEditNoteInitialState extends AddOrEditNoteState {
  const AddOrEditNoteInitialState(super.note);
}

class AddOrEditNoteStateValid extends AddOrEditNoteState {
  const AddOrEditNoteStateValid(super.note);
}

class AddOrEditNoteStateLoading extends AddOrEditNoteState {
  const AddOrEditNoteStateLoading(super.note);
}

class AddOrEditNoteStateError extends AddOrEditNoteState {
  const AddOrEditNoteStateError(super.note);
}