import 'package:flutter/cupertino.dart';
import 'package:notes/services/database_note.dart';

@immutable
abstract class AddOrEditNoteEvent {
  final DataBaseNote? note;
  const AddOrEditNoteEvent(this.note);
}

class AddNoteEvent extends AddOrEditNoteEvent {
  const AddNoteEvent(super.note);
}

class EditNoteEvent extends AddOrEditNoteEvent {
  const EditNoteEvent(super.note);
}

class DeleteNoteEvent extends AddOrEditNoteEvent {
  const DeleteNoteEvent(super.note);
}

class GetNoteEvent extends AddOrEditNoteEvent {
  const GetNoteEvent(super.note);
}
