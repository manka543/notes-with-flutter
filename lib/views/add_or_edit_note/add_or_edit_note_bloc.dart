import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/services/notification_service.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';

class AddOrEditNoteBloc extends Bloc<AddOrEditNoteEvent, AddOrEditNoteState> {
  AddOrEditNoteBloc() : super(const AddOrEditNoteInitialState(null)) {
    on<EditNoteEvent>(
      (event, emit) async {
        print("I'm in edit note event");
        final notesService = NotesService();
        try {
          final DataBaseNote editednote =
              await notesService.updateNote(note: event.note!);
          if (editednote.rememberdate != null) {
            final notificationService = NotificationService();
            notificationService.cancelSheduledNotification(id: editednote.id!);
            notificationService.showScheduledNotification(
              id: editednote.id!,
              title: editednote.title,
              text: editednote.text,
              date: editednote.rememberdate!,
            );
          }
          print(editednote);
          emit(AddOrEditNoteStateValid(editednote));
        } on CouldNotCreateNoteException {
          emit(const AddOrEditNoteStateError(null));
        }
      },
    );
    on<FinalEditEvent>(
      (event, emit) async {
        print("I'm in final edit event");
        final notesService = NotesService();
        try {
          final DataBaseNote editednote =
              await notesService.updateNote(note: event.note!);
          if (editednote.rememberdate != null) {
            final notificationService = NotificationService();
            notificationService.cancelSheduledNotification(id: editednote.id!);
            notificationService.showScheduledNotification(
              id: editednote.id!,
              title: editednote.title,
              text: editednote.text,
              date: editednote.rememberdate!,
            );
          }
          print(editednote);
          emit(const UpdatedState());
        } on CouldNotCreateNoteException {
          emit(const AddOrEditNoteStateError(null));
        }
      },
    );
    on<DeleteNoteEvent>(
      (event, emit) async {
        if (event.id == null) {
          emit(const DeletedState());
        } else {
          final notesService = NotesService();
          try {
            await notesService.deleteNote(id: event.id!);
            final notificationService = NotificationService();
            notificationService.cancelSheduledNotification(id: event.id!);
          } on CouldNotDeleteException {
            emit(const AddOrEditNoteStateError(null));
          }
          emit(const DeletedState());
        }
      },
    );
    on<CreateEmptyNoteEvent>((event, emit) async {
      final notesService = NotesService();
      try {
        final DataBaseNote creatednote = await notesService.createNote(
            note: DataBaseNote(
          title: "",
          text: "",
          icon: "",
          date: DateTime.now(),
          rememberdate: null,
          id: null,
        ));
        print(creatednote);
        emit(AddOrEditNoteStateValid(creatednote));
      } on CouldNotCreateNoteException {
        emit(const AddOrEditNoteStateError(null));
      }
    });
    on<GetNoteEvent>(
      (event, emit) async {
        try {
          final NotesService notesService = NotesService();
          final note = await notesService.getNote(id: event.id);
          emit(AddOrEditNoteStateValid(
            note,
          ));
        } catch (exception) {
          print(exception);
          emit(const AddOrEditNoteStateError(null));
        }
      },
    );
  }
}
