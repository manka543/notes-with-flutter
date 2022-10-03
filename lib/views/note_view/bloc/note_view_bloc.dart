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
    on<ChangeFavourity>(
      (event, emit) async {
        final NotesService notesService = NotesService();
        try {
          await notesService.changeFavourity(
            favourity: event.favourity,
            id: event.id,
          );
          //emit(NoteViewValid(await notesService.getNote(id: event.id)));
          emit(NoteViewValid(DataBaseNote(
            title: "Test notatki z listą",
            text:
                "to jest bardzo dlugi tekst notatki z lista ze no takie oro ze az nie ma sily no nie no nie idziesz do domu nie ma co",
            favourite: true,
            date: DateTime.now(),
            listName: "To jest bardzo dluga nazwa listy",
            listItems: const [
              DataBaseNoteListItem("text pierwszego itemu z listy", true, 0),
              DataBaseNoteListItem(
                  "to jest troszeczke dluzszy tekst 2 itemu", true, 1),
              DataBaseNoteListItem("kup maslo 2 kostki", false, 2)
            ],
          )));
        } on CouldNotUpdateNoteException {
          emit(NoteViewError());
        }
      },
    );
  }
}
