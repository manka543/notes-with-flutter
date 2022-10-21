import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/views/notes/notes_event.dart';
import 'package:notes/views/notes/notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesInitState(null)) {
    on<GetAllNotes>(
      (event, emit) async {
        // try {
          final NotesService notesService = NotesService();
          final notes = await notesService.getallNotes();
          emit(NotesStateValid(
            notes,
          ));
          return;
        // } catch (exception) {
        //   print(exception);
        //   emit(const NotesStateError(null, null, null));
        // }
      },
    );
    on<DeleteNote>(
      (event, emit) async {
        final NotesService notesService = NotesService();
        try {
          await notesService.deleteNote(id: event.id);
        } on CouldNotDeleteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotDeleteException(),
              "there was an error with deleting your note"));
              return;
        }
        emit(NotesStateValid(await notesService.getallNotes()));
      },
    );
    on<ChangeFavourity>((event, emit) async {
      final NotesService notesService = NotesService();
      try{
        await notesService.changeFavourity(favourity: event.favourity, id: event.noteId,);
        emit(NotesStateValid(await notesService.getallNotes()));
      } on CouldNotUpdateNoteException {
        emit(NotesStateError(await notesService.getallNotes(), CouldNotUpdateNoteException(), "Could not change favourity of your note"));
        return;
      }
    },);
    on<ChangeItemOrder>((event, emit) async {
      final NotesService notesService = NotesService();
      for (var i = 0; i < event.notes.length; i++) {
        if(event.notes[i].order != i){
          try {
          await notesService.changeNoteOrder(index: i, id: event.notes[i].id!,);
        } on CouldNotUpdateNoteException {
          emit(NotesStateError(await notesService.getallNotes(), CouldNotUpdateNoteException(), "Could not change notes order"));
          return;
        }
        }

      }
      emit(NotesStateValid(await notesService.getallNotes()));
      },
    );
  }
}
