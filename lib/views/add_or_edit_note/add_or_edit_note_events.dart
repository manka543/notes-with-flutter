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

class GetNoteEvent extends AddOrEditNoteEvent {
  final int id;

  const GetNoteEvent(this.id) : super(null);
}
