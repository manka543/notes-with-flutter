import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/awesome_notifications_service.dart';
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
        print("usuwanie notatki o id: ${event.id}");
        final NotesService notesService = NotesService();
        final oldNote = await notesService.getNote(id: event.id);
        try {
          await notesService.deleteNote(id: event.id);
          // final notificationService = NotificationService();
          // notificationService.cancelSheduledNotification(id: event.id);
          if (oldNote.rememberdate != null &&
              oldNote.rememberdate!.isAfter(DateTime.now())) {
            final awesomeNotificationService = AwesomeNotificationService();
            awesomeNotificationService.cancelSheduledNotification(id: event.id);
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
    on<AddNote>(
      (event, emit) async {
        print("dodawanie notatki o tytule ${event.note.title}");
        final NotesService notesService = NotesService();
        try {
          final note = await notesService.createNote(note: event.note);
          if (note.rememberdate != null &&
              note.rememberdate!.isAfter(DateTime.now())) {
            // final notificationService = NotificationService();
            // notificationService.showScheduledNotification(
            //     id: note.id!,
            //     title: note.title,
            //     text: note.text,
            //     date: note.rememberdate!);
            final awesomeNotificationService = AwesomeNotificationService();
            awesomeNotificationService.showScheduledNotification(
              id: note.id!,
              title: note.title,
              text: note.text,
              date: note.rememberdate!,
            );
          }
        } on CouldNotCreateNoteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotCreateNoteException(),
              "there was an error with deleting your note"));
        }
        emit(NotesStateValid(await notesService.getallNotes()));
      },
    );
    on<UpdateNote>(
      (event, emit) async {
        print("updatowanie notatki o id: ${event.note.id}");
        final NotesService notesService = NotesService();
        final awesomeNotificationService = AwesomeNotificationService();
        final oldNote = await notesService.getNote(id: event.note.id!);
        try {
          final note = await notesService.updateNote(note: event.note);
          if (oldNote.rememberdate != null &&
              oldNote.rememberdate!.isAfter(DateTime.now())) {
            awesomeNotificationService.cancelSheduledNotification(id: note.id!);
          }
          if (note.rememberdate != null) {
            // final notificationService = NotificationService();
            // notificationService.cancelSheduledNotification(id: note.id!);
            // notificationService.showScheduledNotification(
            //     id: note.id!,
            //     title: note.title,
            //     text: note.text,
            //     date: note.rememberdate!);
            awesomeNotificationService.showScheduledNotification(
              id: note.id!,
              title: note.title,
              text: note.text,
              date: note.rememberdate!,
            );
          }
        } on CouldNotUpdateNoteException {
          emit(NotesStateError(
              await notesService.getallNotes(),
              CouldNotUpdateNoteException(),
              "there was an error with deleting your note"));
        }
        emit(NotesStateValid(await notesService.getallNotes()));
      },
    );
  }
}
