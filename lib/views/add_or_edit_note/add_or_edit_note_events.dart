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
