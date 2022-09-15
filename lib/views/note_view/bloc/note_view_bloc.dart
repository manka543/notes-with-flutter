import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';

import '../../../services/awesome_notifications_service.dart';

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
      final deletedNote = await notesService.getNote(id: event.id);
      try {
        await notesService.deleteNote(id: event.id);
        if (deletedNote.rememberdate != null &&
            deletedNote.rememberdate!.isAfter(DateTime.now())) {
          final awesomeNotificationService = AwesomeNotificationService();
          awesomeNotificationService.cancelSheduledNotification(id: event.id);
        }
      } on CouldNotDeleteException {
        emit(NoteViewError());
      }
      emit(NoteViewExit());
    });
  }
}
