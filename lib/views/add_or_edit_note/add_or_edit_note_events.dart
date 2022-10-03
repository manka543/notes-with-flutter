import 'package:flutter/cupertino.dart';
import 'package:notes/services/database_note.dart';

@immutable
abstract class AddOrEditNoteEvent {
  final DataBaseNote? note;
  const AddOrEditNoteEvent(this.note);
}

class EditNoteEvent extends AddOrEditNoteEvent {
  const EditNoteEvent(super.note);
}

class DeleteNoteEvent extends AddOrEditNoteEvent {
  final int? id;
  const DeleteNoteEvent(this.id) : super(null);
}

class CreateEmptyNoteEvent extends AddOrEditNoteEvent {
  const CreateEmptyNoteEvent() : super(null);
}

class ChangeFavourity extends AddOrEditNoteEvent {
  final String favourity;
  final int id;
  const ChangeFavourity(this.favourity, this.id) : super(null);
}

class GetNoteEvent extends AddOrEditNoteEvent {
  final int id;
  const GetNoteEvent(this.id) : super(null);
}

class FinalEditEvent extends AddOrEditNoteEvent {
  const FinalEditEvent(super.note);
}

class CreateNoteListItem extends AddOrEditNoteEvent {
  final DataBaseNoteListItem item;
  final int noteId;
  const CreateNoteListItem(this.item, this.noteId) : super(null);
}

class DeleteNoteListItem extends AddOrEditNoteEvent {
  final int id;
  final int noteId;
  const DeleteNoteListItem(this.id, this.noteId) : super(null);
}

class EditNoteListItem extends AddOrEditNoteEvent {
  final DataBaseNoteListItem item;
  final int noteId;
  const EditNoteListItem(this.item, this.noteId) : super(null);
}
