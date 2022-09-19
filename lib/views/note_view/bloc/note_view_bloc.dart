import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';

part 'note_view_event.dart';
part 'note_view_state.dart';

class NoteViewBloc extends Bloc<NoteViewEvent, NoteViewState> {
  NoteViewBloc() : super(NoteViewInitial()) {
    on<GetNoteEvent>((event, emit) async {
      try {
        final NotesService notesService = NotesService();
        final note = await notesService.getNote(id: event.id);
        emit(NoteViewValid(
          note,
        ));
      } catch (exception) {
        emit(NoteViewExit());
      }
    });
    on<DeleteNoteEvent>((event, emit) async {
      final NotesService notesService = NotesService();
      try {
        await notesService.deleteNote(id: event.id);
      } on CouldNotDeleteException {
        emit(NoteViewError());
      }
      emit(NoteViewExit());
    });
    on<ChangeFavourity>((event, emit) async {
      final NotesService notesService = NotesService();
      try{
        await notesService.changeFavourity(favourity: event.favourity, id: event.id,);
        emit(NoteViewValid(await notesService.getNote(id: event.id)));
      } on CouldNotUpdateNoteException {
        emit(NoteViewError());
      }
    },);
  }
}
