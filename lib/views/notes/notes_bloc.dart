import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/views/notes/notes_event.dart';
import 'package:notes/views/notes/notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesInitState(null)) {
    on<GetAllNotes>(
      (event, emit) async {
        try {
          final NotesService notesService = NotesService();
          final notes = await notesService.getallNotes();
          emit(NotesStateValid(
            notes,
          ));
        } catch (exception) {
          print(exception);
          emit(const NotesStateError(null, null, null));
        }
      },
    );
    on<DeleteNote>(
      (event, emit) async {
        print("usuwanie notatki o id: "+ event.id.toString());
        final NotesService notesService = NotesService();
        try {
          await notesService.deleteNote(id: event.id);
        } on CouldNotDeleteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotDeleteException(),
              "there was an error with deleting your note"));
        }
        final notes = await notesService.getallNotes();
        emit(NotesStateValid(notes));
      },
    );
  }
}
