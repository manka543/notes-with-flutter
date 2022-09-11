part of 'note_view_bloc.dart';

@immutable
abstract class NoteViewState {}

class NoteViewInitial extends NoteViewState {}

class NoteViewValid extends NoteViewState {
  final DataBaseNote note;

  NoteViewValid(this.note);
}

class NoteViewError extends NoteViewState {}

class NoteViewExit extends NoteViewState {}
