part of 'note_view_bloc.dart';

@immutable
abstract class NoteViewEvent {}

class GetNoteEvent extends NoteViewEvent {
  final int id;

  GetNoteEvent(this.id);
}

class DeleteNoteEvent extends NoteViewEvent {
  final int id;

  DeleteNoteEvent(this.id);
}

class ChangeFavourity extends NoteViewEvent {
  final String favourity;
  final int id;

  ChangeFavourity(this.favourity, this.id);
}

class ChangeItemProgres extends NoteViewEvent {
  final bool progress;
  final int id;
  final DataBaseNote note;

  ChangeItemProgres({required this.progress, required this.id, required this.note});
}

class DeleteItem extends NoteViewEvent {
  final int id;
  final DataBaseNote note;

  DeleteItem({required this.id,required this.note});
}
