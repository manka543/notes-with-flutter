import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/services/notification_service.dart';
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
          final notificationService = NotificationService();
          notificationService.cancelSheduledNotification(id: event.id);
        } on CouldNotDeleteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotDeleteException(),
              "there was an error with deleting your note"));
        }
        emit(NotesStateValid(await notesService.getallNotes()));
      },
    );
    on<AddNote>(
      (event, emit) async {
        print("dodawanie notatki o tytule ${event.note.title}");
        final NotesService notesService = NotesService();
        try {
          final note = await notesService.createNote(note: event.note);
          if(note.rememberdate != null){
            final notificationService = NotificationService();
            notificationService.showScheduledNotification(id: note.id!, title: note.title, text: note.text, date: note.rememberdate!);
          }
        } on CouldNotCreateNoteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotDeleteException(),
              "there was an error with deleting your note"));
        }
        emit(NotesStateValid(await notesService.getallNotes()));
      },
    );
    on<UpdateNote>(
      (event, emit) async {
        print("updatowanie notatki o id: ${event.note.id}");
        final NotesService notesService = NotesService();
        try {
          final note = await notesService.updateNote(note: event.note);
          if(note.rememberdate != null){
            final notificationService = NotificationService();
            notificationService.cancelSheduledNotification(id: note.id!);
            notificationService.showScheduledNotification(id: note.id!, title: note.title, text: note.text, date: note.rememberdate!);
          }
        } on CouldNotDeleteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotDeleteException(),
              "there was an error with deleting your note"));
        }
        emit(NotesStateValid(await notesService.getallNotes()));
      },
    );
  }
}
