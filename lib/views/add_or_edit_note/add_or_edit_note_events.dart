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
  const DeleteNoteEvent(super.note);
}

class CreateEmptyNoteEvent extends AddOrEditNoteEvent {
  
  
  const CreateEmptyNoteEvent() : super(null);

}
