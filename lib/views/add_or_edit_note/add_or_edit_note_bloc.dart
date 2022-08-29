import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/services/notes_service_exeptions.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';

class AddOrEditNoteBloc extends Bloc<AddOrEditNoteEvent, AddOrEditNoteState> {
  AddOrEditNoteBloc() : super(const AddOrEditNoteInitialState(null)) {
    on<EditNoteEvent>(
      (event, emit) async{
        print("I'm here too");
        final notesService = NotesService();
        try{
        final DataBaseNote editednote = await notesService.updateNote(note: event.note!);
        print(editednote);
        emit(AddOrEditNoteStateValid(editednote));
      } on CouldNotCreateNoteException {
        emit(const AddOrEditNoteStateError(null));
      } 
      },
    );
    on<DeleteNoteEvent>(
      (event, emit) async {
      final notesService = NotesService();
      try{
        final DataBaseNote emptynote = await notesService.createNote(note: DataBaseNote("", "", "share", DateTime.now(), null, null));
        emit(AddOrEditNoteStateValid(emptynote));
      } on CouldNotCreateNoteException {
        emit(const AddOrEditNoteStateError(null));
      }  
      },
    );
    on<CreateEmptyNoteEvent>((event, emit) async {
      final notesService = NotesService();
      try{
        final DataBaseNote creatednote = await notesService.createNote(note: DataBaseNote("trzecia notatka", "tu nic nie ma", "add_home_rounded", DateTime.now(), null, null));
        print(creatednote);
        emit(AddOrEditNoteStateValid(creatednote));
      } on CouldNotCreateNoteException {
        emit(const AddOrEditNoteStateError(null));
      }
    });
  }
}
