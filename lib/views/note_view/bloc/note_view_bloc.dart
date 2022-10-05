import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/views/notes/notes_event.dart';

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
          emit(NoteViewValid(await notesService.getNote(id: event.id)));
        } on CouldNotUpdateNoteException {
          emit(NoteViewError());
        }
      },
    );
    on<ChangeItemProgres>((event, emit) async {
      final NotesService notesService = NotesService();
      try {
        final updatedItem = await notesService.changeItemProgress(id: event.id, progress: event.progress);
        final index = event.note.listItems!.indexWhere((element) => element.id == event.id,);
        event.note.listItems![index] = updatedItem;
      } on CouldNotUpdateNoteException {
        emit(NoteViewError());
      }
      emit(NoteViewValid(event.note));
    });
    on<DeleteItem>((event, emit) async {
      final NotesService notesService = NotesService();
      try {
        await notesService.deleteListItem(id: event.id);
      } on CouldNotUpdateNoteException {
        emit(NoteViewError());
      }
      event.note.listItems!.removeWhere((element) => element.id == event.id);
      emit(NoteViewValid(event.note));
    });
  }
}
