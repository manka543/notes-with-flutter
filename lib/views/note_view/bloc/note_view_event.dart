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
