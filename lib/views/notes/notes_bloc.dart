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
        if (event.archiveView == false) {
          final notes = await notesService.getallNotes();
          emit(NotesStateValid(
            notes,
          ));
        } else {
          final notes = await notesService.getArchivedNotes();
          emit(ArchivedNotesStateValid(
            notes,
          ));
        }
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
        emit(event.archiveView
            ? ArchivedNotesStateValid(await notesService.getArchivedNotes())
            : NotesStateValid(await notesService.getallNotes()));
      },
    );
    on<ChangeFavourity>(
      (event, emit) async {
        final NotesService notesService = NotesService();
        try {
          await notesService.changeFavourity(
            favourity: event.favourity,
            id: event.noteId,
          );
          emit(event.archiveView
              ? ArchivedNotesStateValid(await notesService.getArchivedNotes())
              : NotesStateValid(await notesService.getallNotes()));
        } on CouldNotUpdateNoteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotUpdateNoteException(),
              "Could not change favourity of your note"));
          return;
        }
      },
    );
    on<ChangeArchived>(
      (event, emit) async {
        final NotesService notesService = NotesService();
        try {
          await notesService.changeArchive(
            archiveStatus: event.archived,
            id: event.id,
          );
          emit(event.archiveView
              ? ArchivedNotesStateValid(await notesService.getArchivedNotes())
              : NotesStateValid(await notesService.getallNotes()));
        } on CouldNotUpdateNoteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotUpdateNoteException(),
              "Could not move your note to archive"));
        }
      },
    );
    on<ChangeNotesOrder>(
      (event, emit) async {
        final NotesService notesService = NotesService();
        for (var i = 0; i < event.notes.length; i++) {
          if (event.notes[i].order != i) {
            try {
              await notesService.changeNoteOrder(
                index: i,
                id: event.notes[i].id!,
              );
            } on CouldNotUpdateNoteException {
              emit(NotesStateError(
                  await notesService.getallNotes(),
                  CouldNotUpdateNoteException(),
                  "Could not change notes order"));
              return;
            }
          }
        }
        emit(event.archiveView
            ? ArchivedNotesStateValid(await notesService.getArchivedNotes())
            : NotesStateValid(await notesService.getallNotes()));
      },
    );
  }
}
