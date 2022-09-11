import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/services/notification_service.dart';

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
          print(exception);
          emit(NoteViewError());
        }
    });
    on<DeleteNoteEvent>((event, emit) async {
      print("usuwanie notatki o id: ${event.id}");
        final NotesService notesService = NotesService();
        try {
          await notesService.deleteNote(id: event.id);
          final notificationService = NotificationService();
          notificationService.cancelSheduledNotification(id: event.id);
        } on CouldNotDeleteException {
          emit(NoteViewError());
        }
        emit(NoteViewExit());
    });
  }
}
