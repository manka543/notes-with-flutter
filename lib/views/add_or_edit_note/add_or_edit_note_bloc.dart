import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';
import 'package:notes/widgets/note_list_item.dart';

class AddOrEditNoteBloc extends Bloc<AddOrEditNoteEvent, AddOrEditNoteState> {
  AddOrEditNoteBloc() : super(const AddOrEditNoteInitialState(null)) {
    on<EditNoteEvent>(
      (event, emit) async {
        final notesService = NotesService();
        try {
          final DataBaseNote editednote =
              await notesService.updateNote(note: event.note!);
          emit(AddOrEditNoteStateValid(editednote));
        } on CouldNotUpdateNoteException {
          emit(const AddOrEditNoteStateError(null));
        }
      },
    );
    on<FinalEditEvent>(
      (event, emit) async {
        final notesService = NotesService();
        try {
          await notesService.updateNote(note: event.note!);
          emit(const UpdatedState());
        } on CouldNotCreateNoteException {
          emit(const AddOrEditNoteStateError(null));
        }
      },
    );
    on<EditNoteListItem>((event, emit) async {
      final notesService = NotesService();
        try {
          await notesService.updateListItem(item: event.item);
          emit(AddOrEditNoteStateValid(await notesService.getNote(id: event.noteId)));
        } on CouldNotUpdateNoteException {
          emit(const AddOrEditNoteStateError(null));
        }
    },);
    on<DeleteNoteEvent>(
      (event, emit) async {
        if (event.id == null) {
          emit(const DeletedState());
        } else {
          final notesService = NotesService();
          try {
            await notesService.deleteNote(id: event.id!);
          } on CouldNotDeleteException {
            emit(const AddOrEditNoteStateError(null));
          }
          emit(const DeletedState());
        }
      },
    );
    on<DeleteNoteListItem>((event, emit) async {
      final notesService = NotesService();
        try {
          await notesService.deleteListItem(id: event.id);
          emit(AddOrEditNoteStateValid(await notesService.getNote(id: event.noteId)));
        } on CouldNotUpdateNoteException {
          emit(const AddOrEditNoteStateError(null));
        }
    },);
    on<CreateEmptyNoteEvent>((event, emit) async {
      final notesService = NotesService();
      try {
        final DataBaseNote creatednote = await notesService.createNote(
            note: DataBaseNote(
          title: "",
          text: "",
          favourite: "false",
          date: DateTime.now(),
        ));
        emit(AddOrEditNoteStateValid(creatednote));
      } on CouldNotCreateNoteException {
        emit(const AddOrEditNoteStateError(null));
      }
    });
    on<CreateNoteListItem>((event, emit) async {
      final notesService = NotesService();
        try {
          await notesService.createListItem(item: event.item, noteID: event.noteId);
          emit(AddOrEditNoteStateValid(await notesService.getNote(id: event.noteId)));
        } on CouldNotUpdateNoteException {
          emit(const AddOrEditNoteStateError(null));
        }
    },);
    on<GetNoteEvent>(
      (event, emit) async {
        try {
          final NotesService notesService = NotesService();
          final note = await notesService.getNote(id: event.id);
          emit(AddOrEditNoteStateValid(
            note,
          ));
        } catch (exception) {
          emit(const AddOrEditNoteStateError(null));
        }
      },
    );
  }
}
