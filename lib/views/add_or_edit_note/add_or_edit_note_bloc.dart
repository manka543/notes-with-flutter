import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';

class AddOrEditNoteBloc extends Bloc<AddOrEditNoteEvent, AddOrEditNoteState> {
  AddOrEditNoteBloc() : super(const AddOrEditNoteInitialState(null)) {
    on<AddNoteEvent>((event, emit) {
      
    });
  }
}